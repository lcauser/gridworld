include("grid.jl")
include("value.jl")
include("policy.jl")
include("bellman.jl")

N = 10
alpha = 0.7
gamma = 0.99
epsilon = 0.001
g = stochasticGrid(N, alpha, 1-alpha)
v = zeroValues(N)
p = stochasticPolicy(N)

iterate!(v, g, p, gamma; max_iter=1)
v = zeroValues(N)
evaluate!(v, g, p, gamma; max_iter=1000, eps=epsilon)
