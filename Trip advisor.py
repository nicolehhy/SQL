#!/usr/bin/env python
# coding: utf-8

# In[2]:


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.cluster import KMeans 


# In[3]:


## read the data
data = pd.read_csv('C:/STONY/Practice/Python/Python_2/tripadvisor.csv')
data.describe()
# no missing value, 10 attributes      


# In[ ]:





# In[5]:


# plt.subplot(1,2,1)
# sns.distplot(data['Category 1'])
# plt.subplot(1,2,2)
# sns.distplot(data['Category 2'])


# In[24]:


fig,axs = plt.subplots(5,2,figsize=(10,20))
sns.distplot(data['Category 1'], ax = axs[0,0])
sns.distplot(data['Category 2'], ax = axs[0,1])
sns.distplot(data['Category 3'], ax = axs[1,0])
sns.distplot(data['Category 4'], ax = axs[1,1])
sns.distplot(data['Category 5'], ax = axs[2,0])
sns.distplot(data['Category 6'], ax = axs[2,1])
sns.distplot(data['Category 7'], ax = axs[3,0])
sns.distplot(data['Category 8'], ax = axs[3,1])
sns.distplot(data['Category 9'], ax = axs[4,0])
sns.distplot(data['Category 10'],ax = axs[4,1])


# In[4]:


## create K-means Model when cluster = 3
k1 = 3                       # clsuter number 
iteration = 500             #iteration for cluster 
data_cluster = data.drop(['User ID'],axis=1) #read the data 
kmodel1 = KMeans(n_clusters = k1, n_jobs = 4) 
kmodel1.fit(data_cluster) #train data 

r11 = pd.Series(kmodel1.labels_).value_counts()  #calculate the number of each cluster
r12 = pd.DataFrame(kmodel1.cluster_centers_)     #find out the cluster centroid 
r1 = pd.concat([r12, r11], axis = 1) #calculate the number of instances under each cluster
r1.columns = list(data_cluster.columns) + [u'number of category'] #rename the columnnames
print(r1)


# calculate the overall score
print ('overall score :',kmodel1.score(data_cluster))
# calculate silhouette coefficient
# calculate calinski score
from sklearn import metrics
from sklearn.metrics import calinski_harabaz_score
print('silhouette :',metrics.silhouette_score(data_cluster,kmodel1.labels_,metric='euclidean'))
y_pred = kmodel1.fit_predict(data_cluster)
print('Calinski :',metrics.calinski_harabaz_score(data_cluster,y_pred))


# In[10]:



r11 = pd.concat([data_cluster, pd.Series(kmodel1.labels_, index = data.index)], axis = 1)  
r11.columns = list(data_cluster.columns) + [u'category'] 
r11.head()


# In[11]:


from sklearn.manifold import TSNE
tsne = TSNE()
tsne.fit_transform(data_cluster) 
tsne = pd.DataFrame(tsne.embedding_, index = data_cluster.index) 
import matplotlib.pyplot as plt
plt.rcParams['font.sans-serif'] = ['SimHei'] 
plt.rcParams['axes.unicode_minus'] = False 



d = tsne[r11[u'category'] == 0]
plt.plot(d[0], d[1], 'r.')
d = tsne[r11[u'category'] == 1]
plt.plot(d[0], d[1], 'go')
d = tsne[r11[u'category'] == 2]
plt.plot(d[0], d[1], 'b*')
plt.show()


# In[ ]:





# In[13]:


## create K-means Model when cluster = 5
kmodel2 = KMeans(n_clusters = 5, n_jobs = 4) 
kmodel2.fit(data_cluster) 

r21 = pd.Series(kmodel2.labels_).value_counts()  
r22 = pd.DataFrame(kmodel2.cluster_centers_)    
r2 = pd.concat([r22, r21], axis = 1) 
r2.columns = list(data_cluster.columns) + [u'number of category'] 
print(r2)

# calculate the overall score
print ('overall score :',kmodel2.score(data_cluster))
# calculate silhouette coefficient
# calculate calinski score
from sklearn import metrics
from sklearn.metrics import calinski_harabaz_score
print('silhouette :',metrics.silhouette_score(data_cluster,kmodel2.labels_,metric='euclidean'))
y_pred = kmodel2.fit_predict(data_cluster)
print('Calinski :',metrics.calinski_harabaz_score(data_cluster,y_pred))


# In[16]:


