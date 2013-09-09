express = require('express')
_ = require('underscore')

stubbedRoutes = []

module.exports =
  start: (options)->
    config = extendDefaultConfig(options)
    app = config.app

    app.post config.routes.addRoute, express.bodyParser(), (req, res) ->
      stubbing = req.body
      app[stubbing.verb] stubbing.path, express.bodyParser(), (req, res) ->
        respondWithStatusCode = stubbing.statusCode || 200
        expectedParams = massageExpectedParams(stubbing)
        actualParams = getActualParams(req,stubbing.verb)

        if !stubbing.with? || isEqual(expectedParams, actualParams)
          res.send(respondWithStatusCode, stubbing.response)
        else
          res.send(400)

      stubbedRoutes.push(_(app.routes[stubbing.verb]).last())
      res.send(201)

    app.delete config.routes.resetRoutes, (req, res) ->
      _(stubbedRoutes).each (route) ->
        removeFromArray(app.routes[route.method], route)
      res.send(204)

extendDefaultConfig = (options = {}) ->
  _(options).tap (options) ->
    options.port ||= process.env.COVET_PORT || 8000
    options.app ||= createApp(options.port)
    options.routes ||= {}
    options.routes.addRoute ||= "/covet/routes"
    options.routes.resetRoutes ||= "/covet/routes"

removeFromArray = (array, itemToRemove) ->
  if (index = array.indexOf(itemToRemove))?
    array.splice(index, 1)

createApp = (port) ->
  _(express()).tap (app) -> app.listen(port)

massageExpectedParams = (stubbing) ->
  if !stubbing.with?
    null
  else if stubbing.verb != "post"
    # stringify the URL params
    _(stubbing.with).inject (memo, value, key) ->
      memo[key] = String(value)
      memo
    , {}
  else
    stubbing.with

getActualParams = (req, verb) ->
  if verb == "post"
    req.body
  else
    req.params

isEqual = (expected, actual) ->
  _(expected).all (expectedValue, key) ->
    actual[key] == expectedValue
