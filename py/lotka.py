from cmdstanpy import CmdStanModel
import matplotlib.pyplot as plt
import seaborn as sns
import time

model = CmdStanModel(stan_file="stan/lotka.stan")

no_repetitions = 20
runtimes = [0] * no_repetitions

print("RUNNING STAN BENCHMARK")
for i in range(no_repetitions):
    print(f'ITERATION {i}')
    start = time.perf_counter()
    model.sample(data="data/lotka.json", adapt_delta=.65, chains=1, show_progress=False, iter_sampling=500)
    runtimes[i] = time.perf_counter() - start
print("RUNTIMES:")
print(runtimes)

fig, ax = plt.subplots(1,1)
fig.suptitle("Wall times for CmdStanPy sampling from the Lotka-Volterra posterior.")
ax.set(xlabel="Stan", ylabel="runtime [s]", ylim=[0, max(runtimes)])
sns.boxplot(ax=ax, y=runtimes)
fig.savefig('figs/lotka_py.png')
