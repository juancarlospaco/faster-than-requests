import faster_than_requests

faster_than_requests.download3(
  list_of_files = [("http://NONEXISTENT", "a.json"), ("http://NONEXISTENT", "a.json")],
  delay = 1, tries = 9, backoff = 2, verbose = True, jitter = 2,
)
