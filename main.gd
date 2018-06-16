extends Node

func _ready():
	#var current_city = cities[randi() % cities.size()]
	#print(current_city)
	$HTTPRequest.request("http://api.openweathermap.org/data/2.5/weather?APPID=2c54de0ef5f56b9ee04c6e6ab65c8966&q=London")

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
    var json = JSON.parse(body.get_string_from_utf8())
    print(json.result)