menusProvider = require './../providers/menus_provider'
strings       = require './../utils/strings'
log           = require 'winston'
moment        = require 'moment'

config =
  intent: 'get_menus'
  regex: /^\/menu (.*)/

SATURDAY = 6

module.exports = (bot) -> bot.hear config, (res, data) ->
  restaurant = if data.intent then data.parameters.restaurant_name else data.matches[1]
  if !restaurant?
    return res.replyMessage "restaurant_no_name"

  date = moment()
  dayOfWeek = date.weekday()
  if dayOfWeek >= SATURDAY
    date = date.add(8 - dayOfWeek, 'days') # next monday
    weekend = true
    dayString = strings("days")[dayOfWeek - 1]  # current day in human readable form

  formattedDate = date.format('DD/MM/YYYY')

  menusProvider(restaurant, formattedDate)
  .then ( {restaurantName, menus } ) ->
    if weekend
      res.replyMessage("restaurant_answer_weekend", dayString, restaurantName, menus)
    else
      res.replyMessage("restaurant_answer", restaurantName, menus)
  .catch res.reply
