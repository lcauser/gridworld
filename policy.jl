#=
    Creates the policy of actions an agent can take at any point on the grid.
    The policy will be probabilistic, with probabilities of taking an action
    given by p[x, y, a].
=#

mutable struct policy
    size::Int
    probs::Array{Float64, 3}
end

function action(p::policy, x::Int, y::Int, a::Int)
    return p.probs[x, y, a]
end

"""
    stochasticPolicy(size)

Creates a policy whereby any action is picked with equal probability for a grid
of size size.
"""
function stochasticPolicy(size)
    return policy(size, 0.25*ones(size, size, 4))
end
