extends AnimatedSprite

var fade_in = 150

func _ready():
	pass

func _process(delta):
	fade_in -= 1
	if fade_in < 0:
		self.queue_free()