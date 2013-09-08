covet = require('./../lib/covet')

module.exports = drawRoutes: (app) ->
  covet.start(app)

  app.get '/bunnies/3', (req, res) ->
    res.json
      id: 3
      name: 'Frank'
      age: 12
