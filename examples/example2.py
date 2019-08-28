import time
import requests
import faster_than_requests as reqs


time1 = time.time()
for i in range(9):
  requests.get("https://httpbin.org/get").content
print(f'Requests = {time.time() - time1}')

time2 = time.time()
for i in range(9):
  reqs.get2str("https://httpbin.org/get")
print(f'Faster_than_requests = {time.time() - time2}')


# $ python3 example2.py
# Requests = 7.90063419342041
# Faster_than_requests = 2.0017221927642822
