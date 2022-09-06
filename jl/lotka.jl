using DiffEqBayes, DynamicHMC
using Distributions, BenchmarkTools
using OrdinaryDiffEq, RecursiveArrayTools, ParameterizedFunctions
using Plots
using StatsPlots
using JSON

f = @ode_def LotkaVolterraTest begin
    dx = a*x - b*x*y
    dy = -c*y + d*x*y
end a b c d
u0 = [1.0,1.0]
tspan = (0.0,10.0)
p = [1.5,1.0,3.0,1,0]
prob = ODEProblem(f,u0,tspan,p)
t = collect(range(1,stop=10,length=10))
# sig = 0.49
data = zeros(2, length(t))
jdata = convert(Array, JSON.parsefile("../data/lotka.json")["u"])
for i in 1:2, j in 1:length(t)
    data[i,j] = jdata[j][i]
end
priors = [Truncated(Normal(1.5,0.5),0.5,2.5),Truncated(Normal(1.2,0.5),0,2),Truncated(Normal(3.0,0.5),1,4),Truncated(Normal(1.0,0.5),0,2)]

# run this once to compile
turing_inference(prob,Tsit5(),t,data,priors,num_samples=1_000);

no_repetitions = 20
runtimes = zeros(no_repetitions)

println("RUNNING TURING.JL BENCHMARK")
for i in 1:no_repetitions
	println("ITERATION", i)
	runtimes[i] = @elapsed sol = turing_inference(prob,Tsit5(),t,data,priors,num_samples=1_000)
	display(sol)
end
println("RUNTIMES:")
println(runtimes)

pp = plot(
	xlabel="Turing.jl", ylabel="runtime [s]", ylim=[0, maximum(runtimes)],
	title="Wall times for Turing.jl\nsampling from the Lotka-Volterra posterior.",
	size=(600, 500)
)
boxplot!(pp, runtimes)
savefig(pp, "../figs/lotka_jl.png")
