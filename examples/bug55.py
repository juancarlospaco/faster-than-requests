import faster_than_requests

headers = [
  ("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"),
  ("Accept-Encoding", "gzip, deflate, br"),
  ("Accept-Language", "en-US,en;q=0.9"),
  ("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36")
]

print(faster_than_requests.requests("http://httpbin.org/get", "get", "", headers))
