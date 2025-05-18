from bs4 import BeautifulSoup
import cloudscraper
import time

lst = "christian, righteous, amateur, character, parachute, monarchy, sugar, cache".split(", ")


for i in lst:
    url = f"https://www.oxfordlearnersdictionaries.com/definition/english/{i}?q={i}"
    scraper = cloudscraper.create_scraper()
    response = scraper.get(url)
    soup = BeautifulSoup(response.text, "html.parser")
    
    time.sleep(5)

    pro = soup.find("span", class_="phon").text
    print(i, pro)