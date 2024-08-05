#!/usr/bin/env python
# coding: utf-8

# * Amazon Web Scraping Using Python | Data Analyst Portfolio Project

# In[33]:


from bs4 import BeautifulSoup
import requests
import time
import datetime
import smtplib # this laibrary is for sending emails to your self.

import os


# In[44]:


# Connect to Website and pull in data

URL = 'https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_3?dchild=1&keywords=data%2Banalyst%2Btshirt&qid=1626655184&sr=8-3&customId=B0752XJYNL&th=1'

#headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36", "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

page = requests.get(URL)

soup1 = BeautifulSoup(page.content, "html.parser")

soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

title = soup2.find(id='productTitle')
if title is not None:
    title = title.get_text()
else:
    title = "null"
    
price = soup2.find(id='priceblock_ourprice')
if price is not None:
    price = price.get_text()
else:
    price = "0null"

print(text)
print(price)
# price = soup2.find(id='priceblock_ourprice').get_text() 
# here the price of this item is not available so it will cause an error of (AttributeError: 'NoneType' object has no attribute 'get_text')


# In[45]:


price = price.strip()[1:]
title = title.strip()

print(title)
print(price)


# In[38]:


#path = r"C:/Users/HP/OneDrive/Desktop/Tutorial/Python Tutorial/Amazon Web Scraping Using Python (Data Analyst Portfolio Project)/"
#if not os.path.exists(path + 'AmazonWebScraperDataset.csv'):# this code checks if the path does exist or not.
#    os.makedirs(path + 'AmazonWebScraperDataset.csv')


# In[46]:


import csv

file_path = 'C:/Users/HP/OneDrive/Desktop/Tutorial/Python Tutorial/Amazon Web Scraping Using Python (Data Analyst Portfolio Project)/AmazonWebScraperDataset.csv'
header = ['Title', 'Price']
data = [title, price]

with open(file_path, 'w', newline = '', encoding = 'UTF8') as f:# w means open the file in write mode.
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)


# In[49]:


today = datetime.date.today()
print(today)


# In[50]:


file_path = 'C:/Users/HP/OneDrive/Desktop/Tutorial/Python Tutorial/Amazon Web Scraping Using Python (Data Analyst Portfolio Project)/AmazonWebScraperDataset.csv'
header = ['Title', 'Price', 'Date']
data = [title, price,today]

with open(file_path, 'w', newline = '', encoding = 'UTF8') as f:# w means open the file in write mode.
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)


# In[59]:


import pandas as pd
df = pd.read_csv(file_path)# when having a variable there is no need to write r before it just incase of pulling the path without a variable. 
df


# In[ ]:


# appending data to the file

with open(file_path, 'a+', newline = '', encoding = 'UTF8') as f:# a+ means open the file in append mode.
    writer = csv.writer(f)
    writer.writerow(data)


# In[ ]:



def check_price():
    URL = 'https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_3?dchild=1&keywords=data%2Banalyst%2Btshirt&qid=1626655184&sr=8-3&customId=B0752XJYNL&th=1'

    #headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36", "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

    page = requests.get(URL)

    soup1 = BeautifulSoup(page.content, "html.parser")

    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")
    
    #get the elements
    title = soup2.find(id='productTitle')
    if title is not None:
        title = title.get_text()
    else:
        title = "null"
    
    price = soup2.find(id='priceblock_ourprice')
    if price is not None:
        price = price.get_text()
    else:
        price = "0null"
    
    #clean the retrieved element
    price = price.strip()[1:]
    title = title.strip()
    
    #get todays date
    import datetime
    today = datetime.date.today()
    
    #append the data to the created csv file
    import csv
    file_path = 'C:/Users/HP/OneDrive/Desktop/Tutorial/Python Tutorial/Amazon Web Scraping Using Python (Data Analyst Portfolio Project)/AmazonWebScraperDataset.csv'
    header = ['Title', 'Price', 'Date']
    data = [title, price,today]
    
    with open(file_path, 'a+', newline = '', encoding = 'UTF8') as f:# a+ means open the file in append mode.
    writer = csv.writer(f)
    writer.writerow(data)
    


# In[ ]:


# appending the data automation: 
while(True):
    check_price()
    time.sleep(86400)# this code is for appinding data for every one day.


# In[ ]:


import pandas as pd
df = pd.read_csv(file_path)# when having a variable there is no need to write r before it just incase of pulling the path without a variable. 
df

