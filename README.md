# incomplete_ode_comparison
A bad and incomplete comparison of Stan and Turing.jl for ODE models

Sampling the same posterior as in https://benchmarks.sciml.ai/html/ParameterEstimation/DiffEqBayesLotkaVolterra.html

* To run the python script: `poetry run python3 py/lotka.py`
* To run the Julia notebook: `julia --project=. jl/init.jl`

Should produce one figure each in the folder `figs` showing wall times,
which is of course really uninteresting.
