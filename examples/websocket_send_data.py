import faster_than_requests as requests
print(requests.websocket_send("ws://echo.websocket.org", "data here"))