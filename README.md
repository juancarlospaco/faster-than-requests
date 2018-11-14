# Faster-than-requests

[![screenshot](https://source.unsplash.com/eH_ftJYhaTY/800x402)](https://youtu.be/QiKwnlyhKrk?t=5)

| Library                       | Speed    | Files | LOC  | Dependencies          | Developers |
|-------------------------------|----------|-------|------|-----------------------|------------|
| PyWGET                        | `152.39` | 1     | 338  | Wget                  | >=17       |
| Requests                      | `15.58`  | >=20  | 2558 | >=7                   | >=527      |
| Requests (cached object)      |  `5.50`  | >=20  | 2558 | >=7                   | >=527      |
| Urllib                        |  `4.00`  | 1     | 1200 | 0 (std lib)           | ???        |
| Urllib3                       |  `3.55`  | >=40  | 5242 | 0 (No SSL), >=5 (SSL) | >=188      |
| PyCurl                        |  `0.75`  | >=15  | 5932 | Curl, LibCurl         | >=50       |
| PyCurl (no SSL)               |  `0.68`  | >=15  | 5932 | Curl, LibCurl         | >=50       |
| Faster_than_requests (no SSL) |  `0.50`  | 1     | 50   | 0                     | 1          |
| Faster_than_requests          |  `0.45`  | 1     | 50   | 0                     | 1          |

<details>

- Lines Of Code counted using [CLOC](https://github.com/AlDanial/cloc).
- Direct dependencies of the package when ready to run.
- Benchmarks run on Docker from Dockerfile on this repo.
- Developers counted from the Contributors list of Git.
- Stats as of year 2018.

</details>


# FAQ

- Whats the idea, inspiration, reason, etc ?.

[Feel free to Fork, Clone, Download, Improve, Reimplement, Play with this Open Source. Make it 10 times faster, 10 times smaller.](http://tonsky.me/blog/disenchantment)

- This works with SSL ?.

Yes.

- This works without SSL ?.

Yes.

- This requires Cython ?.

No.

- This runs on PyPy ?.

No.

- This runs on Python2 ?.

I dunno. (Not supported)

- It sends empty string as User-Agent ?.

Yes, for speed.

- Developer Documentation ?.

[Yes.](faster_than_requests_DOCS.zip) (Zip because GitHub marks the Repo as being JavaScript)

- How can I download it ?.

https://github.com/juancarlospaco/faster-than-requests/releases

- How to set the URL ?.

`url="http://example.com"` (1st argument always).

- How to set the HTTP Method ?.

`http_method="get"` for GET.

`http_method="post"` for POST.

`http_method="put"` for PUT.

`http_method="patch"` for PATCH.

- How to set the HTTP Body ?.

`body="my body"`

- How to set an HTTP Header key=value ?.

`("key", "value")`

- How can be faster than PyCurl ?.

I dunno.

- But Requests have more *options* ?.

I dunno.
