extends Control

# Please don't abuse! The limit is 60 requests per minute
var website = 'http://api.openweathermap.org/data/2.5/weather?APPID=2c54de0ef5f56b9ee04c6e6ab65c8966'
var cities_loaded = 0
var max_cities = len(global.city_list.keys())
var loading_bar_increment = 1024 / max_cities

func _ready():
	$LoadingBar.set_size(Vector2(0,4))
	var query = website + '&q=' + global.city_list.keys()[0]
	$HTTPRequest.request(query, PoolStringArray(), false)

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var json = JSON.parse(body.get_string_from_utf8())
	var kelvin = json.result['main']['temp']
	var celcius = ceil(kelvin - 273.15)
	var city_name = json.result['name']
	global.remote_data[city_name] = celcius
	# Loaded ended
	cities_loaded += 1
	$LoadingBar.set_size(Vector2(loading_bar_increment * (cities_loaded + 1),4))
	if cities_loaded == max_cities:
		get_tree().change_scene("res://NoteScene.tscn")
	else:
		var city = global.city_list.keys()[cities_loaded]
		var query = website + '&q=' + city
		$HTTPRequest.request(query, PoolStringArray(), false)
		#print(global.remote_data)
		#print(cities_loaded)
