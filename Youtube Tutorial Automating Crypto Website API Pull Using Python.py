#!/usr/bin/env python
# coding: utf-8

# * Automating Crypto Website API Pull Using Python

# In[1]:


from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json

url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest' 
#Original Sandbox Environment: 'https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
# The parameters dictionary contains the parameters for the API request.
parameters = {
  'start':'1',
  'limit':'15',
  'convert':'USD'
}
#The headers dictionary contains the headers for the API request.
headers = {
  'Accepts': 'application/json',
  'X-CMC_PRO_API_KEY': '0ad53085-1cb2-4eb8-ad9e-3ffbd7e56509',
}
#A Session object allows you to persist certain parameters across requests.
session = Session()
session.headers.update(headers)

try:
  response = session.get(url, params=parameters)
  data = json.loads(response.text)
  #print(data)
except (ConnectionError, Timeout, TooManyRedirects) as e:
  print(e)

#NOTE:
# I had to go in and put "jupyter notebook --NotebookApp.iopub_data_rate_limit=1e10"
# Into the Anaconda Prompt to change this to allow to pull data

# If that didn't work try using the local host URL as shown in the video


# In[2]:


type(data)


# In[3]:


import pandas as pd


# In[4]:


#This allows you to see all the columns, not just like 15
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)


# In[5]:


#This normalizes the data and makes it all pretty in a dataframe

df = pd.json_normalize(data['data'])
df['timestamp'] = pd.to_datetime('now')
df


# In[24]:


def api_runner():
    global df
    url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest' 
    #Original Sandbox Environment: 'https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
    # The parameters dictionary contains the parameters for the API request.
    parameters = {
      'start':'1',
      'limit':'15',
      'convert':'USD'
    }
    #The headers dictionary contains the headers for the API request.
    headers = {
      'Accepts': 'application/json',
      'X-CMC_PRO_API_KEY': '0ad53085-1cb2-4eb8-ad9e-3ffbd7e56509',
    }
    #A Session object allows you to persist certain parameters across requests.
    session = Session()
    session.headers.update(headers)

    try:
      response = session.get(url, params=parameters)
      data = json.loads(response.text)
      #print(data)
    except (ConnectionError, Timeout, TooManyRedirects) as e:
      print(e)
    # here we append the new created data frame to the original data frame.
    df = pd.json_normalize(data['data'])
    df['timestamp'] = pd.to_datetime('now')
    df
    # Use this if you just want to keep it in a dataframe
    df2 = pd.json_normalize(data['data'])
    df2['Timestamp'] = pd.to_datetime('now')
    df = df.append(df2)
    
    #save the data into a csv file(the following code is incase we wanna save the data to a csv file and append into it)
    #if not os.path.isfile(r'C:\Users\HP\OneDrive\Desktop\Tutorial\Python Tutorial\2. Automating Crypto Website API Pull Using Python\API.csv'):# this will check if the file existed if not it will creat one.
    #    df.to_csv(r'C:\Users\HP\OneDrive\Desktop\Tutorial\Python Tutorial\2. Automating Crypto Website API Pull Using Python\API.csv', header = 'column_names')
    #else:   
    #   df.to_csv(r'C:\Users\HP\OneDrive\Desktop\Tutorial\Python Tutorial\2. Automating Crypto Website API Pull Using Python\API.csv', mode = 'a', header = False)# a means append, header false means we do not need to append data with headers again.


# In[25]:


import os 
from time import time
from time import sleep

for i in range(333):
    api_runner()
    print('API Runner completed')
    sleep(60)# the for loop will be run each 60 seconds.
exit()


# In[11]:


pd.read_csv(r'C:\Users\HP\OneDrive\Desktop\Tutorial\Python Tutorial\2. Automating Crypto Website API Pull Using Python\API.csv')


# In[ ]:





# In[26]:


pd.set_option('display.float_format', lambda x: '%.5f' % x)


# In[27]:


df


# In[28]:


df3 = df.groupby('name', sort = False)[['quote.USD.percent_change_1h', 'quote.USD.percent_change_24h', 'quote.USD.percent_change_7d', 'quote.USD.percent_change_30d','quote.USD.percent_change_60d','quote.USD.percent_change_90d']].mean()
df3


# In[12]:


df4 = df3.stack()
df4


# In[18]:


type(df4)


# In[29]:


df5 = df4.to_frame(name = 'values')
df5


# In[30]:


df5.count()


# In[31]:


index = pd.Index(range(90))

df6 = df5.reset_index()
df6


# In[32]:


df7 = df6.rename(columns = {'level_1' : 'percent_change'})
df7


# In[33]:


df7['percent_change'] = df7['percent_change'].replace(['quote.USD.percent_change_1h','quote.USD.percent_change_24h' , 'quote.USD.percent_change_7d', 'quote.USD.percent_change_30d', 'quote.USD.percent_change_60d', 'quote.USD.percent_change_90d'], ['1h', '24h', '7d', '30d', '60d', '90d'])
df7


# In[34]:


import seaborn as sns
import matplotlib.pyplot as plt


# In[35]:


sns.catplot(x = 'percent_change', y = 'values', data = df7, kind = 'point')


# In[37]:


df10 = df[['name', 'quote.USD.price', 'timestamp']]
df10 = df10.query("name == 'Bitcoin'") 
df10


# In[39]:


sns.set_theme(style = "darkgrid")
sns.lineplot(x = 'timestamp', y = 'quote.USD.price', data = df10)


# In[ ]:





# In[ ]:




