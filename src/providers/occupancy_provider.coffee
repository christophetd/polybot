API_URL = "https://isa.epfl.ch/services/reservations/%date%/classroom/%room%"
format = require 'date-format'
request = require 'request'
Promise = require 'promise'
xmlParser = Promise.denodeify(require('xml2js').parseString)
strings = require './../utils/strings'
moment = require 'moment'

getOccupancy = (room) -> new Promise (resolve, reject) ->
    formattedDate = format.asString 'yyyy-MM-dd', new Date()
    url = API_URL.replace /%date%/, formattedDate
             .replace /%room%/, room.toUpperCase()

    fetch(url)
    .then (data) ->
        if data["classroom-reservations"] is "\n"
            resolve strings "occupancy_no_data", room
            return

        reservations = data["classroom-reservations"]["classroom"][0]["reservations"]
        [roomIsFree, courseName, courseType, courseEnd, nextCourse] = checkReservations reservations
        if roomIsFree
            if nextCourse?
                nextCourseStr = strings "occupancy_next_course", nextCourse.hour, nextCourse.name
            else
                nextCourseStr = ""
            resolve strings "occupancy_free", room, nextCourseStr
        else
            resolve strings "occupancy_busy", room, courseName, courseType, courseEnd

    .catch (err) ->
        reject strings "occupancy_error", room, err

checkReservations = (reservations) ->
    free = true
    course = null
    courseEnd = null
    courseType = null
    next = null
    nextHour = null
    for reservation in reservations[0].reservation
        [startTime, endTime] = [reservation["start-time"][0], reservation["end-time"][0]]
        [startHour, startMin] = startTime.split ":"
        [endHour, endMin] = endTime.split ":"
        courseStartTime = moment().hours(startHour).minutes(startMin)
        courseEndTime = moment().hours(endHour).minutes(endMin)

        if moment().isBetween(courseStartTime, courseEndTime)
            free = false
            course = reservation.course[0]._
            courseEnd = endTime
            courseType = reservation["class"][0]

        if not free
            next = reservation.course[0]._
            nextHour = startTime
            break
        else if moment().isBefore(courseStartTime) and next is null
            next = reservation.course[0]._
            nextHour = startTime

    nextObj = if next? then {name: next, hour: nextHour} else null
    return [free, course, courseType, courseEnd, nextObj]

fetch = (url) -> new Promise (resolve, reject) ->
    request url, (err, res, body) ->
        reject(err) if err?
        reject(res.statusCode) if res? and res.statusCode isnt 200
        xmlParser body
        .then resolve

module.exports = getOccupancy
