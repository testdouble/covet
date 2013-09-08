# Covet

Covet is a node module that creates or receives an [express](http://expressjs.com) application and defines a few routes that enable users to dynamically add new routes to the app (and then tear down those dynamic routes when needed).

The use case for this is almost exclusively integration tests which cross an HTTP boundary. When a test needs a way to stub a response to a particular request on a *remote* server, Covet provides a way to do it using HTTP.

## api

Example usage in CoffeeScript & jQuery

### dynamically creating a new route

``` coffeescript

$.post '/covet/routes',
  verb: 'get'
  path: '/bunnies/3'
  response:
    id: 3
    name: "Frank"
    age: 12
```

Subsequently, the application could call a function like this with `3`:

``` coffeescript
getBunny = (id) ->
  $.get "/bunnies/#{id}", (response) ->
    alert(response.name)
```

And see the alert.

### resetting all routes

``` coffeescript
$.ajax
  url: '/covet/routes',
  type: 'DELETE'
```

## todo

* Support stringified regex paths with a "regex" boolean
