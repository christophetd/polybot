Promise = require 'promise'
denodeify = require 'denodeify'
request   = denodeify(require 'request')
fs = require 'fs'
restaurants = JSON.parse(fs.readFileSync(__dirname + "/../../resources/restaurants.json"))
string = require './../utils/strings'
log = require 'winston'
moment = require 'moment'
API_URL="https://menus.epfl.ch/cgi-bin/ws-getMenus?date=:date:"

clean = (str) -> str.replace(/              /g, '').trim()

cleanRestaurantName = (rawName) -> rawName.replace(new RegExp("^((le|la|the) |l')", "g"), '').trim()

menu = (restaurant, date) ->
  restaurant = cleanRestaurantName restaurant
  restaurantInfo = findRestaurantInfo restaurant

  if !restaurantInfo?
    return Promise.reject(string "restaurant_unknown")

  request(API_URL.replace(':date:', date))
  .then (response) -> response.body
  .then filterMenus(restaurantInfo, date)
  .then formatMenus(restaurantInfo)
  .then (formattedString) -> restaurantName: restaurantInfo.restaurantName, menus: formattedString


formatMenus = (restaurantInfo) -> (menus) ->
  str = ""

  for menu in menus
    price = getMenuPrice(menu)
    str += menu.menuType

    if price? and price isnt '0.00'
      str += " ("+ price + " .-)"

    str += "\n"
    str += menu.platPrincipal
    if menu.accompFeculents?.trim()?
      str += ", " + menu.accompFeculents.trim()
    if menu.accompLegumes?.trim()?
      str += ", " + menu.accompLegumes.trim()
    str += "\n\n"

  str



getMenuPrice = (menu) ->
  if !menu.prix? or !menu.prix.length
    return

  for priceEntry in menu.prix
    if priceEntry.Etudiant?
      return priceEntry.Etudiant

    if priceEntry["Prix unique"]
      return priceEntry["Prix unique"]

filterMenus = (restaurantInfo, date) -> (data) ->

  try
    menus = JSON.parse(data).menus
  catch e
    Promise.reject(string "restaurant_menu_error")

  filtered = []

  for menu in menus
    if menu.restoID is restaurantInfo.id
      filtered.push(menu)

  if filtered.length is 0
    isToday = moment('DD-MM-YYYY', date).isSame(moment(), 'day')
    return Promise.reject(
      string("restaurant_no_menu")
      .replace(":name:", restaurantInfo.restaurantName)
      .replace(":day:", if isToday then string("today") else string("days")[0])
    )

  return filtered

findRestaurantInfo = (rname, err) ->
    rname = rname.toLowerCase()
    for {name, id, aliases} in restaurants
        if rname is name.toLowerCase() or rname.toLowerCase() in aliases or rname + "swag" in aliases
            return {id: id, restaurantName: name}

module.exports = menu
