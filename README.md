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
| PyCCurl (no SSL)              |  `0.68`  | >=15  | 5932 | Curl, LibCurl         | >=50       |
| Faster_than_requests (no SSL) |  `0.50`  | 1     | 50   | 0                     | 1          |
| Faster_than_requests          |  `0.45`  | 1     | 50   | 0                     | 1          |

- Lines Of Code counted using [CLOC](https://github.com/AlDanial/cloc).
- Direct dependencies of the package when ready to run.
- Benchmarks run on Docker from Dockerfile on this repo.