r21 = pd.concat([data_cluster, pd.Series(kmodel2.labels_, index = data.index)], axis = 1)  
r21.columns = list(data_cluster.columns) + [u'category'] 
r21.head()


d = tsne[r21[u'category'] == 0]
plt.plot(d[0], d[1], 'r.')
d = tsne[r21[u'category'] == 1]
plt.plot(d[0], d[1], 'go')
d = tsne[r21[u'category'] == 2]
plt.plot(d[0], d[1], 'b*')
d = tsne[r21[u'category'] == 3]
plt.plot(d[0], d[1], 'c^')
d = tsne[r21[u'category'] == 4]
plt.plot(d[0], d[1], 'ms')
plt.show()


# In[17]:


# create k-means model when cluster = 10
k3 = 10                     
iteration = 500             
kmodel3 = KMeans(n_clusters = k3, n_jobs = 4) 
kmodel3.fit(data_cluster) 

r31 = pd.Series(kmodel3.labels_).value_counts()  
r32 = pd.DataFrame(kmodel3.cluster_centers_)     
r3 = pd.concat([r32, r31], axis = 1) 
r3.columns = list(data_cluster.columns) + [u'number of category'] 
print(r3)


# calculate the overall score
print ('overall score :',kmodel3.score(data_cluster))
# calculate silhouette coefficient
# calculate calinski score
print('silhouette :',metrics.silhouette_score(data_cluster,kmodel3.labels_,metric='euclidean'))
y_pred = kmodel3.fit_predict(data_cluster)
print('Calinski :',metrics.calinski_harabaz_score(data_cluster,y_pred))


# In[18]:


r31 = pd.concat([data_cluster, pd.Series(kmodel3.labels_, index = data.index)], axis = 1)  
r31.columns = list(data_cluster.columns) + [u'category']
r31.head()

#不同类别用不同颜色和样式绘图
d = tsne[r31[u'category'] == 0]
plt.plot(d[0], d[1], 'r.')
d = tsne[r31[u'category'] == 1]
plt.plot(d[0], d[1], 'go')
d = tsne[r31[u'category'] == 2]
plt.plot(d[0], d[1], 'b*')
d = tsne[r31[u'category'] == 3]
plt.plot(d[0], d[1], 'c^')
d = tsne[r31[u'category'] == 4]
plt.plot(d[0], d[1], 'ms')
d = tsne[r31[u'category'] == 5]
plt.plot(d[0], d[1], 'k.')
d = tsne[r31[u'category'] == 6]
plt.plot(d[0], d[1], 'yo')
d = tsne[r31[u'category'] == 7]
plt.plot(d[0], d[1], 'r1')
d = tsne[r31[u'category'] == 8]
plt.plot(d[0], d[1], 'm1')
d = tsne[r31[u'category'] == 9]
plt.plot(d[0], d[1], 'mp')
plt.show()


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[91]:


np.shape(clst1.labels_)


# In[20]:


### AgglomerativeClustering when cluster = 3
from sklearn import cluster
clst1=cluster.AgglomerativeClustering(n_clusters=3)
clst1.fit(data_cluster)
clst1
# calculate the overall score
# print ('overall score :',clst1.score(data_cluster))
# calculate silhouette coefficient
# calculate calinski score
print('silhouette :',metrics.silhouette_score(data_cluster,clst1.labels_,metric='euclidean'))
y_pred = clst1.fit_predict(data_cluster)
print('Calinski :',metrics.calinski_harabaz_score(data_cluster,y_pred))


# In[63]:





# In[21]:


agg1 = pd.concat([data_cluster, pd.Series(clst1.labels_, index = data.index)], axis = 1)  
agg1.columns = list(data_cluster.columns) + [u'category'] 

# plot 2D clustering 
d = tsne[agg1[u'category'] == 0]
plt.plot(d[0], d[1], 'r.')
d = tsne[agg1[u'category'] == 1]
plt.plot(d[0], d[1], 'go')
d = tsne[agg1[u'category'] == 2]
plt.plot(d[0], d[1], 'b*')
d = tsne[r31[u'category'] == 3]
plt.plot(d[0], d[1], 'c^')
d = tsne[r31[u'category'] == 4]
plt.plot(d[0], d[1], 'ms')
d = tsne[r31[u'category'] == 5]
plt.plot(d[0], d[1], 'k.')
d = tsne[r31[u'category'] == 6]
plt.plot(d[0], d[1], 'yo')
d = tsne[r31[u'category'] == 7]
plt.plot(d[0], d[1], 'r1')
d = tsne[r31[u'category'] == 8]
plt.plot(d[0], d[1], 'm1')
d = tsne[r31[u'category'] == 9]
plt.plot(d[0], d[1], 'mp')
plt.show()


