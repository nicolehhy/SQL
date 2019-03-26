#!/usr/bin/env python
# coding: utf-8

# In[21]:


#data analysis libraries 
import numpy as np
import pandas as pd

#visualization libraries
import matplotlib.pyplot as plt
import seaborn as sns
get_ipython().run_line_magic('matplotlib', 'inline')

#ignore warnings
import warnings
warnings.filterwarnings('ignore')


# In[22]:


# prepare the train and test data set
from sklearn.model_selection import train_test_split
data = pd.read_csv('C:/STONY/Practice/Python/Python_2/titanic.csv')
predictors = data.drop(['Survived'], axis=1)
target = data["Survived"]
x_train, x_test, y_train, y_test = train_test_split(predictors, target, test_size = 0.10, random_state = 0)
test= x_test.join(y_test, lsuffix='_caller', rsuffix='_other')
train = x_train.join(y_train, lsuffix='_caller', rsuffix='_other')
train.describe(include="all")
test.describe(include="all")


# In[23]:


testdata = test.loc[test['Survived']==1]
testdata[testdata["Sex"]=='female'].shape[0]


# In[24]:


## Q1 ##
# 1 #
train.describe(include="all")
test.describe(include="all")
# 801 instances in trian, 90 instances in test, 891 in all

# 2 # no missing values in SEX
train[train["Sex"] == 'female'].shape[0] #281
train[train["Sex"] == 'male'].shape[0] # 520
test[test["Sex"] == 'female'].shape[0] #33
test[test["Sex"] == 'male'].shape[0] # 57

# 3 # hom many survived
train[train["Survived"] == 1].shape[0] #303
train[train["Survived"] == 0].shape[0] # 498
test[test["Survived"] == 1].shape[0] #39
test[test["Survived"] == 0].shape[0] # 51

# homy many survived in each gender
traindata = train.loc[train['Survived']==1]
traindata[traindata["Sex"]=='female'].shape[0] #206 
traindata[traindata["Sex"]=='male'].shape[0] #97
traindata = train.loc[train['Survived']==0]
traindata[traindata["Sex"]=='female'].shape[0] #75
traindata[traindata["Sex"]=='male'].shape[0] #423

testdata = test.loc[test['Survived']==1]
testdata[testdata["Sex"]=='female'].shape[0] #27
testdata[testdata["Sex"]=='male'].shape[0] #12
testdata = test.loc[test['Survived']==0]
testdata[testdata["Sex"]=='female'].shape[0] #6
testdata[testdata["Sex"]=='male'].shape[0] #45

# how many children survived 
child = train[train["Age"] <= 16]
child[child["Survived"]==1].shape[0] # 50
child[child["Survived"]==0].shape[0] # 38

child = test[test["Age"] <= 16]
child[child["Survived"]==1].shape[0] # 5
child[child["Survived"]==0].shape[0] # 7


# In[25]:


## feature engineering
full_data = [train,test]
# Pclass
print (train[['Pclass', 'Survived']].groupby(['Pclass'], as_index=False).mean())
# Sex
print (train[["Sex", "Survived"]].groupby(['Sex'], as_index=False).mean())
# Family Size
train['FamilySize'] = train['SibSp'] + train['Parch'] + 1
print(train[['FamilySize','Survived']].groupby(['FamilySize'],as_index=False).mean())


# In[26]:


# Embarked
train['Embarked'] = train['Embarked'].fillna('S')
print (train[['Embarked', 'Survived']].groupby(['Embarked'], as_index=False).mean())
# Fare
train['Fare'] = train['Fare'].fillna(train['Fare'].median())
train['CategoricalFare'] = pd.qcut(train['Fare'], 4)
print (train[['CategoricalFare', 'Survived']].groupby(['CategoricalFare'], as_index=False).mean())
# Age
age_avg = train['Age'].mean()
age_std = train['Age'].std()
age_null_count = train['Age'].isnull().sum()
    
age_null_random_list = np.random.randint(age_avg - age_std, age_avg + age_std, size=age_null_count)
train['Age'][np.isnan(train['Age'])] = age_null_random_list
train['Age'] = train['Age'].astype(int)
    
train['CategoricalAge'] = pd.cut(train['Age'], 5)

print (train[['CategoricalAge', 'Survived']].groupby(['CategoricalAge'], as_index=False).mean())

### we have noticed that these 6 factors has impacts on survival 


# In[ ]:





# In[27]:


