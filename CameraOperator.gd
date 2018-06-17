extends AnimatedSprite
var counter = 0
var alarm = false

func _process(delta):
	if alarm == true:
		counter += 1
	if counter > 150:
		alarm = false
		counter = 0
		animation = 'default'
