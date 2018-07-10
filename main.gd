extends Node

var VIEW_W = 1024
var BLANK_INPUT = '   '
var cities = global.remote_data.keys()
var cities_size = cities.size()
var city_index = 0
var city_limit = 12 # How many cities to show
var headlines_width = 0 # it gest calculated in the _ready() function
var remote_data = global.remote_data
var score = 0
var answer_scene = load("res://Scenes/Answer.tscn")
var answer_messages = {
	'perfect': load("res://Scenes/AnswerMessagePerfect.tscn"),
	'almost': load("res://Scenes/AnswerMessageAlmost.tscn"),
	'fair': load("res://Scenes/AnswerMessageFair.tscn"),
	'wrong': load("res://Scenes/AnswerMessageWrong.tscn"),
	'sigh': load("res://Scenes/AnswerMessageSigh.tscn"),
	'what': load("res://Scenes/AnswerMessageWhat.tscn"),
	'not_really': load("res://Scenes/AnswerMessageNotReally.tscn"),
}
var time_dict = OS.get_time();
var game_ended = false
var game_started = false
var show_hand = false
var sound = true
var intro_finished = false
var intro_timer = 530

var note_text = {
	'fired': 'You are fired. But first, we have another broadcast in ten seconds so, lets get this over with.',
	'bad': 'That was bad, but at least you tried... We have another broadcast in ten seconds so, hang in there.',
	'good': 'Ok, close enough! Congratulations, you keep your job! We have another broadcast in ten seconds so stay focused!',
	'verygood': 'Very good! You see? These screens are overrated. Ok, we have another broadcast in ten seconds so, keep doing what you do best.',
	'perfect': 'That was perfect! We will get rid of the screens moving forward, we will save a lot of money! We have another broadcast in ten seconds. Go get them champ!'
}

func complete_time(number):
	if number < 10:
		return '0' + str(number)
	return str(number)

func shuffle_list(list):
    var shuffled_list = [] 
    var index_list = range(list.size())
    for i in range(list.size()):
        var x = randi()%index_list.size()
        shuffled_list.append(list[index_list[x]])
        index_list.remove(x)
    return shuffled_list



func _ready():
	randomize()
	$Music/Intro.play()
	$IntroSlide/Intro.play('default')
	
	# Making default states
	$Weather/Temperature.text = BLANK_INPUT
	$ScoreList.visible = true
	$ScoreList/Answer.visible = false
	$Weather.visible = true
	$EndMessage.visible = false
	$Hand.visible = false
	$BestScore/Score.text = str(global.best_score)
	
	if global.unit == 'f':
		$Weather/F.visible = true
		$Weather/C.visible = false
	else:
		$Weather/C.visible = true
		$Weather/F.visible = false
	
	# Creating headlines string
	var news_text = ''
	global.news = shuffle_list(global.news)
	for headline in global.news:
    	news_text = news_text + '              ' + headline
	$News/Headlines.text = news_text
	
	# Altering the list order
	cities = shuffle_list(cities)
	$Weather/CityName.text = cities[city_index]
	
	# Set the headlines width
	headlines_width = $News/Headlines.get_total_character_count() * 13


func _on_Intro_Music_finished():
	$Music/Background.play()

func _process(delta):
	# Limit input of player while animation
	if intro_finished == false:
		if intro_timer < 0:
			intro_finished = true
		else:
			intro_timer -= 1
	# Current time
	var time_dict = OS.get_time();
	$Time/Title.text = (
		complete_time(time_dict.hour) + ':' + 
		complete_time(time_dict.minute) + ':' + 
		complete_time(time_dict.second)
	)
	
	# Best score
	if global.best_score == 0:
		$BestScore.visible = false
	else:
		$BestScore.visible = true
	# Moving headlines
	$News/Headlines.rect_position[0] -= 1
	if $News/Headlines.rect_position[0] < headlines_width * -1:
		$News/Headlines.rect_position[0] = VIEW_W
	

func set_number(number):
	var text = $Weather/Temperature.text
	if text == BLANK_INPUT or text == '-  ':
		text[2] = number
	elif text[1] == ' ' and text[2] != ' ':
		text[1] = text[2]
		text[2] = number
	elif text[1] != ' ' and text[2] != ' ':
		text = text[0] + ' ' + number
	elif text[1] != ' ' and text[2] == ' ':
		text[2] = number
	
	$Weather/Temperature.text = text

func add_answer(city, value, real, color, kind):
	var scene_instance = answer_scene.instance()
	value = str(value)
	real = str(real)
	if value.length() == 1:
		value = ' ' + value
	if real.length() == 1:
		real = ' ' + real
	scene_instance.get_node('City').text = str(city)
	scene_instance.get_node('Value').text = value
	scene_instance.get_node('Real').text = real
	
	scene_instance.get_node('Value').add_color_override("font_color", Color(color))
	get_node('ScoreList').add_child(scene_instance)
	
	# Clear previous messages
	for child in get_node('AnswerContainer').get_children():
		child.queue_free()
	
	var message_instance = answer_messages[kind].instance()
	get_node('AnswerContainer').add_child(message_instance)
		

