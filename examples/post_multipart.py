import faster_than_requests as requests

print( requests.post("http://httpbin.org/post", "", [("multi", "part"), ("key", "value")]) )

print( requests.post2str("http://httpbin.org/post",  "", [("multi", "part"), ("key", "value")]) )

print( requests.post2dict("http://httpbin.org/post", "", [("multi", "part"), ("key", "value")]) )

print( requests.post2json("http://httpbin.org/post", "", [("multi", "part"), ("key", "value")]) )
