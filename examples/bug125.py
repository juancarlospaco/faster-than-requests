import faster_than_requests
faster_than_requests.init_client()
print(
  faster_than_requests.scraper(
    list_of_urls = ["http://nim-lang.org"], 
    html_tag = "a",
    case_insensitive = False,
    deduplicate_urls = True,
  )
)
faster_than_requests.close_client()
