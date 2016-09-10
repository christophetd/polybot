walk   = require 'fs-walk'
path   = require 'path'
log    = require 'winston'
Bot    = require './Bot'
config = require './../config'
_      = require 'underscore'

class AwesomeBot extends Bot
  constructor: (adapter) ->
    super(adapter)

    # Load the various handlers
    walk.walkSync config.handlers_dir, (baseDir, handlerFile, stat) =>
      unless stat.isDirectory()
        handler = require path.join(baseDir, handlerFile)
        if _.isFunction(handler)
          handler(this)
          handlerName = handlerFile.split(".coffee")[0]
          log.debug "Handler '#{handlerName}' loaded"

module.exports = AwesomeBot
