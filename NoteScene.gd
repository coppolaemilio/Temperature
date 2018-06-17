extends Node

var counter = 0
var limit = 150
var end = false
var text_index = 0

func cache_invalidation():
	randomize()
	var value = str(range(1,11)[randi()%range(1,11).size()]) + str(range(1,11)[randi()%range(1,11).size()]) + str(range(1,11)[randi()%range(1,11).size()]) + str(range(1,11)[randi()%range(1,11).size()])
	return value

func _ready():
	var dataurl = "https://coppolaemilio.com/Temperature/data.json?" + cache_invalidation()
	print('Requesting weather data: ' + dataurl)
	$HTTPRequest.request(dataurl,PoolStringArray(), false)
	
	
	$Hand/ShowUp.visible = false
	$Hand/Stay.visible = false
	$Hand/Stay/Label.visible = true
	$Hand/Stay/Label2.visible = false

func _process(delta):
	if end == false:
		counter += 1
	if counter > limit:
		counter = 0
		end = true
		$Hand/ShowUp.visible = true
		$Hand/ShowUp.play('default')

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var json = JSON.parse(body.get_string_from_utf8())
	global.remote_data = json.result

func _on_ShowUp_animation_finished():
	$Hand/ShowUp.visible = false
	$Hand/Stay.visible = true
	$Hand/Stay.play('default')

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if text_index == 0:
			$Hand/Stay/Label.visible = false
			$Hand/Stay/Label2.visible = true
			text_index += 1
		elif text_index == 1:
			get_tree().change_scene("res://main.tscn")

