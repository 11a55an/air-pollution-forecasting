import requests

# params = {"title":"Hassan is a terrorist"}
article = requests.post(f"http://127.0.0.1:5000/aqi")
print(type(article.text))
print("Output: ",article.text)