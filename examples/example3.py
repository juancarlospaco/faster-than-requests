import time
import faster_than_requests


check_url = "https://httpbin.org/get"
lista = [(check_url, str(i) + ".json") for i in range(25)]


time2 = time.time()
faster_than_requests.downloads_list(lista, threads = True)
print(f'Faster_than_requests = {time.time() - time2}')
