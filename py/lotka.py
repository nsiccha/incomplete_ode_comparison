from cmdstanpy import CmdStanModel
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import time
import arviz as az

model = CmdStanModel(stan_file="stan/lotka.stan")

no_repetitions = 50
runtimes = [0] * no_repetitions
esss = np.zeros((no_repetitions, 5))

print("RUNNING STAN BENCHMARK")
for i in range(no_repetitions):
    print(f'ITERATION {i}')
    start = time.perf_counter()
    sol = model.sample(data="data/lotka.json", adapt_delta=.65, chains=6, show_progress=False, iter_warmup=500)
    runtimes[i] = time.perf_counter() - start
    esss[i,:] = az.ess(sol).to_array() / runtimes[i]
    print(esss[i,:])
    # print(az.summary(sol))
print("RUNTIMES:")
print(runtimes)

fig, ax = plt.subplots(1,1)
fig.suptitle("ESS/s for CmdStanPy sampling from the Lotka-Volterra posterior.")
ax.set(
    xlabel=f"Stan, mean ESS/s:\n{np.round(np.mean(esss, axis=0))}",
    ylabel="ESS/s [1/s]", ylim=[0, 1000],
    xlim=[.5, 5.5], yticks=[0,200,400,600,800,1000]
)
ax.grid(True)
# sns.boxplot(ax=ax, y=runtimes)
sns.boxplot(ax=ax, data=esss)
sns.swarmplot(ax=ax, data=esss, color="red")
plt.tight_layout()
fig.savefig('figs/lotka_py.png')
