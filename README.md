# Faster-than-requests

[![screenshot](https://source.unsplash.com/eH_ftJYhaTY/800x402)](https://youtu.be/QiKwnlyhKrk?t=5)

| Library                       | Speed  | Files | LOC  | Dependencies        |
|-------------------------------|--------|-------|------|---------------------|
| PyWGET                        | 152.39 | 1     | 338  | Wget                |
| Requests                      | 15.58  | >=20  | 2558 | 7                   |
| Requests (cached session)     |  5.50  | >=20  | 2558 | 7                   |
| Urllib                        |  4.00  | 1     | 1200 | 0 (std lib)         |
| Urllib3                       |  3.55  | >=40  | 5242 | 0 (No SSL), 5 (SSL) |
| PyCurl                        |  0.75  | >=15  | 5932 | Curl, LibCurl       |
| PyCCurl (no SSL)              |  0.68  | >=15  | 5932 | Curl, LibCurl       |
| Faster_than_requests (no SSL) |  0.50  | 1     | 50   | 0                   |
| Faster_than_requests          |  0.45  | 1     | 50   | 0                   |

- Lines Of Code counted using [CLOC](https://github.com/AlDanial/cloc).
- Direct dependencies of the package when ready to run.
- Benchmarks run on Docker from Dockerfile on this repo.
