from faster_than_requests import scraper
print(scraper(["https://nim-lang.org", "https://nim-lang.org"], html_tag="h1", case_insensitive=False, deduplicate_urls=False, threads=False))
