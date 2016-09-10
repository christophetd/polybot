request = require 'request'
config  = require './../config'

URL_MAP =
	'now' : 'http://api.openweathermap.org/data/2.5/weather?q=lausanne,ch&units=metric&appid=',
	'today' : 'http://api.openweathermap.org/data/2.5/forecast/daily?q=lausanne,ch&units=metric&cnt=1&appid=',
	'tomorrow' : 'http://api.openweathermap.org/data/2.5/forecast/daily?q=lausanne,ch&units=metric&cnt=2&appid='
PRED_MAP =
	'today' : 0,
	'tomorrow' : 1


module.exports = -> new Promise (resolve, reject)  ->
	if weatherParam not in ['now','today', 'tomorrow']
		weatherParam = 'now'
	url = URL_MAP[weatherParam]
	pred_nb = PRED_MAP[weatherParam]
	request url + config.secrets.owm, (err, res, body) ->
		reject err if err?
		reject res.statusCode if res? and res.statusCode isnt 200

		result = JSON.parse body

		if weatherParam is 'now'
			celsius = result.main.temp
			resolve celsius + " degrees - " + result.weather[0].description
		else
			min = result.list[pred_nb].temp.min
			max = result.list[pred_nb].temp.max
			resolve "min: " + min + " degrees - max: " + max + " degrees - " + result.list[pred_nb].weather[0].description
