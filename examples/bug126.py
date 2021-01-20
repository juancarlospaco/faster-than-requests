import faster_than_requests

print(
  faster_than_requests.post(
    url          = "http://httpbin.org/post",
    body         = "{}",
    http_headers = [("Content-type", "application/json")])
)
