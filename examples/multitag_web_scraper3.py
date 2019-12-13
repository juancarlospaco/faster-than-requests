from faster_than_requests import scraper3
print(scraper3(list_of_urls=["https://nim-lang.org", "https://nim-lang.org"], list_of_tags=["h1"], case_insensitive=True, deduplicate_urls=True, line_start=4, line_end=6, post_replacements=[('class="section-heading"', "")]))
