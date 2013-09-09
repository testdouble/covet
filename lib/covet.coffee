express = require('express')

module.exports =
  start: (app)->
    app.post '/covet/routes', express.bodyParser(), (req, res) ->
      stubbing = req.body
      foo = app[stubbing.verb] stubbing.path, express.bodyParser(), (req, res) ->
        res.json(stubbing.response)

      res.send(200)

  # stop: ->
    # remove dynamically created routes
    # remove the covet routes themselves
