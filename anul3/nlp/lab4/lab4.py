import time
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader
from sklearn.datasets import load_iris, make_classification
import sklearn.metrics as metrics
from random import shuffle, seed
import numpy as np
from matplotlib import pyplot as plt

seed(time.time())

# X, y = load_iris(return_X_y=True)
X, y = make_classification(n_samples=10000, n_features=500, \
                           n_classes=3, n_informative=100)

class MyDataset(Dataset):
    def __init__(self, data, labels):
        super().__init__()
        self.data = data
        self.labels = labels

    def __getitem__(self, k):
        """Intoarce al k-ulea element"""
        return self.data[k], self.labels[k]

    def __len__(self):
        """Intoarce dimensiunea datasetului"""
        assert len(self.data) == len(self.labels)
        return len(self.data)



### 2 Definesc modelul
class MyNet(nn.Module):
    def __init__(self):
        super().__init__()
        self.linear1 = nn.Linear(in_features=500, out_features=128, dtype=float)
        self.linear2 = nn.Linear(in_features=128, out_features=64, dtype=float)
        self.linear3 = nn.Linear(in_features=64, out_features=32, dtype=float)
        self.linear4 = nn.Linear(in_features=32, out_features=3, dtype=float)

    def forward(self, x):
        x = F.relu(self.linear1(x))
        x = nn.Dropout(p=0.2)(x)
        x = F.relu(self.linear2(x))
        x = nn.Dropout(p=0.2)(x)
        x = F.relu(self.linear3(x))
        x = nn.Dropout(p=0.4)(x)
        x = F.softmax(self.linear4(x), dim=1)
        return x


combined = list(zip(X, y))
shuffle(combined)

X = np.array([x for x, _ in combined])
y = np.array([y for _, y in combined])

t_len = int(0.8 * len(X))
v_len = int(0.9 * len(X))

train_data = MyDataset(X[:t_len], y[:t_len])
validation_data = MyDataset(X[t_len:v_len], y[t_len:v_len])
test_data = MyDataset(X[v_len:], y[v_len:])


### 3 Definesc data loader-ele
train_loader = DataLoader(train_data, batch_size=10, shuffle=True)
validation_loader = DataLoader(validation_data, batch_size=1, shuffle=True)
test_loader = DataLoader(test_data, batch_size=1, shuffle=True)

### 4 Loss function & optimizer

epochs = 40
my_net = MyNet()

optimizer = optim.Adam(my_net.parameters(), lr=5e-4)
optimizer.zero_grad()

loss_fn = nn.CrossEntropyLoss()

def eval_fn(net: nn.Module, dataloader: DataLoader):
    net.eval()

    mean_loss = 0
    true_labels = []
    predicted_labels = []
    with torch.no_grad():
        for vectors, labels in dataloader:
            output = net(vectors)
            loss = loss_fn(output, labels)
            mean_loss += loss.item()
            true_labels.extend(labels.tolist())
            predicted_labels.extend(output.max(1)[1].tolist())

    acc = metrics.accuracy_score(true_labels, predicted_labels)
    mean_loss /= len(dataloader)
    return acc, mean_loss


def train_fn(epochs: int, train_loader: DataLoader, val_loader: DataLoader,
             net: nn.Module, loss_fn: nn.Module, optimizer: optim.Optimizer):

    best_loss = 1e9
    acc_train, acc_val = [], []
    ml_train, ml_val = [], []
    for e in range(epochs):
        net.train()

        for vectors, labels in train_loader:
            # resetez gradientii    
            optimizer.zero_grad()
            # trec datele prin retea
            output = net(vectors)
            # calculez loss
            loss = loss_fn(output, labels)
            # back prop
            loss.backward()
            # actulalizez reteaua facand un pas in optimizer
            optimizer.step()

        # Calcularea metricilor
        acc, mean_loss = eval_fn(net, train_loader)
        print(f"Epoca {e}: train_acc: {acc:0.2f} train_ml: {mean_loss:0.2f}", \
              end=' ')
        acc_train.append(acc)
        ml_train.append(mean_loss)
        acc, mean_loss = eval_fn(net, val_loader)
        print(f"val_acc: {acc:0.2f} val_ml: {mean_loss:0.2f}")
        acc_val.append(acc)
        ml_val.append(mean_loss)

        if mean_loss < best_loss:
          best_loss = mean_loss
          torch.save(net.state_dict(), "model.pt")


    plt.figure(figsize=(10, 3), dpi=130)
    plt.subplot(121).plot(acc_train)
    plt.title("accuracy train")
    plt.subplot(122).plot(ml_train)
    plt.title("mean loss train")
    plt.show()

    plt.figure(figsize=(10, 3), dpi=130)
    plt.subplot(121).plot(acc_val)
    plt.title("accuracy validation")
    plt.subplot(122).plot(ml_val)
    plt.title("mean loss validation")
    plt.show()

### 5&6&7 Antrenare + plotting + salvare model
train_fn(epochs, train_loader, validation_loader, my_net, loss_fn, optimizer)


### 8 Evaluare

my_net.load_state_dict(torch.load("model.pt"))
acc, mean_loss = eval_fn(my_net, test_loader)
print(acc, mean_loss)
# lr = 0.01  -> 0.901 0.6494553565374113
# lr = 0.005 -> 0.937 0.6126021819438429


### 9 Dropout
# lr = 0.01  -> 0.877 0.6709727949412275
# lr = 0.005 -> 0.902 0.6495624635219474
# Performanta cu dropout este mai slaba
