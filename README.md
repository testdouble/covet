# Covet

[![Build Status](https://secure.travis-ci.org/testdouble/covet.png)](http://travis-ci.org/testdouble/covet)

Covet is a node module that creates or receives an [express](http://expressjs.com) application and defines a few routes that enable users to dynamically add new routes to the app (and then tear down those dynamic routes when needed).

The use case for this is almost exclusively integration tests which cross an HTTP boundary. When a test needs a way to stub a response to a particular request on a *remote* server, Covet provides a way to do it using HTTP.

## api

The API is in progress. Check out the primary integration [spec](https://github.com/testdouble/covet/blob/master/spec/lib/covet_spec.coffee) for examples.

## Running the tests

```
$ npm install -g lineman
$ npm install
$ lineman spec --stack
```

Should give you output in TAP13 like this:

```
Running "spec:files" (spec) task
1..12
ok 1 covet stubbing static GET route gets the bunny
ok 2 covet stubbing tearing down the previous example group successfully tears down to prevent test pollution
ok 3 covet stubbing dynamic, conditional GET route with an ID satisfied stubbing gets bunny
ok 4 covet stubbing dynamic, conditional GET route with an ID unsatisfied stubbings get nothing
ok 5 covet stubbing dynamic, conditional GET route with an ID and an Age satisfied stubbing gets bunny
ok 6 covet stubbing dynamic, conditional GET route with an ID and an Age unsatisfied stubbings get nothing
ok 7 covet stubbing dynamic, conditional POST route with an ID and an Age satisfied stubbing gets bunny
ok 8 covet stubbing dynamic, conditional POST route with an ID and an Age unsatisfied stubbings get nothing
ok 9 covet stubbing dynamic, conditional PUT route with an ID and an Age satisfied stubbing gets bunny
ok 10 covet stubbing dynamic, conditional PUT route with an ID and an Age unsatisfied stubbings get nothing
ok 11 covet stubbing dynamic, conditional DELETE route with an ID and an Age satisfied stubbing gets bunny
ok 12 covet stubbing dynamic, conditional DELETE route with an ID and an Age unsatisfied stubbings get nothing
# tests 12
# pass 12
# fail 0
```
