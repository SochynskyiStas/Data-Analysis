
# coding: utf-8

# In[8]:


import urllib.request
import pandas as pd
import io
import ssl
from sklearn.cluster import KMeans
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import pyplot as plt
from scipy.cluster.hierarchy import dendrogram, linkage
import numpy as np
from sklearn import datasets
get_ipython().magic('matplotlib inline')


# Виконуємо імпорт даних

# In[9]:


excel = pd.ExcelFile('data.xlsx')
data_frame=excel.parse("Лист1")
data_frame=data_frame.drop(data_frame.index[0])


# In[10]:


X = data_frame[['Production_vol', 'Income', 'salaries']]


# Робимо розрахунки відстаней між данними за різними методами. Для того, щоб побудувати дерево ієрархій.

# In[11]:


from scipy.cluster.hierarchy import cophenet
from scipy.spatial.distance import pdist


euc_dist = pdist(X, 'euclidean')
manh_dist =pdist(X,'cityblock')
ham_dist=pdist(X, 'hamming')
cheb_dist=pdist(X,'chebyshev')

print("Евклідова відстань", euc_dist)
print("Манхетенська", manh_dist)
print("Хеммінгова відстань",ham_dist)
print("Відстань Чебишева",cheb_dist)


# In[12]:


plt.figure(figsize=(24,12))
plt.hist(euc_dist, 200, color='blue', alpha=0.5)
plt.show()


# Графік розподілу відстаней. 

# In[13]:


plt.figure(figsize=(24,12))
plt.hist(manh_dist, 100, color='red', alpha=0.5)
plt.show()


# In[14]:


Z = linkage(euc_dist, method='average')


# Зв'язуємо дані за середнім значенням.

# In[15]:


plt.figure(figsize=(24,12))
plt.tick_params(axis='both', which='major')
dendrogram(Z, color_threshold=5, leaf_font_size=5, count_sort=True)

plt.show()


# Виконуємо нормування даних по minmax. Розраховуємо відстані, але вже з нормованими даними.

# In[16]:


from sklearn import preprocessing
min_max_scaler = preprocessing.MinMaxScaler()
X_norm = min_max_scaler.fit_transform(X)


# In[17]:


euc_dist1 = pdist(X_norm, 'euclidean')
manh_dist1=pdist(X_norm,'cityblock')
ham_dist1=pdist(X_norm, 'hamming')
cheb_dist1=pdist(X_norm,'chebyshev')

print("Евклідова відстань", euc_dist1)
print("Манхетенська", manh_dist1)
print("Хеммінгова відстань",ham_dist1)
print("Відстань Чебишева",cheb_dist1)

Z1 = linkage(euc_dist1, method='average')


# Проводимо кластерізацію

# In[18]:


plt.figure(figsize=(24,12))
plt.tick_params(axis='both', which='major')
dendrogram(Z1, color_threshold=0.45, leaf_font_size=5, count_sort=True)

plt.show()


# Метод K-Means

# In[19]:


X_new = X.copy()

kmeans1 = KMeans(n_clusters=3, random_state=0).fit(X_new)

clusters_xx = kmeans1.labels_

X_new['clusters'] = clusters_xx
X_new


# Розрахунки центрів кластеру

# In[20]:


del X_new['clusters']
centers1 = kmeans1.cluster_centers_
centers1


# Візуалізація

# In[23]:


fig = plt.figure(figsize=(8, 6))
ax = Axes3D(fig)
y_kmeans = kmeans1.predict(X_new)
ax.scatter(X_new['salaries'], X_new['Production_vol'], X_new['Income'], c=y_kmeans, s=50, cmap='Dark2')
ax.scatter(centers1[:, 0], centers1[:, 1], centers1[:, 2], cmap='Dark2', s=500)
ax.set_xlim([0,8])
ax.set_ylim([32,50])
ax.set_zlim([10,30])

