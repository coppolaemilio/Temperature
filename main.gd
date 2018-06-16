extends Node

func _ready():
	pass
	#$Music/Intro.play()
	#$HTTPRequest.request("https://coppolaemilio.com/Temperature/data.json",PoolStringArray(), false)

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
    var json = JSON.parse(body.get_string_from_utf8())
    print(json.result)

func _on_Intro_Music_finished():
	$Music/Background.play()