## data cleaning
# Mapping Sex
test['Embarked'] = test['Embarked'].fillna('S')
full_data = [train,test]
for dataset in full_data:
    # Mapping Sex
    dataset['Sex'] = dataset['Sex'].map( {'female': 0, 'male': 1} ).astype(int)
    # Mapping Embarked
    dataset['Embarked'] = dataset['Embarked'].map( {'S': 0, 'C': 1, 'Q': 2} ).astype(int)
    # Mapping Fare
    dataset.loc[ dataset['Fare'] <= 7.91, 'Fare'] = 0
    dataset.loc[(dataset['Fare'] > 7.91) & (dataset['Fare'] <= 14.454), 'Fare'] = 1
    dataset.loc[(dataset['Fare'] > 14.454) & (dataset['Fare'] <= 31), 'Fare']   = 2
    dataset.loc[ dataset['Fare'] > 31, 'Fare'] = 3
    dataset['Fare'] = dataset['Fare'].astype(int)
    
    # Mapping Age
    dataset.loc[ dataset['Age'] <= 16, 'Age'] = 0
    dataset.loc[(dataset['Age'] > 16) & (dataset['Age'] <= 32), 'Age'] = 1
    dataset.loc[(dataset['Age'] > 32) & (dataset['Age'] <= 48), 'Age'] = 2
    dataset.loc[(dataset['Age'] > 48) & (dataset['Age'] <= 64), 'Age'] = 3
    dataset.loc[ dataset['Age'] > 64, 'Age']= 4


# In[220]:


train


# In[28]:


drop_elements = ['PassengerId', 'Name', 'Ticket', 'Cabin', 'SibSp',                 'Parch']
train = train.drop(drop_elements, axis = 1)
train = train.drop(['CategoricalAge', 'CategoricalFare','FamilySize'], axis = 1)

test  = test.drop(drop_elements, axis = 1)


# In[29]:


test['Age'] = test['Age'].fillna('5')


# In[ ]:





# In[30]:


### Q3 decision tree 
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score

col_n = ["Pclass","Sex"]
x_train = pd.DataFrame(train,columns = col_n)
y_train = train['Survived']
decisiontree = DecisionTreeClassifier()
decisiontree.fit(x_train, y_train)
x_val = pd.DataFrame(test,columns = col_n)
y_val = test['Survived']
y_pred = decisiontree.predict(x_val)

acc_decisiontree = round(accuracy_score(y_pred, y_val) * 100, 2)
print(acc_decisiontree)
from sklearn.metrics import confusion_matrix
confusion_matrix(y_val, y_pred)


# In[ ]:





# In[56]:


### Q3 draw a decision tree 
# Visualize data
import os
os.environ["PATH"] += os.pathsep + 'C:/Users/Crystal Huang/Downloads/graphviz-2.38/release/bin/' 
from sklearn.externals.six import StringIO
from IPython.display import Image
from sklearn.tree import export_graphviz
import pydotplus
decisiontree = DecisionTreeClassifier()
decisiontree.fit(x_train, y_train)

dot_data=export_graphviz(decisiontree, out_file=None,
                filled=True, rounded=True,
                special_characters=True)
graph_1 = pydotplus.graph_from_dot_data(dot_data)
Image(graph_1.create_png())


# In[271]:


## Q4 Logistic Regression
from sklearn.linear_model import LogisticRegression
col_n = ["Pclass","Sex","Age","Fare","Embarked"]
x_train = pd.DataFrame(train,columns = col_n)
x_val = pd.DataFrame(test,columns = col_n)
logreg = LogisticRegression()
logreg.fit(x_train, y_train)
y_pred = logreg.predict(x_val)
acc_logreg = round(accuracy_score(y_pred, y_val) * 100, 2)
print(acc_logreg)

confusion_matrix(y_val, y_pred)


# In[276]:


## Q4 ROC curve and AUC
from sklearn.metrics import roc_curve, auc
y_score = logreg.fit(x_train, y_train).decision_function(x_val)
# Compute ROC curve and ROC area for each class
fpr,tpr,threshold = roc_curve(y_test, y_score) 
###compute false positive rate and true positive rate
roc_auc = auc(fpr,tpr)
###计算auc的值 
plt.figure()
lw = 2
plt.figure(figsize=(10,10))
plt.plot(fpr, tpr, color='darkorange',lw=lw, label='ROC curve (area = %0.2f)' % roc_auc) 
###假正率为横坐标，真正率为纵坐标做曲线
plt.plot([0, 1], [0, 1], color='navy', lw=lw, linestyle='--')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver operating characteristic')
plt.legend(loc="lower right")
plt.show()


# In[13]:


### Q5
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
col_n = ['Fare']
x = pd.DataFrame(data,columns = col_n)
y = data['Age'].fillna(26)

x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.1, random_state=101)
# # Create linear regression object
lm = LinearRegression()
lm.fit(x_train,y_train)

# # Make predictions using the testing set
y_pre = lm.predict(x_test)

import matplotlib.pyplot as plot
plt.plot(x_train, y_train,'k.')
plt.plot(x_train, lm.predict(x_train), color='red', linewidth=4)
plt.show()
print(mean_squared_error(y_val, y_pred)  )
print(r2_score(y_val, y_pred)) 


# In[ ]:





# In[ ]:





# In[ ]:




