import json
import requests
import math

# Loading API key from settings.
with open('settings', 'r') as f:
    API_ID = f.readline()

# List of cities
cities = ['Berlin', 'New York', 'San Francisco', 'Miami', 'Seattle', 'Toronto',
    'Mexico City', 'Rio De Janeiro', 'Buenos Aires', 'Cape Town', 'Stockholm',
    'Marrakech', 'Oslo', 'Helsinki', 'Brussels', 'Riga', 'Vilnius', 'Munich',
    'Amsterdam', 'Mumbai', 'Beijing', 'Tokyo', 'Osaka', 'Cairo', 'Istanbul',
    'Lagos', 'Moscow', 'Paris', 'Jakarta', 'London', 'Bangalore', 'Lima',
    'Seoul', 'Bogota', 'Johannesburg', 'Bangkok', 'Chicago', 'Tehran',
    'Hong Kong', 'Kuala Lumpur', 'Santiago', 'Madrid', 'Dallas', 'Singapore',
    'Barcelona', 'Valencia', 'Atlanta', 'Monterrey', 'Hanoi', 'Caracas',
    'Dublin', 'Lisbon', 'Rome', 'Zurich', 'Vienna', 'Prague', 'Warsaw', 'Kyoto',
    'Sydney', 'Havana', 'Brasilia']

def get_weather(city):
    """Get the temperature in °C"""
    website = 'api.openweathermap.org/data/2.5'
    r = requests.get('http://{website}/weather?APPID={api}&q={city}'.format(
            website = website,
            city = city,
            api = API_ID
        ))
    kelvin = r.json()['main']['temp']
    celcius = math.ceil(kelvin - 273.15)
    print(city, celcius)
    return celcius

# Collect and format all the data
data = {}
for city in cities:
    data[city] = get_weather(city)

# Save on a file
with open('data.json', 'w') as outfile:
    json.dump(data, outfile)