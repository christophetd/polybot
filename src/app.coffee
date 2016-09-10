AwesomeBot      = require './core/AwesomeBot'
TelegramAdapter = require './core/TelegramAdapter'
fs              = require 'fs'
config          = require './config'
log             = require 'winston'

log.level = 'debug'

adapter = new TelegramAdapter(config.secrets.telegram)
bot = new AwesomeBot(adapter)