# In[22]:


### AgglomerativeClustering when cluster = 5
from sklearn import cluster
clst2=cluster.AgglomerativeClustering(n_clusters=5)
clst2.fit(data_cluster)
clst2
# calculate the overall score
# print ('overall score :',clst1.score(data_cluster))
# calculate silhouette coefficient
# calculate calinski score
print('silhouette :',metrics.silhouette_score(data_cluster,clst2.labels_,metric='euclidean'))
y_pred = clst2.fit_predict(data_cluster)
print('Calinski :',metrics.calinski_harabaz_score(data_cluster,y_pred))


# In[23]:


agg2 = pd.concat([data_cluster, pd.Series(clst2.labels_, index = data.index)], axis = 1)  
agg2.columns = list(data_cluster.columns) + [u'category'] 

# plot 2D clustering 
d = tsne[agg2[u'category'] == 0]
plt.plot(d[0], d[1], 'r.')
d = tsne[agg2[u'category'] == 1]
plt.plot(d[0], d[1], 'go')
d = tsne[agg2[u'category'] == 2]
plt.plot(d[0], d[1], 'b*')
d = tsne[agg2[u'category'] == 3]
plt.plot(d[0], d[1], 'c^')
d = tsne[agg2[u'category'] == 4]
plt.plot(d[0], d[1], 'ms')
# d = tsne[r31[u'category'] == 5]
# plt.plot(d[0], d[1], 'k.')
# d = tsne[r31[u'category'] == 6]
# plt.plot(d[0], d[1], 'yo')
# d = tsne[r31[u'category'] == 7]
# plt.plot(d[0], d[1], 'r1')
# d = tsne[r31[u'category'] == 8]
# plt.plot(d[0], d[1], 'm1')
# d = tsne[r31[u'category'] == 9]
# plt.plot(d[0], d[1], 'mp')
plt.show()


# In[25]:


### AgglomerativeClustering when cluster = 10
from sklearn import cluster
clst3=cluster.AgglomerativeClustering(n_clusters=10)
clst3.fit(data_cluster)
clst3
# calculate the overall score
# print ('overall score :',clst1.score(data_cluster))
# calculate silhouette coefficient
# calculate calinski score
print('silhouette :',metrics.silhouette_score(data_cluster,clst3.labels_,metric='euclidean'))
y_pred = clst3.fit_predict(data_cluster)
print('Calinski :',metrics.calinski_harabaz_score(data_cluster,y_pred))


# In[26]:


agg3 = pd.concat([data_cluster, pd.Series(clst3.labels_, index = data.index)], axis = 1)  
agg3.columns = list(data_cluster.columns) + [u'category'] 

# plot 2D clustering 
d = tsne[agg3[u'category'] == 0]
plt.plot(d[0], d[1], 'r.')
d = tsne[agg3[u'category'] == 1]
plt.plot(d[0], d[1], 'go')
d = tsne[agg3[u'category'] == 2]
plt.plot(d[0], d[1], 'b*')
d = tsne[agg3[u'category'] == 3]
plt.plot(d[0], d[1], 'c^')
d = tsne[agg3[u'category'] == 4]
plt.plot(d[0], d[1], 'ms')
d = tsne[agg3[u'category'] == 5]
plt.plot(d[0], d[1], 'k.')
d = tsne[agg3[u'category'] == 6]
plt.plot(d[0], d[1], 'yo')
d = tsne[agg3[u'category'] == 7]
plt.plot(d[0], d[1], 'r1')
d = tsne[agg3[u'category'] == 8]
plt.plot(d[0], d[1], 'm1')
d = tsne[agg3[u'category'] == 9]
plt.plot(d[0], d[1], 'mp')
plt.show()


# In[43]:


#### create  DBSCAN clustering  k= 3
from sklearn.cluster import DBSCAN
from sklearn.preprocessing import StandardScaler
X = StandardScaler().fit_transform(data_cluster)
dbs1 = DBSCAN(eps = 0.1, min_samples =3).fit(X)


