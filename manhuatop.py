from bs4 import BeautifulSoup
import cloudscraper

url = "https://manhuatop.org/user-settings/?tab=bookmark"
cookies = {
    "wordpress_6bf9a13fe54a3762f2442ea569f3c203": "Quan064%7C1737909877%7Cg51pn0dzZ7Yd6m0o1YBCsSUv6u9RVZJaGPy5ecbXEp7%7C816541040894ad6f3a425d4b47e52128b07c7026bee1c1af13879f88f239ae64",
    "wordpress_logged_in_6bf9a13fe54a3762f2442ea569f3c203":	"Quan064%7C1737909877%7Cg51pn0dzZ7Yd6m0o1YBCsSUv6u9RVZJaGPy5ecbXEp7%7C01920e360952bb8d443fc2cc1647b568e74a688500dd6c28f867997375813e3f"
}

scraper = cloudscraper.create_scraper()
response = scraper.get(url, cookies=cookies)
soup = BeautifulSoup(response.text, "html.parser")
bm_lst = [(e.find("a").text, e.find("a")["href"]) for e in soup.find_all("h3")]

for name, link in bm_lst:
    print(link)
    response_i = scraper.get(link, cookies=cookies)
    soup_i = BeautifulSoup(response_i.text, "html.parser")
    chap_lst = soup_i.find("ul", class_="main version-chap no-volumn").find()
    cnt = 0
    chap_link = None
    while True:
        if chap_lst.get_attribute_list("class")[-1] == "reading":
            chap_link = chap_lst.find("a")["href"]
            break
        else:
            if chap_lst.find_next_sibling():
                chap_lst = chap_lst.find_next_sibling()
            else:
                break
        cnt += 1
    print(f"\t{cnt} ... {chap_link}")
    























# from selenium import webdriver
# from selenium.webdriver.common.by import By

# def Setup_ChromeDriver():
#     global driver

#     options = webdriver.ChromeOptions()
#     # options.add_argument("--headless")
#     options.add_argument("--disable-gpu")
#     options.add_argument("--disable-blink-features=AutomationControlled")
#     options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36")
#     options.add_argument("--start-maximized")
#     options.add_experimental_option("detach", True)
#     options.add_experimental_option("excludeSwitches", ["enable-automation"])
#     options.add_experimental_option('useAutomationExtension', False)
#     options.add_argument(r"user-data-dir=C:\Users\Hello\AppData\Local\Google\Chrome\User Data")
#     path = r'C:\Users\Hello\OneDrive\Code Tutorial\Python\Selenium_tutorial\chromedriver-win64\chromedriver.exe'
#     driver = webdriver.Chrome(options=options, executable_path=path)

# if __name__ == "__main__":
#     Setup_ChromeDriver()
#     driver.get("https://manhuatop.org/user-settings/?tab=bookmark")