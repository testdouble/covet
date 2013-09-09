express = require('express')
_ = require('underscore')

stubbedRoutes = []

module.exports =
  start: (app = createApp())->

    app.post '/covet/routes', express.bodyParser(), (req, res) ->
      stubbing = req.body
      app[stubbing.verb] stubbing.path, express.bodyParser(), (req, res) ->
        res.json(stubbing.response)
      stubbedRoutes.push(_(app.routes[stubbing.verb]).last())
      res.send(201)

    app.delete '/covet/routes', (req, res) ->
      _(stubbedRoutes).each (route) ->
        removeFromArray(app.routes[route.method], route)
      res.send(204)

removeFromArray = (array, itemToRemove) ->
  if (index = array.indexOf(itemToRemove))?
    array.splice(index, 1)

createApp = () ->
  _(express()).tap (app) -> app.listen(process.env.COVET_PORT || 8000)
