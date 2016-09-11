string                = require './../utils/strings'
log                   = require 'winston'
transportationService = require './../providers/transportation_provider'
moment                = require 'moment'

directions =
  LAUSANNE:
    aliases: ['lausanne flon', 'lausanneflon', 'flon']
  RENENS:
    aliases: ['renens gare', 'gare de renens']

normalizeDirection = (rawDirection) ->
  rawDirection = rawDirection
    .toLowerCase()
    .replace(/[^a-zA-Z]/g, '')
    .replace(/\s{2,}/g, ' ')
    .trim()

  for directionName, obj in directions
    if obj.aliases.indexOf(rawDirection) >= 0
      return directionName

  return 'BOTH'

config =
  intent: 'get_metro_schedule'
  regex: /^\/metro (.*)/

module.exports = (bot) -> bot.hear config, (res, data) ->
  direction = if data.intent then data.parameters.metro_direction else data.matches[1]
  direction = direction || ''

  transportationService.getNextMetro (normalizeDirection(direction))
  .then (schedules) ->
    str = ''
    for schedule in schedules
      str += string('transportation_direction', schedule.direction)
      for time in schedule.schedule
        waitTime = Math.round(moment.duration(time.diff(moment())).asMinutes())
        if waitTime is 0
          waitTimeStr = string 'transportation_now'
        else if waitTime is 1
          waitTimeStr = string 'transportation_minutes_singular', waitTime
        else
          waitTimeStr = string 'transportation_minutes_plural', waitTime

        str += string('transportation_item', time.format('kk:mm'), waitTimeStr)
      str += '\n'

    res.reply str
