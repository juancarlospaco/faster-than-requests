from faster_than_requests import scrapper2
print(scrapper2(["https://nim-lang.org", "https://nim-lang.org"], list_of_tags=["h1", "a"], case_insensitive=False, deduplicate_urls=False))
