extends Node

var remote_data = {}
var best_score = 0
var unit = 'c'

var city_list = {
	'Berlin': 'BER',
	'New York': 'NYC',
	'San Francisco': 'SFO',
	'Miami': 'MIA',
	'Seattle': 'SEA',
	'Toronto': 'YTO',
	'Mexico City': 'MEX',
	'Buenos Aires': 'BUE',
	'Cape Town': 'CAP',
	'Stockholm': 'STO',
	'Marrakech': 'MAR',
	'Oslo': 'OSL',
	'Helsinki': 'HEL',
	'Vilnius': 'VIL',
	'Munich': 'MUN',
	'Amsterdam': 'AMS',
	'Mumbai': 'MBI',
	'Beijing': 'BEI',
	'Tokyo': 'TYO',
	'Osaka': 'OSA',
	'Cairo': 'CAI',
	'Istanbul': 'IST',
	'Lagos': 'LAG',
	'Moscow': 'MOS',
	'Paris': 'PAR',
	'Jakarta': 'JAK',
	'London': 'LON',
	'Bangalore': 'BAN',
	'Lima': 'LIM',
	'Seoul': 'SEO',
	'Bogota': 'BOG',
	'Bangkok': 'BAN',
	'Chicago': 'CHI',
	'Hong Kong': 'HNK',
	'Kuala Lumpur': 'KUA',
	'Santiago': 'SAN',
	'Madrid': 'MAD',
	'Singapore': 'SIN',
	'Barcelona': 'BNC',
	'Valencia': 'VLC',
	'Atlanta': 'ATL',
	'Hanoi': 'HAN',
	'Caracas': 'CAR',
	'Dublin': 'DUB',
	'Lisbon': 'LIS',
	'Rome': 'ROM',
	'Zurich': 'ZUR',
	'Vienna': 'VIE',
	'Prague': 'PRA',
	'Warsaw': 'WAR',
	'Kyoto': 'KYO',
	'Sydney': 'SYD',
	'Havana': 'HAV',
	'Brasilia': 'BRA'
}


var news = [
	'Some people disagree',
	'The president of a country does something',
	'A natural disaster happened very far from your home',
	'Bitcoin crashed',
	'BitCoin through the roof again',
	'BitCoin in free fall again',
	'BitCoin very high once more',
	'No, BitCoin actually falling',
	'It seems like Bitcoin is up!',
	'Supreme Court rules against memes',
	'Country full of emigrants is not accepting immigrants',
	'A very old superhero gets its own movie',
	'Godot finally dominates the entire gaming market',
	'There is a new song that everybody hates',
	'Noble inaugurates place',
	'Dogs earns the right to walk humans again',
	'Why are you reading this?',
	'Man walking dog abducted by UFO. Dog tells the story',
	'Everyone goes crazy after some team wins at sport',
	'Please send help! I am stuck inside the writers room!',
	'Man wins millions in lottery, spends it all in Sea-Monkeys',
	'Another attorney sues himself by accident',
	'Man dies after a pin-pong ball rain',
	'Postman beaten by maple bush, sues nature',
	'Experts claim the world will end tomorrow, and this time for real',
	'Experts celebrate after erroneous end-of-the-world announcement',
	'Old man yells at cloud',
	'Most advanced AI refuses to watch cat pictures',
	'Countries of the world in debt with all countries of the world.',
	'Coffeehouse chain CEO: having utter-worldwide-monopoly is not fun anymore',
]

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()