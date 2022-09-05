# incomplete_ode_comparison
A bad and incomplete comparison of Stan and Turing.jl for ODE models

Sampling the same posterior as in https://benchmarks.sciml.ai/html/ParameterEstimation/DiffEqBayesLotkaVolterra.html

To run the python and Julia script and combine the images as in https://github.com/nsiccha/incomplete_ode_comparison/blob/main/figs/lotka.png run `source run.sh`.

Should produce one figure each in the folder `figs` showing wall times,
which is of course really uninteresting.

Ideally, nobody would care about wall times, but I'm not 100% sure what
the easiest way would be to compare estimated ESS/s, so for now we have this.
