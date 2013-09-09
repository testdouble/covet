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
        console.log("body id is, ", req.params.id, " and with id is: ", stubbing.with?.id)
        if stubbing.verb == "get" && stubbing.with
          stubbingWithId = "#{stubbing.with.id}"
        if !stubbing.with? || req.params.id == stubbingWithId
          res.json(stubbing.response)
        else
          res.send(404)
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
