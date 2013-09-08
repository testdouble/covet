global.expect = require('chai').expect

request = require('request')
global.get = (path, success) ->
  request {url: "http://localhost:8000/#{path}", json: true}, (err, res, body) ->
    success(body, res, err)
