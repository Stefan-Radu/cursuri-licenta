#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import matplotlib.pyplot as plt


# In[13]:


train_images = np.loadtxt('data/train_images.txt') # incarcam imaginile
train_labels = np.array(np.loadtxt('data/train_labels.txt'), dtype=np.int) # incarcam etichetele

print(train_images)
print(train_labels)


# In[15]:


test_images = np.loadtxt('data/test_images.txt') # incarcam imaginile
test_labels = np.array(np.loadtxt('data/test_labels.txt'), dtype=np.int) # incarcam etichetele


# In[8]:


image = train_images[-1] # prima imagine # 784
print(image)
exit(0)
image = np.reshape(image, (28, 28))
plt.imshow(image.astype(np.uint8), cmap='gray')
plt.show()


# In[31]:


bins = np.linspace(0, 256, num=5) 


# In[32]:


print(bins)


# In[35]:


np.digitize(np.array([[0, 255]]), bins)


# In[38]:


def values_to_bins(x, bins):
    return np.digitize(x, bins) - 1
    


# In[36]:


bins = np.linspace(0, 256, num=5) 


# In[39]:


train_images_bins = values_to_bins(train_images, bins)
test_images_bins = values_to_bins(test_images, bins)


# In[42]:


train_images_bins.max()


# In[44]:


from sklearn.naive_bayes import MultinomialNB


# In[45]:


naive_bayes_model = MultinomialNB()


# In[46]:


naive_bayes_model.fit(train_images_bins, train_labels)


# In[47]:


predicted_labels = naive_bayes_model.predict(test_images_bins)


# In[48]:


# acuratate
accuracy = np.mean(predicted_labels == test_labels)


# In[49]:


print(accuracy)


# In[50]:


accuracy_2 = naive_bayes_model.score(test_images_bins, test_labels)
print(accuracy_2)


# In[52]:


for num_bins in [3, 5, 7, 9, 11]:
    bins = np.linspace(0, 256, num=num_bins) 
    train_images_bins = values_to_bins(train_images, bins)
    test_images_bins = values_to_bins(test_images, bins)
    naive_bayes_model = MultinomialNB()
    naive_bayes_model.fit(train_images_bins, train_labels)
    accuracy = naive_bayes_model.score(test_images_bins, test_labels)
    print('num bins = %d has accuracy %f' % (num_bins, accuracy))


# In[61]:


bins = np.linspace(0, 256, num=11) 
train_images_bins = values_to_bins(train_images, bins)
test_images_bins = values_to_bins(test_images, bins)
naive_bayes_model = MultinomialNB()
naive_bayes_model.fit(train_images_bins, train_labels)
predicted_labels = naive_bayes_model.predict(test_images_bins)


# In[68]:


misclassified_indices = np.where(test_labels != predicted_labels)[0]


# In[69]:


misclassified_indices


# In[71]:


for idx in misclassified_indices[:10]:
    img = test_images[idx].reshape(28, 28)
    plt.imshow(img, cmap='gray')
    plt.show()
    print('Predicted labels = %d, Correct label = %d' % (predicted_labels[idx], test_labels[idx]))


# In[74]:


def confunsion_matrix(predicted_labels, ground_truth_labels):
    num_labels = ground_truth_labels.max() + 1
    conf_mat = np.zeros((num_labels, num_labels))
    
    for i in range(len(predicted_labels)):
        conf_mat[ground_truth_labels[i], predicted_labels[i]] += 1
    return  conf_mat
    


# In[77]:


conf_mat = confunsion_matrix(predicted_labels, test_labels)


# In[78]:


plt.imshow(conf_mat, cmap='gray')


# In[75]:


print(conf_mat)

