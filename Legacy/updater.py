import time
import os

iteration = 0

while True:
  os.system('python3 weather.py')
  os.system('git add .')
  os.system('git commit -m "updating data"')
  os.system('git push')
  time.sleep(60 * 60)
  iteration += 1
  print('[+] ', str(iteration))
