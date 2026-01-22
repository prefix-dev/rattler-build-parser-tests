from turbojpeg import TurboJPEG
import requests

url = "https://raw.githubusercontent.com/libjpeg-turbo/libjpeg-turbo/main/testimages/testorig.jpg"
r = requests.get(url, allow_redirects=True)
r.raise_for_status()

jpeg = TurboJPEG()

with open("testorig.jpg", "wb") as test_file:
    test_file.write(r.content)

with open("testorig.jpg", "rb") as in_file:
    bgr_array = jpeg.decode(in_file.read())

with open("output.jpg", "wb") as out_file:
    out_file.write(jpeg.encode(bgr_array))
