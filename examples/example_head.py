import faster_than_requests as requests
print(requests.head("http://httpbin.org/get"))  # HTTP HEAD.
