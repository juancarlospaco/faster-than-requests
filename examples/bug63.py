import requests
import faster_than_requests
import pycurl
import time


print("Normal Requests")
timeStart = time.perf_counter()
for _ in range(10):
    res = requests.get('https://twitter.com/')
    print(".")
timeEnd = time.perf_counter() - timeStart
averageTime = timeEnd / 10
timeEnd = round(timeEnd, 4)
print(f"Made 10 requests with an average of {averageTime} seconds each")


print("PyCurl Requests")
timeStart = time.perf_counter()
for _ in range(10):
    c = pycurl.Curl()
    c.setopt(c.URL, 'https://twitter.com/')
    c.setopt(pycurl.SSL_VERIFYPEER, 0)
    c.perform_rs()
    res = c
    print(".")
timeEnd = time.perf_counter() - timeStart
averageTime = timeEnd / 10
timeEnd = round(timeEnd, 4)
print(f"Made 10 requests with an average of {averageTime} seconds each")


print("Faster than Requests")
timeStart = time.perf_counter()
for _ in range(10):
    res = faster_than_requests.get2str('https://twitter.com/')
    print(".")
timeEnd = time.perf_counter() - timeStart
averageTime = timeEnd / 10
timeEnd = round(timeEnd, 4)
print(f"Made 10 requests with an average of {averageTime} seconds each")
