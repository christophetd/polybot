lyr         = require 'lyric-get'
config      = require './../config'
withMessage = require './../utils/strings'
tr          = require('yandex-translate')(config.secrets.yandex)
log         = require 'winston'

module.exports = (artist, song) -> new Promise (resolve, reject) ->
  lyr.get artist, song, (err, res) ->
    if err?
      return reject withMessage 'lyrics_song_not_found'
      
    tr.translate res, to: 'fr', (err, translated) ->
      if err?
        return reject withMessage 'lyrics_error', err
      resolve translated.text[0]
