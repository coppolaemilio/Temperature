import time
import os

iteration = 0

while True:
  os.system('python weather.py')
  os.system('lazygit "updating data"')
  time.sleep(60 * 60)
  iteration += 1
  print('[+] ', str(iteration))