# calculate silhouette coefficient
print('silhouette :',metrics.silhouette_score(X,dbs1.labels_))
# calculate calinski score
y_pred = dbs1.fit_predict(X)
print('Calinski :',metrics.calinski_harabaz_score(X,y_pred))
# within
print("Homogeneity: %0.3f" % metrics.homogeneity_score(dbs1.labels_, y_pred))
# between
print("Completeness: %0.3f" % metrics.completeness_score(dbs1.labels_, y_pred))
# overall
print("V-measure: %0.3f" % metrics.v_measure_score(dbs1.labels_, y_pred))


# In[44]:


can1 = pd.concat([data_cluster, pd.Series(dbs1.labels_, index = data.index)], axis = 1)  
can1.columns = list(data_cluster.columns) + [u'category'] 

# plot 2D clustering 
d = tsne[can1[u'category'] == -1]
plt.plot(d[0], d[1], 'r.')
d = tsne[can1[u'category'] == 0]
plt.plot(d[0], d[1], 'go')
d = tsne[can1[u'category'] == 1]
plt.plot(d[0], d[1], 'b*')

plt.show()


# In[38]:


np.unique(dbs1.labels_)


# In[40]:


#### create  DBSCAN clustering  k= 5
dbs2 = DBSCAN(eps = 0.3, min_samples =3).fit(X)


# calculate silhouette coefficient
print('silhouette :',metrics.silhouette_score(X,dbs2.labels_))
# calculate calinski score
y_pred = dbs2.fit_predict(X)
print('Calinski :',metrics.calinski_harabaz_score(X,y_pred))
# within
print("Homogeneity: %0.3f" % metrics.homogeneity_score(dbs2.labels_, y_pred))
# between
print("Completeness: %0.3f" % metrics.completeness_score(dbs2.labels_, y_pred))
# overall
print("V-measure: %0.3f" % metrics.v_measure_score(dbs2.labels_, y_pred))


# In[41]:


can2 = pd.concat([data_cluster, pd.Series(dbs2.labels_, index = data.index)], axis = 1)  
can2.columns = list(data_cluster.columns) + [u'category'] 

# plot 2D clustering 
d = tsne[can2[u'category'] == -1]
plt.plot(d[0], d[1], 'r.')
d = tsne[can2[u'category'] == 0]
plt.plot(d[0], d[1], 'go')
d = tsne[can2[u'category'] == 1]
plt.plot(d[0], d[1], 'b*')
d = tsne[can2[u'category'] == 2]
plt.plot(d[0], d[1], 'c^')
d = tsne[can2[u'category'] == 3]
plt.plot(d[0], d[1], 'ms')

plt.show()


# In[ ]:





# In[ ]:





# In[56]:


dbs3 = DBSCAN(eps = 0.67, min_samples =3).fit(X)


# calculate silhouette coefficient
print('silhouette :',metrics.silhouette_score(X,dbs3.labels_))
# calculate calinski score
y_pred = dbs1.fit_predict(X)
print('Calinski :',metrics.calinski_harabaz_score(X,y_pred))
# within
print("Homogeneity: %0.3f" % metrics.homogeneity_score(dbs3.labels_, y_pred))
# between
print("Completeness: %0.3f" % metrics.completeness_score(dbs3.labels_, y_pred))
# overall
print("V-measure: %0.3f" % metrics.v_measure_score(dbs3.labels_, y_pred))


# In[62]:


can3= pd.concat([data_cluster, pd.Series(dbs3.labels_, index = data.index)], axis = 1)  
can3.columns = list(data_cluster.columns) + [u'category'] 

# plot 2D clustering 
d = tsne[can3[u'category'] == -1]
plt.plot(d[0], d[1], 'r.')
d = tsne[can3[u'category'] == 0]
plt.plot(d[0], d[1], 'go')
d = tsne[can3[u'category'] == 1]
plt.plot(d[0], d[1], 'b*')
d = tsne[can3[u'category'] == 2]
plt.plot(d[0], d[1], 'c^')
d = tsne[can3[u'category'] == 3]
plt.plot(d[0], d[1], 'ms')
d = tsne[can3[u'category'] == 4]
plt.plot(d[0], d[1], 'k.')
d = tsne[can3[u'category'] == 5]
plt.plot(d[0], d[1], 'yo')
d = tsne[can3[u'category'] == 6]
plt.plot(d[0], d[1], 'r1')
d = tsne[can3[u'category'] == 7]
plt.plot(d[0], d[1], 'm1')
d = tsne[can3[u'category'] == 8]
plt.plot(d[0], d[1], 'mp')
plt.show()


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