func choose(array):
	return array[randi() % array.size()]
	
func _input(event):
	if intro_finished == false:
		return false
	if game_started:
		return false

	if event.is_action_pressed("ui_accept"):
		if game_ended:
			if show_hand == false:
				show_hand = true
				$Hand.visible = true
				$Sound/paper.play()
				return
			elif show_hand:
				get_tree().reload_current_scene()
		if city_index <= city_limit:
			var answer = $Weather/Temperature.text.replace(' ', '')
			var value = remote_data[cities[city_index]]

			value = int(value)
			answer = int(answer)
			
			$WeatherGuy.visible = true
			$WeatherGuyFail.visible = false
			var color = '#a5f0f0'
			var kind = 'wrong'
			if value == answer:
				kind = 'perfect'
				color = '#39d4d7'
				score += 1000
				$Sound/yay.play()
			elif value == answer - 1 or value == answer + 1:
				kind = 'almost'
				color = '#abd6bb'
				score += 500
				$Sound/positive.play()
			elif value == answer - 2 or value == answer + 2:
				kind = 'fair'
				color = '#e1ca76'
				score += 250
				$Sound/positive.play()
			elif value == answer - 3 or value == answer + 3:
				kind = 'fair'
				color = '#e1ca76'
				score += 100
				$Sound/positive.play()
			elif value == answer - 4 or value == answer + 4:
				kind = 'fair'
				color = '#e1ca76'
				score += 50
				$Sound/positive.play()
			else:
				kind = choose(['wrong', 'sigh', 'what', 'not_really'])
				$WeatherGuy.visible = false
				$WeatherGuyFail.visible = true
				$CameraOperator.set_animation('fail')
				$CameraOperator.alarm = true
				$Sound/error.play()
				color = '#d55a32'
			
			add_answer(
				global.city_list[cities[city_index]],
				answer,
				remote_data[cities[city_index]],
				color,
				kind
			)
				
			$ScoreLabel.text = 'Score: ' + str(score)
			$EndMessage/Score.text = str(score)
			$Weather/Temperature.text = BLANK_INPUT
			city_index += 1
			$Weather/CityName.text = cities[city_index]
			if city_index + 1 == city_limit:
				city_index += 1
				$Weather/CityName.text = cities[city_index]
		if city_index > city_limit:
			$Weather.visible = false
			$EndMessage.visible = true
			$ScoreList.visible = true
			if score >= 1000 and score <= 1500 :
				$Hand/Stay/Label.text = note_text['bad']
			if score >= 1500 and score <= 2500 :
				$Hand/Stay/Label.text = note_text['good']
			if score >= 2500 and score <= 3500 :
				$Hand/Stay/Label.text = note_text['verygood']
			if score > 11000:
				$Hand/Stay/Label.text = note_text['perfect']
			if score < 1000:
				$Sound/boo.play()
				$Hand/Stay/Label.text = note_text['fired']
			else:
				$Sound/cheer.play()
			if score > global.best_score:
				global.best_score = score
				$BestScore/Score.text = str(global.best_score)
			game_ended = true

	if event.is_action_pressed("ui_delete"):
		var text = $Weather/Temperature.text
		if text[1] == ' ' and text[2] != ' ':
			text[2] = ' '
		elif text[1] != ' ' and text[2] != ' ':
			text[2] = text[1]
			text[1] = ' '
		elif text[1] != ' ' and text[2] == ' ':
			text[1] = ' '
		elif text[0] == '-' and text[1] == ' ' and text[2] == ' ':
			text = BLANK_INPUT
		$Weather/Temperature.text = text
	
	if event.is_action_pressed("ui_negative"):
		if $Weather/Temperature.text[0] == '-':
			$Weather/Temperature.text[0] = ' '
		else:
			$Weather/Temperature.text[0] = '-'
	# There might be a better way of doing this
	# but there is no time!!!! :)
	if event.is_action_pressed("ui_music_toggle"):
		if sound:
			AudioServer.set_bus_volume_db(0,0)
			sound = false
		else:
			AudioServer.set_bus_volume_db(0,1)
			sound = true
	if event.is_action_pressed("number_1"):
		set_number("1")
	if event.is_action_pressed("number_2"):
		set_number("2")
	if event.is_action_pressed("number_3"):
		set_number("3")
	if event.is_action_pressed("number_4"):
		set_number("4")
	if event.is_action_pressed("number_5"):
		set_number("5")
	if event.is_action_pressed("number_6"):
		set_number("6")
	if event.is_action_pressed("number_7"):
		set_number("7")
	if event.is_action_pressed("number_8"):
		set_number("8")
	if event.is_action_pressed("number_9"):
		set_number("9")
	if event.is_action_pressed("number_0"):
		set_number("0")
