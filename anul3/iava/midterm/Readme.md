# Midterm - Prezentare

### Abordare proiect - Mini ML Library
###### Deep learning focus

##### Tehnologii

* Std Pyhton
* Numpy

### Building Blocks

##### Straturi / Operatori
* perceptron -> straturi liniare
* functii de activare (Sigmoid, ReLU, Softmax)
* straturi de pooling
* *starturi convolutionale

##### Functiile de cost / Loss Fuctions
* MSE
* Cross entropy loss

##### Optimizatori
Aici apare cheia proiectului. Mai precis algoritmii care se asigura de actualizarea corecta a
parametrilor din cadrul retelei.
* SGD
* *Adam

##### Initializatori & optimizatori
* randomizare a parametrilor / weight-urilor initiale
* optimizari pentru prevenirea overfitting-ului
  * dropout
  * batch normalization

##### Preprocessing
* mod standardizat de containerizare a datelor
* wrappere peste tehnici clasice de augumentare a datelor
  * luminozitate
  * contrast
  * resize
  * rotate
  * flips

##### Altele
* lucrat in batch-uri
* multithreading (doamne ajuta)
* salvarea modelului
* incarcarea modelelor salvate
* ceva layer de compatibilitate ca sa pot incarca modele preantrenate -> Transfer Learning


### Evaluare

In final voi fi capabil sa creez un model, si sa-l antrenez pentru a rezolva probleme clasice de clasificare.

##### Clasificare basic - MINIST
[mnist](https://www.kaggle.com/hojjatk/mnist-dataset)

##### Clasificare usoara - Digit recognizer
[digit recognizer](https://www.kaggle.com/c/digit-recognizer)

##### Clasificare mai grea - Intel classifier
[intel](https://www.kaggle.com/puneet6060/intel-image-classification)

### Resurse

2 & 3 sunt pur si simplu alte librarii de Deep Learning care sustin ca ar fi lightweight.
Mi se pare un approach bun sa ma inspir din munca altora, mai ales pentru ca mi-am ales un task
care presupune intr-o oarecare masura reinventarea rotii.

1. curs
2. [lasagne](https://github.com/Lasagne/Lasagne)
3. [caffe](https://github.com/BVLC/caffe)
4. planuiesc sa vad si cum sunt implementate functionalitatile in [pytorch](https://github.com/pytorch/pytorch) dar pare destul de complex.
5. am gasit acest [articol](https://www.kdnuggets.com/2020/09/implementing-deep-learning-library-scratch-python.html) care mi s-a parut un starting point foarte bun

https://cs.stanford.edu/people/karpathy/convnetjs/docs.html
