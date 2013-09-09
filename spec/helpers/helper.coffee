root = global

root.expect = require('chai').expect

request = require('request')

urlFor = (path) -> "http://localhost:8000/#{path}"

root.get = (path, callback) ->
  request {url: urlFor(path), json: true}, (err, res, body) ->
    callback?(body, res, err)

root.post = (path, params, callback) ->
  console.log(params.id)
  request.post {url: urlFor(path), json: params}, (err, res, body) ->
    callback?(body, res, err)
