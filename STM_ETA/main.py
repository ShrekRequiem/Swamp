import requests
import chardet
import gzip

# API details
base_path = "/pub/od/gtfs-rt/ic/v2"
host = "api.stm.info"
endpoint = "/tripUpdates"
scheme = "https"
api_key = "l715437ce8be134f6289457fe0ec8b6c05"

# Constructing the URL
url = f"{scheme}://{host}{base_path}{endpoint}"

# Adding API key to headers
headers = {"apiKey": api_key}

# Making the GET request
response = requests.get(url, headers=headers)

# Handling the response
if response.status_code == 200:
    # Successful response
    print("Success! Data received:")
#    print(response.content)
elif response.status_code == 400:
    print("Bad Request / Organization level rate limit and/or quota exceeded")
elif response.status_code == 404:
    print("Not Found")
elif response.status_code == 429:
    print("API level rate limit/or quota exceeded")
elif response.status_code == 500:
    print("Internal Error")
elif response.status_code == 503:
    print("Service Unavailable")
else:
    print(f"Unexpected error: {response.status_code}")
    print(response.content)

# Byte to text
response_object = response.content

with gzip.open(response_object, 'rb') as f:
    file_content = f.read()
    print(chardet.detect(file_content))
