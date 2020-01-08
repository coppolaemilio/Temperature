extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if event.is_action_pressed('unit_c'):
		global.unit = 'c'
	if event.is_action_pressed('unit_f'):
		global.unit = 'f'
	get_tree().change_scene("res://NoteScene.tscn")
