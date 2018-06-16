import json
import requests
import math

# Loading API key from settings.
with open('settings', 'r') as f:
    API_ID = f.readline()

# List of cities
cities = ['Berlin', 'New York City', 'San Francisco', 'Miami', 'Seattle', 'Toronto',
    'Mexico City', 'Rio De Janeiro', 'Buenos Aires', 'Cape Town', 'Stockholm',
    'Marrakech', 'Oslo', 'Helsinki', 'Tallin', 'Riga', 'Vilnius', 'Munich',
    'Amsterdam', 'Mumbai', 'Beijing', 'Tokyo', 'Osaka', 'Cairo', 'Istanbul',
    'Lagos', 'Moscow', 'Paris', 'Jakarta', 'London', 'Bangalore', 'Lima',
    'Seoul', 'Bogota', 'Johannesburg', 'Bangkok', 'Chicago', 'Tehran',
    'Hong Kong', 'Kuala Lumpur', 'Santiago', 'Madrid', 'Dallas', 'Singapore',
    'Barcelona', 'Valencia', 'Atlanta', 'Monterrey', 'Hanoi', 'Caracas',
    'Dublin', 'Lisbon', 'Rome', 'Zurich', 'Vienna', 'Prague', 'Warsaw', 'Kyoto',
    'Sydney', 'Havana', 'Brasilia']

cities = ['Berlin', 'New York City', 'San Francisco', 'Miami', 'Seattle', 'Toronto']

def get_weather(city):
    """Get the temperature in °C"""
    city = city.replace(' ', '%20')
    website = 'api.openweathermap.org/data/2.5'
    r = requests.get('http://{website}/weather?APPID={api}&q={city}'.format(
            website = website,
            city = city,
            api = API_ID
        ))
    kalvin = r.json()['main']['temp']
    celcius = math.ceil(kalvin - 273.15)
    return celcius

# Collect and format all the data
data = {}
for city in cities:
    data[city] = get_weather(city)

# Save on a file
with open('data.json', 'w') as outfile:
    json.dump(data, outfile)