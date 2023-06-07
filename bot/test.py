import requests
import time
i=1
interval= 1/int(input("requests per second: "))
while True:
    resp= requests.get(url=f"http://localhost/api/foos?val=TEST{i}")
    i=i+1
    print(resp.text)
    time.sleep(interval)