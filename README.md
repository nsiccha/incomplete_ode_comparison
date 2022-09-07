# incomplete_ode_comparison
A bad and incomplete comparison of Stan and Turing.jl for ODE models

Sampling the same posterior as in https://benchmarks.sciml.ai/html/ParameterEstimation/DiffEqBayesLotkaVolterra.html

BEFORE RUNNING COPY THE `make/local` FILE TO THE CMDSTAN PATH
That file includes some more or less important optimization flags (mostly less).

To run the python and Julia script and combine the images as in https://github.com/nsiccha/incomplete_ode_comparison/blob/main/figs/lotka.png run `source run.sh`.

Generates figures visualizing parameterwise ESS/s over 50 repetitions each.
