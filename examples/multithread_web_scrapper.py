import faster_than_requests
print(faster_than_requests.scrapper(["https://nim-lang.org", "https://nim-lang.org"], html_tag = "h1", case_insensitive = False, deduplicate_urls = False, threads = False))
