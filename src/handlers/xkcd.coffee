xkcdProvider = require './../providers/xkcd_provider'

###
module.exports = (bot) -> bot.hear /^\/xkcd/, (res) ->
  xkcdProvider()
  .then (stream) -> res.sendPhoto stream
  .catch (err) -> res.reply "unknown error"
###
