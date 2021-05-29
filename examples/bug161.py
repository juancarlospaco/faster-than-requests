import faster_than_requests

urls = [
  "https://source.unsplash.com/random/666x420",
  "https://source.unsplash.com/random/666x420",
  "https://source.unsplash.com/random/666x420",
]

lista = faster_than_requests.get2str2(urls)

with open("0.png", "wb") as f:
  f.write(lista[0])

with open("1.png", "wb") as f:
  f.write(lista[1])

with open("2.png", "wb") as f:
  f.write(lista[2])
