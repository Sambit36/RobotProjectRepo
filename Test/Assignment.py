import time

from selenium import webdriver
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()
driver.get(r"https://www.google.com/")

# verification of google.com page
Browser_title = driver.title
print("windowopened:", Browser_title)

driver.find_element(By.NAME, "q").click()
driver.find_element(By.NAME, "q").send_keys("amazon")
driver.find_element(By.XPATH, "//div[@class='o3j99 LLD4me yr19Zb LS8OJ']").click()
driver.find_element(By.XPATH, "//div[@class='FPdoLc lJ9FBc']//input[@name='btnK']").click()
time.sleep(2)

# printing all the results
all_links = driver.find_elements(By.TAG_NAME, "a")
for links in all_links:
    print(links)
