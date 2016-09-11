log     = require 'winston'
Promise = require 'promise'
request = Promise.denodeify( require 'request' )
string  = require './../utils/strings'
moment  = require 'moment'

OPENDATA_TRANSPORT_API="http://transport.opendata.ch/v1/connections?from=Ecublens+VD,+EPFL&to="

directions =
  RENENS: 'Renens VD, Gare'
  LAUSANNE: 'Lausanne-Flon'


getSchedule = (direction) ->
  log.debug direction
  url = OPENDATA_TRANSPORT_API + encodeURIComponent(directions[direction])
  log.debug url
  request(url)
  .then (res) -> transformResponse JSON.parse(res.body)

transformResponse = (data) ->
  if !data?.connections or !data?.connections.length
    return Promise.reject( string 'transportation_no_data' )

  times = []
  log.debug data.connections[0].from.departureTimestamp
  times.push moment.unix(data.connections[0].from.departureTimestamp)
  times.push moment.unix(data.connections[1].from.departureTimestamp)
  times.push moment.unix(data.connections[2].from.departureTimestamp)

  return direction: data.connections[0].to.station.name, schedule: times

module.exports.getNextMetro = (direction) ->
  if direction is 'BOTH'
    promise = Promise.all [ getSchedule('LAUSANNE'), getSchedule('RENENS') ]
  else
    promise = getSchedule(direction)

  promise
