# Faster-than-requests

[![screenshot](https://source.unsplash.com/eH_ftJYhaTY/800x402)](https://youtu.be/QiKwnlyhKrk?t=5)

![screenshot](temp.jpg)

| Library                       | Speed    | Files | LOC  | Dependencies          | Developers |
|-------------------------------|----------|-------|------|-----------------------|------------|
| PyWGET                        | `152.39` | 1     | 338  | Wget                  | >=17       |
| Requests                      | `15.58`  | >=20  | 2558 | >=7                   | >=527      |
| Requests (cached object)      |  `5.50`  | >=20  | 2558 | >=7                   | >=527      |
| Urllib                        |  `4.00`  | ???   | 1200 | 0 (std lib)           | ???        |
| Urllib3                       |  `3.55`  | >=40  | 5242 | 0 (No SSL), >=5 (SSL) | >=188      |
| PyCurl                        |  `0.75`  | >=15  | 5932 | Curl, LibCurl         | >=50       |
| PyCurl (no SSL)               |  `0.68`  | >=15  | 5932 | Curl, LibCurl         | >=50       |
| Faster_than_requests (no SSL) |  `0.50`  | 1     | 75   | 0                     | 1          |
| Faster_than_requests          |  `0.45`  | 1     | 75   | 0                     | 1          |

<details>

- Lines Of Code counted using [CLOC](https://github.com/AlDanial/cloc).
- Direct dependencies of the package when ready to run.
- Benchmarks run on Docker from Dockerfile on this repo.
- Developers counted from the Contributors list of Git.
- Speed is IRL time to complete 10000 HTTP local requests.
- Stats as of year 2018.

</details>


# Use

```python
import faster_than_requests as requests
print(requests.gets("http://httpbin.org/get"))  # See Docs for more info.
```

- `gets()` HTTP GET.
- `posts()` HTTP POST.
- `puts()` HTTP PUT.
- `deletes()` HTTP DELETE.
- `patchs()` HTTP PATCH.
- `get2str()` HTTP GET body only :arrow_right: string.
- `get2str_list()` HTTP GET body from a list :arrow_right: string.
- `get2ndjson_list()` HTTP GET body from a list :arrow_right: NDJSON.
- `get2dict()` HTTP GET body only :arrow_right: dictionary.
- `get2json()` HTTP GET body only :arrow_right: JSON.
- `get2json_pretty()` HTTP GET body only :arrow_right: Pretty-Printed JSON.
- `get2assert()` HTTP GET body only to assert from expected argument for unittests.
- `post2str()` HTTP POST data only :arrow_right: string.
- `post2dict()` HTTP POST data only :arrow_right: dictionary.
- `post2json()` HTTP POST data :arrow_right: JSON.
- `post2json_pretty()` HTTP POST data :arrow_right: Pretty-Printed JSON.
- `post2assert()` HTTP POST body only to assert from expected argument for unittests.
- `downloads()` HTTP GET Download 1 file.
- `downloads_list()` HTTP GET Download a list of files.
- `downloads_list_delay()` HTTP GET Download a list of files with delay, optional randomized delay.


# Docker

- Make a quick test drive on Docker!.

```bash
$ ./build-docker.sh
$ ./run-docker.sh
$ ./run-benchmark.sh  # Inside Docker.
```


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

- Developer Documentation ?.

[Yes.](https://github.com/juancarlospaco/faster-than-requests/raw/master/faster_than_requests_DOCS.zip)
(Zip because GitHub marks the Repo as being JavaScript)

- How can I Install it ?.

https://github.com/juancarlospaco/faster-than-requests/releases

If you dont understand how to install it, you can just download, extract, put the files on the same folder as your `*.py` file and you are good to go.

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

- Whats the No SSL version for ?.

No SSL is smaller but no HTTPS.
Feel free to delete it if you want.

- Whats NDJSON ?.

https://github.com/ndjson/ndjson-spec

- How can be faster than PyCurl ?.

I dunno.

- But Requests have more *options* ?.

Yes.
