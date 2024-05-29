import requests

# params = {"title":"Hassan is a terrorist"}
article = requests.post("http://127.0.0.1:8080/aqi")
print(type(article.text))
print("Output: ",article.text)