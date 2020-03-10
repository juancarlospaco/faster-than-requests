import faster_than_requests as requests

with open(__file__) as f:
  print( requests.post("http://httpbin.org/post", f.read()) )
