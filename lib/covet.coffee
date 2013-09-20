express = require('express')
_ = require('underscore')

stubbedRoutes = []

module.exports =
  start: (options)->
    config = extendDefaultConfig(options)
    app = config.app

    if (config.routes.catchAllRoute)
      app.all config.routes.catchAllRoute, express.bodyParser(), (req, res) ->
        # match any unmatched route and send a 404
        res.send(404)

    app.post config.routes.addRoute, express.bodyParser(), (req, res) ->
      stubbing = req.body
      app[stubbing.verb] stubbing.path, express.bodyParser(), (req, res) ->
        if stubbingSatisfied(req, stubbing.request)
          response = if stubbing.response? then stubbing.response else {}
          statusCode = if stubbing.response.statusCode? then stubbing.response.statusCode else 200
          res.send(statusCode, response.json)
        else
          res.send(400)

      newRoute = _(app.routes[stubbing.verb]).last()
      app.routes[stubbing.verb] = [newRoute].concat(_(app.routes[stubbing.verb]).initial())
      stubbedRoutes.push(newRoute)
      res.send(201)

    app.delete config.routes.resetRoutes, (req, res) ->
      _(stubbedRoutes).each (route) ->
        removeFromArray(app.routes[route.method], route)
      stubbedRoutes = []
      res.send(204)

    # move the post and delete routes we just added to the beginning in case the app
    # has a catch all route defined
    covetRoute = _(app.routes['post']).last()
    app.routes['post'] = [covetRoute].concat(_(app.routes['post']).initial())
    covetRoute = _(app.routes['delete']).last()
    app.routes['delete'] = [covetRoute].concat(_(app.routes['delete']).initial())

extendDefaultConfig = (options = {}) ->
  _(options).tap (options) ->
    options.port ||= process.env.COVET_PORT || 8000
    options.app ||= createApp(options.port)
    options.routes ||= {}
    options.routes.catchAllRoute ||= undefined
    options.routes.addRoute ||= "/covet/routes"
    options.routes.resetRoutes ||= "/covet/routes"

removeFromArray = (array, itemToRemove) ->
  if (index = array.indexOf(itemToRemove))?
    array.splice(index, 1)

createApp = (port) ->
  _(express()).tap (app) -> app.listen(port)

stubbingSatisfied = (actualRequest, rawExpectedRequest) ->
  return true unless rawExpectedRequest?
  expectedRequest = massageRequest(rawExpectedRequest)

  isEqual(expectedRequest, actualRequest)

massageRequest = (request) ->
  _(request).inject (memo, value, attr) ->
    memo[attr] = switch attr
      when "params" then stringifyValues(value)
      else value
    memo
  , {}

stringifyValues = (object) ->
  _(object).inject (memo, value, key) ->
    memo[key] = String(value)
    memo
  , {}

isEqual = (expected, actual) ->
  _(expected).all (expectedValue, key) ->
    switch key
      when "params" then _(expected.params).all (v,k) -> _(v).isEqual(actual.params[k])
      else _(expectedValue).isEqual(actual[key])

