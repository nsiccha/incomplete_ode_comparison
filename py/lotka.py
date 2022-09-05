from cmdstanpy import CmdStanModel
import matplotlib.pyplot as plt
import seaborn as sns
import time

model = CmdStanModel(stan_file="stan/lotka.stan")

no_repetitions = 20
runtimes = [0] * no_repetitions


for i in range(no_repetitions):
    start = time.perf_counter()
    model.sample(data="data/lotka.json", adapt_delta=.65, chains=1, show_progress=False)
    runtimes[i] = time.perf_counter() - start

print(runtimes)
sns.boxenplot(y=runtimes)
plt.savefig('figs/lotka_py.png')
