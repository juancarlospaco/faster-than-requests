rm --verbose --force --recursive dist/faster_than_requests/faster_than_requests/
cp --verbose --recursive faster_than_requests/ dist/faster_than_requests/
cd dist && zip -9 -T -v -r faster_than_requests.zip *
