extends Node

var VIEW_W = 1024
var BLANK_INPUT = '   '
var cities = global.cities
var cities_size = global.cities.size()
var city_index = 0
var city_limit = 13 # How many cities to show
var headlines_width = 0 # it gest calculated in the _ready() function
var remote_data = ''
var score = 0
var answer_scene = load("res://Scenes/Answer.tscn")
var time_dict = OS.get_time();
var game_ended = false
var sound = true
var game_started = false

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
	$HTTPRequest.request("https://coppolaemilio.com/Temperature/data.json",PoolStringArray(), false)
	
	# Making default states
	$Weather/Temperature.text = BLANK_INPUT
	$ScoreList.visible = true
	$ScoreList/Answer.visible = false
	$Weather.visible = true
	$EndMessage.visible = false
	
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
	

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var json = JSON.parse(body.get_string_from_utf8())
	remote_data = json.result

func _on_Intro_Music_finished():
	$Music/Background.play()

func _process(delta):
	# Current time
	var time_dict = OS.get_time();
	$Time/Title.text = (
		complete_time(time_dict.hour) + ':' + 
		complete_time(time_dict.minute) + ':' + 
		complete_time(time_dict.second)
	)
	
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

func add_answer(city, value, real, color):
	var scene_instance = answer_scene.instance()
	scene_instance.get_node('City').text = str(city)
	scene_instance.get_node('Value').text = str(value)
	scene_instance.get_node('Real').text = str(real)
	get_node('ScoreList').add_child(scene_instance)

func _input(event):
	if game_started:
		return false

	if event.is_action_pressed("ui_accept"):
		if game_ended:
			get_tree().reload_current_scene()
		if city_index + 1 <= city_limit - 1:
			var answer = $Weather/Temperature.text.replace(' ', '')
			var value = remote_data[cities[city_index]]
			
			print('---' + cities[city_index] + '---')
			print(answer)
			print(str(remote_data[cities[city_index]]))
			print('---')
			
			add_answer(
				cities[city_index],
				answer,
				remote_data[cities[city_index]],
				''
			)

			value = int(value)
			answer = int(answer)
			
			$WeatherGuy.visible = true
			$WeatherGuyFail.visible = false
			if value == answer:
				print('bingo!')
				score += 1000
				$Sound/yay.play()
			elif value == answer - 1 or value == answer + 1:
				print('Almost')
				score += 500
				$Sound/positive.play()
			elif value == answer - 2 or value == answer + 2:
				print('2 off')
				score += 250
				$Sound/positive.play()
			elif value == answer - 3 or value == answer + 3:
				print('3 off')
				score += 100
				$Sound/positive.play()
			elif value == answer - 4 or value == answer + 4:
				print('meeeh')
				score += 50
				$Sound/positive.play()
			else:
				$WeatherGuy.visible = false
				$WeatherGuyFail.visible = true
				$CameraOperator.set_animation('fail')
				$CameraOperator.alarm = true
				$Sound/error.play()
				print('nooooo')
				
			$ScoreLabel.text = 'Score: ' + str(score)
			$EndMessage/Score.text = str(score)
			$Weather/Temperature.text = BLANK_INPUT
			city_index += 1
			$Weather/CityName.text = cities[city_index]
		else:
			print('end')
			$Weather.visible = false
			$EndMessage.visible = true
			$ScoreList.visible = false
			game_ended = true
		
		print(score)
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
