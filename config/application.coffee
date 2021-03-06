# Exports an object that defines
#  all of the configuration needed by the projects'
#  depended-on grunt tasks.
#
# You can familiarize yourself with all of Lineman's defaults by checking out the parent file:
# https://github.com/testdouble/lineman/blob/master/config/application.coffee
#

module.exports = require(process.env["LINEMAN_MAIN"]).config.extend "application",
  removeTasks:
    common: ["coffee", "less", "jshint", "handlebars", "jst", "concat", "images:dev", "webfonts:dev", "pages:dev"]
    dev: ["server"]
    dist: ["uglify", "cssmin", "images:dist", "webfonts:dist", "pages:dist"]

  appendTasks:
    common: ["spec"]

  spec:
    options:
      bail: false
      timeout: 3000
      ignoreLeaks: false
      ui: 'bdd'
      reporter: 'tap'

    files:
      src: ['spec/lib/**/*']


  watch:
    spec:
      files: ["lib/**/*", "spec/lib/**/*"]
      tasks: ["spec"]
