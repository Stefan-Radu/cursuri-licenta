import json
import re
import string

import spacy
from nltk.stem.snowball import SnowballStemmer
from sklearn.feature_extraction.text import CountVectorizer
import matplotlib.pyplot as plt
from nltk.stem import WordNetLemmatizer
import seaborn as sns
from sklearn import preprocessing, metrics
from sklearn.datasets import make_classification
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.model_selection import GridSearchCV
from sklearn.linear_model import SGDClassifier

import nltk
nltk.download('wordnet')
nltk.download('omw-1.4') # descarc benzinaria

wnl = WordNetLemmatizer()
nlp = spacy.load('en_core_web_sm')
tokenizer = nlp.tokenizer
stemmer = SnowballStemmer(language='english')

entries = []
accepted_labels = {
  'EDUCATION': 0,
  'WEIRD NEWS': 1,
  'GREEN': 2,
  'CULTURE & ARTS': 3,
  'FOOD & DRINK': 4,
}

with open("./News_Category_Dataset_v2.json", "r") as f:
  data = f.readlines()
  for line in data:
    d = json.loads(line)
    label = d.get('category')
    if label not in accepted_labels:
      continue
    txt = f'{d.get("headline", "")} {d.get("short_description", "")}'
    entries.append((txt, accepted_labels[label]))

# print(entries[:3])

def no_links(txt):
  regex = r'(www|http)\S+'
  return re.sub(regex, '', txt)


def no_punctuation(txt):
  regex = fr'([{string.punctuation}])'
  txt = re.sub(regex, ' ', txt)
  # prea multe spatii
  return re.sub(r'\s+', ' ', txt)


def tokenize(txt, lemmatization=False, stemming=False, stop_words=False):
  tokens = [str(x) for x in list(tokenizer(txt))]
  stop_words_spacy = nlp.Defaults.stop_words

  if stop_words:
    tokens = [w for w in tokens if str(w) not in stop_words_spacy]

  if not lemmatization and not stemming:
    return tokens

  if stemming:
    return [stemmer.stem(w) for w in tokens]

  return [wnl.lemmatize(w) for w in tokens]


def simple_tok(txt):
  return tokenize(txt, stop_words=False)

def lemma_tok(txt):
  return tokenize(txt, lemmatization=True, stop_words=True)

def stemm_tok(txt):
  return tokenize(txt, stemming=True, stop_words=True)

def preprocess(txt):
  txt = txt.lower()
  txt = no_punctuation(txt)
  txt = no_links(txt)
  return txt


def get_data(preprocess, tokenize, normalize=''):
  cv = CountVectorizer(
      preprocessor=preprocess,
      tokenizer=tokenize,
      token_pattern=None,
      max_features=10000,
      binary=True,
  )

  texts = [e[0] for e in entries]
  labels = [e[1] for e in entries]
  cv.fit(texts)

  features = cv.transform(texts)

  train_amount = int(0.8 * features.shape[0])
  x_train = features[:train_amount]
  x_test = features[train_amount:]
  y_train = labels[:train_amount]
  y_test = labels[train_amount:]

  if normalize:
    scaler = preprocessing.Normalizer(norm=normalize)
    scaled_x_train = scaler.transform(x_train)
    scaled_x_test = scaler.transform(x_test)
    return scaled_x_train, scaled_x_test, y_train, y_test

  return x_train, x_test, y_train, y_test


data = []
# x_train, x_test, y_train, y_test = get_data(preprocess, simple_tok, 'l1') # P: 0.7172
# x_train, x_test, y_train, y_test = get_data(preprocess, lemma_tok, 'l2') # P: 0.9267
x_train, x_test, y_train, y_test = get_data(preprocess, stemm_tok) # P: 0.9817 <--

mnb = MultinomialNB()
mnb.fit(x_train, y_train)
y_predict = mnb.predict(x_test)

print("Accuracy:", metrics.accuracy_score(y_test, y_predict))
print("Precision:", metrics.precision_score(y_test, y_predict, average="weighted"))
print("Recall:", metrics.recall_score(y_test, y_predict, average="weighted"))
print("F1:", metrics.f1_score(y_test, y_predict, average="weighted"))

print(metrics.classification_report(y_test, y_predict))
cm = metrics.confusion_matrix(y_test, y_predict)
print(cm)
sns.heatmap(cm, annot=True)

## Cel mai bine da pe stemming fara normalizare

svm = SGDClassifier(loss='hinge', penalty='l2', alpha=1e-3, random_state=42)
svm.fit(x_train, y_train)
y_predict = svm.predict(x_test)

print("Accuracy:", metrics.accuracy_score(y_test, y_predict)) # !! 0.97 vs 98 ls NB
print("Precision:", metrics.precision_score(y_test, y_predict, average="weighted"))
print("Recall:", metrics.recall_score(y_test, y_predict, average="weighted"))
print("F1:", metrics.f1_score(y_test, y_predict, average="weighted"))

parameters = {
  'vect__ngram_range': [(1, 1), (1, 2)],
  'tfidf__use_idf': (True, False),
  'clf__alpha': (1e-2, 1e-3),
}

# NB merge mai bine. am afisat heatmap mai sus
