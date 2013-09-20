covet = require('./../../lib/covet')
express = require('express')
_ = require("underscore")

root = global

root.expect = require('chai').expect

request = require('request')

host = process.env.COVET_HOST || "localhost"
port = process.env.COVET_PORT || 8000

urlFor = (path) ->
  "http://#{host}:#{port}/#{path}"

handle = (callback) ->
  (err, res, body) ->
    callback?(body, res, err)

root.get = (path, callback) ->
  request {url: urlFor(path), json: true}, handle(callback)

root.post = (path, params, callback) ->
  request.post {url: urlFor(path), json: params}, handle(callback)

root.put = (path, params, callback) ->
  request.put {url: urlFor(path), json: params}, handle(callback)

root.del = (path, callback) ->
  request.del {url: urlFor(path)}, handle(callback)

covet.start
  app: _(express()).tap (app) ->
    app.all '*', (req, res) -> res.send(404)
    app.listen(process.env.COVET_PORT || 8000)
