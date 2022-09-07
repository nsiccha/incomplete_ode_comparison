using ArviZ
using Turing
using Distributions, StaticArrays
using OrdinaryDiffEq, RecursiveArrayTools, ParameterizedFunctions
using Plots, LinearAlgebra, StatsPlots, JSON
using Logging
Logging.disable_logging(Logging.Warn);

f = @ode_def LotkaVolterraTest begin
    dx = a*x - b*x*y
    dy = -c*y + d*x*y
end a b c d

u0 = [1.0,1.0]
tspan = (0.0,10.0)
p = [1.5,1.0,3.0,1.0]

prob = ODEProblem(f, u0, tspan, p)
# sol = solve(prob,Tsit5())

su0 = SA[1.0,1.0]
sp = SA[1.5,1.0,3.0,1.0]
sprob = ODEProblem{false,SciMLBase.FullSpecialize}(f, su0, tspan, sp)
# sol = solve(sprob,Tsit5())

t = collect(range(1,stop=10,length=10))
# sig = 0.49
# data = convert(Array, VectorOfArray([(sol(t[i]) + sig*randn(2)) for i in 1:length(t)]))

data = zeros(2, length(t))
jdata = convert(Array, JSON.parsefile("../data/lotka.json")["u"])
for i in 1:2, j in 1:length(t)
    data[i,j] = jdata[j][i]
end

priors = [truncated(Normal(1.5,0.5),0.5,2.5),truncated(Normal(1.2,0.5),0,2),truncated(Normal(3.0,0.5),1,4),truncated(Normal(1.0,0.5),0,2)]

@model function fitlv(t, data, prob)
    # Prior distributions.
    σ ~ InverseGamma(2, 3)
    α ~ truncated(Normal(1.5, 0.5), 0.5, 2.5)
    β ~ truncated(Normal(1.2, 0.5), 0, 2)
    γ ~ truncated(Normal(3.0, 0.5), 1, 4)
    δ ~ truncated(Normal(1.0, 0.5), 0, 2)

    # Simulate Lotka-Volterra model.
    p = SA[α, β, γ, δ]
    _prob = remake(prob, p = p)
    predicted = solve(_prob, Tsit5(); saveat=t)

    # Observations.
    for i in 1:length(predicted)
        data[:, i] ~ MvNormal(predicted[i], σ^2 * I)
    end

    return nothing
end

model = fitlv(t, data, sprob)

@time chain = sample(model, NUTS(0.65), MCMCThreads(), 1000, 6; progress=false)

no_repetitions = 50
runtimes = zeros(no_repetitions)
esss = zeros(no_repetitions, 5)

println("RUNNING TURING.JL BENCHMARK (STATIC)")
for i in 1:no_repetitions
	println("ITERATION", i)
	runtimes[i] = @elapsed sol = sample(model, NUTS(0.65), MCMCThreads(), 1000, 6; progress=false)
	sess = ArviZ.ess(sol)
	esss[i, :] .= [sess.σ sess.α sess.β sess.γ sess.δ]' ./ runtimes[i]
	println(esss[i,:])
	display(sol)
end
println("RUNTIMES:")
println(runtimes)

pp = plot(
	xlabel="Turing.jl, mean ESS/s:\n$(round.(mean(esss, dims=1)))", ylabel="ESS/s [1/s]", ylim=[0, 1000],
	title="ESS/s for static Turing.jl\nsampling from the Lotka-Volterra posterior.",
	yticks=[0 200 400 600 800 1000]',
	size=(600, 500)
)
x = hcat([
	0:4
	for i in 1:1
]...)

boxplot!(pp, x', esss, label="")
dotplot!(pp, x', esss, color=:red, label="")
savefig(pp, "figs/lotka_jl.png")
