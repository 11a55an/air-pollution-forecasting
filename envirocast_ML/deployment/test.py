import requests

# params = {"title":"Hassan is a terrorist"}
article = requests.post(f"http://ec2-16-16-98-137.eu-north-1.compute.amazonaws.com:8080/aqi")
print(type(article.text))
print("Output: ",article.text)