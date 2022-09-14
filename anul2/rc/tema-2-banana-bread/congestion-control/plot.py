import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

#culori default
sns.set_theme()

path = "./congestion-control/saved/bic/"
data = pd.read_csv(path + "socket_stats.csv")

data["Timestamp"] -= data["Timestamp"][0]

sns.set(rc={'figure.figsize':(11.7,8.27)})
sns.lineplot(data=data,x="Timestamp", y="cwnd")
plt.savefig(path + "graph.png")


