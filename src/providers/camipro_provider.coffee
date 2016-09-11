log         = require 'winston'
Promise     = require 'promise'
request     = Promise.denodeify( require 'request' )

CAMIPRO_URL="https://mycamipro.epfl.ch/ws/balance"
TEQUILA_LOGIN_URL="https://tequila.epfl.ch/cgi-bin/tequila/requestauth?requestkey="
LOGIN_WAIT_TIME_MS=20*1000

users_keys = {}

getTequilaRequestKey = (user_id) ->

  request(CAMIPRO_URL, followRedirect: false)
  .then (data) ->
    if !data.headers?.location
      return Promise.reject("authentification tequila impossible")

    key = data.headers.location.split("requestkey=")[1]
    if !key?
      return Promise.reject("unexpected location header")

    users_keys[user_id] = key
    return key
  .catch (err) ->
    log.debug "Could not get tequila request key from camipro website"
    log.debug err
    Promise.reject("error from camipro website")

getCamiproBalance = (key) ->
  log.debug "Trying to get camipro balance now, key=#{key}"
  config =
    url: CAMIPRO_URL
    headers:
      Cookie: "tequilaPHP=#{key}"

  request(config)

module.exports.LOGIN_WAIT_TIME_MS = LOGIN_WAIT_TIME_MS

module.exports.getBalance = (response, user_id) ->
  if users_keys[user_id]?
    keyPromise = Promise.resolve(users_keys[user_id])
  else
    keyPromise = getTequilaRequestKey(user_id)
    .then (key) ->
      response.replyMessage "balance_login", TEQUILA_LOGIN_URL+key, LOGIN_WAIT_TIME_MS/1000
      return key
    .then (key) -> new Promise (resolve, reject) ->
      users_keys[user_id] = key
      setTimeout(resolve.bind(null, key), LOGIN_WAIT_TIME_MS)

  keyPromise.then (key) -> getCamiproBalance(key)
  .then (data) -> JSON.parse(data.body).PersonalAccountBalance
