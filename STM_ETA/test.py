import requests

# Making a get request
response = requests.get('https://api.github.com')

# printing request content
print(response.content)
