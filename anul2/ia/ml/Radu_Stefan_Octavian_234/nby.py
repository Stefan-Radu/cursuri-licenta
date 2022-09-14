# Naive Bayesa - bazat pe lab 2

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.naive_bayes import MultinomialNB
import seaborn as sn


def load_images(what):
    '''
        incarca imagini si transforma din png in
        array flatten cu valori in range [0, 255]
        incarca labels
    '''

    # dataframe din csv
    labels_df = pd.read_csv(f'fixed-dataset/{what}.txt', dtype=str)
    images = np.array(labels_df['id'].to_numpy())
    labels = np.array(labels_df['label'].to_numpy(dtype=np.int))

    # procesare
    images = np.array([
        (np.array(plt.imread(f'fixed-dataset/{what}/{image}'), dtype=np.float) \
         * 255).flatten() for image in images
    ])

    # verific ca incarc bine
    img = images[27].reshape(50, 50)
    plt.imshow(img.astype(np.uint8), cmap='gray')
    plt.show()

    return images, labels


def values_to_bins(x, bins):
    return np.digitize(x, bins) - 1


# din laborator
def confunsion_matrix(predicted_labels, ground_truth_labels):
    num_labels = ground_truth_labels.max() + 1
    conf_mat = np.zeros((num_labels, num_labels))

    for i in range(len(predicted_labels)):
        conf_mat[ground_truth_labels[i], predicted_labels[i]] += 1
    return  conf_mat


# incarcare date
train_images, train_labels = load_images('train')
test_images, test_labels = load_images('validation')


# testez cum merge pe diverse numere de intervale cu prime pana la 100
for num_bins in [2, 3, 5, 7, 11, 13, 17, \
                 19, 23, 29, 31, 37, 41, \
                 43, 47, 53, 59, 61, 67, \
                 71, 73, 79, 83, 89, 97]:

    bins = np.linspace(0, 256, num=num_bins)
    train_images_bins = values_to_bins(train_images, bins)
    test_images_bins = values_to_bins(test_images, bins)
    naive_bayes_model = MultinomialNB()
    naive_bayes_model.fit(train_images_bins, train_labels)
    accuracy = naive_bayes_model.score(test_images_bins, test_labels)
    print('num bins = %d has accuracy %f' % (num_bins, accuracy))


# cel mai bine da pe 3
bins = np.linspace(0, 256, num=3)

# iau intervalele
train_images_bins = values_to_bins(train_images, bins)
test_images_bins = values_to_bins(test_images, bins)

# vizualizez datele care intra in algoritm
img = train_images_bins[27].reshape(50, 50)
plt.imshow(img.astype(np.uint8), cmap='gray')
img = train_images[27].reshape(50, 50)
plt.imshow(img.astype(np.uint8), cmap='gray')
plt.show()

# antrenez
naive_bayes_model = MultinomialNB()
naive_bayes_model.fit(train_images_bins, train_labels)

# prezic
predicted_labels = naive_bayes_model.predict(test_images_bins)
accuracy = naive_bayes_model.score(test_images_bins, test_labels)
print(accuracy)

# matrice de confuzie
conf_mat = confunsion_matrix(predicted_labels, test_labels)

conf_mat_df = pd.DataFrame(conf_mat, range(3), range(3))

# render
plt.figure(figsize=(7, 7))
sn.heatmap(conf_mat_df,
           annot=True,
           annot_kws={"size": 21},
           square=True,
           cmap="Wistia")
plt.show()
