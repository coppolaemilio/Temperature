extends Node

func _ready():
	#var current_city = cities[randi() % cities.size()]
	#print(current_city)
	$HTTPRequest.request("https://coppolaemilio.com/Temperature/data.json",PoolStringArray(), false)

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
    var json = JSON.parse(body.get_string_from_utf8())
    print(json.result)