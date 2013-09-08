Mocha = require('mocha')

module.exports = (grunt) ->
  _ = grunt.util._

  grunt.registerMultiTask "spec", "run specs (under mocha)", ->
    done = @async()
    mocha = new Mocha(@options())
    @filesSrc.forEach(mocha.addFile.bind(mocha))


    grunt.file.expand("#{process.cwd()}/spec/helpers/**/*").forEach (f) -> require(f)

    mocha.run (errorCount) -> done(errorCount == 0)

