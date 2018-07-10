extends Node

var counter = 0
var limit = 150
var end = false
var text_index = 0
var sound_played = 0
var loading_weird_delay = 20

func cache_invalidation():
	randomize()
	var value = str(range(1,11)[randi()%range(1,11).size()]) + str(range(1,11)[randi()%range(1,11).size()]) + str(range(1,11)[randi()%range(1,11).size()]) + str(range(1,11)[randi()%range(1,11).size()])
	return value

func _ready():
	if global.unit == 'f':
		for val in global.remote_data:
			var celcius = global.remote_data[val]
			global.remote_data[val] = round(9.0/5.0 * celcius + 32)
	
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
	if text_index == 2:
		"""
		I had to add this weird count down 
		because otherwise the loading screen
		would not go to visible before tryting
		to change the room.
		"""
		loading_weird_delay -= 1
		if loading_weird_delay < 0:
			get_tree().change_scene("res://main.tscn")

func _on_ShowUp_animation_finished():
	if sound_played == 0:
		$Sound/Paper.play()
		sound_played = 1
	$Hand/ShowUp.visible = false
	$Hand/Stay.visible = true
	$Hand/Stay.play('default')

func _input(event):
	if $Hand/Stay.visible == true:
		if event.is_action_pressed("ui_accept"):
			if text_index == 0:
				$Sound/Paper.play()
				$Hand/Stay/Label.visible = false
				$Hand/Stay/Label2.visible = true
				text_index += 1
			elif text_index == 1:
				$Loading.visible = true
				text_index += 1

