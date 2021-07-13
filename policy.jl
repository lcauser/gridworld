#=
    Creates the policy of actions an agent can take at any point on the grid.
    The policy will be probabilistic, with probabilities of taking an action
    given by p[x, y, a].
=#

mutable struct Policy
    size::Int
    probs::Array{Float64, 3}
end


"""
    action(p::Policy, x::Int, y::Int, a::Int)

Returns the probability of an action in a policy.
"""
function action(p::Policy, x::Int, y::Int, a::Int)
    return p.probs[y, x, a]
end

"""
    stochasticPolicy(size)

Creates a policy whereby any action is picked with equal probability for a grid
of size size.
"""
function stochasticPolicy(size)
    return Policy(size, 0.25*ones(size, size, 4))
end


"""
    evaluate!(v::Value, g::Grid, p::Policy, gamma::Float64; kwargs...)

Evaluate the value function for a policy with the discount rate gamma. Use
max_iter::Int to specify max bellman iterations or eps::Float64 for convergence
criteria in the key arguments.
"""
function evaluate!(v::Value, g::Grid, p::Policy, gamma::Float64; kwargs...)
    # Get key arguments
    max_iter::Int = get(kwargs, :max_iter, 10)
    eps::Float64 = get(kwargs, :eps, 1e-3)

    for i = 1:max_iter
        diff = bellmanUpdate(v, g, p, gamma)

        if diff < eps
            break
        end
    end
end

"""
    updatePolicy!(p::Policy, x::Int, y::Int, ps::Array{Float64})

Updates the policies at the state.
"""
function updatePolicy!(p::Policy, x::Int, y::Int, ps::Array{Float64})
    p.probs[y, x, :] = ps
end


"""
    greedyUpdate(v::Value, g::Grid, p::Policy)

Given the value function, it optimizes the policy such that it acts greedily
to maximise immediate reward. Returns the maximum difference in policy.
"""
function greedyUpdate(v::Value, g::Grid, p::Policy)
    diff = 0
    # Loop through each tile
    for x = 1:v.size
        for y = 1:v.size
            # Find values of taking each action
            vals = []
            for a = 1:4
                (xPrime, yPrime), r = move(g, x, y, a)
                push!(vals, getValue(v, xPrime, yPrime))
            end
            vals = round.(vals, digits=4) # Round to remove numerical error

            # Find the maximum value and where it is
            m = maximum(vals)
            ps = [val == m for val = vals]
            ps = ps .* (1 / sum(ps))

            # Measure the difference in policies
            diff = max(diff, (sum((p.probs[y, x, :] - ps).^2))^0.5)

            # Update the policy
            updatePolicy!(p, x, y, ps)
        end
    end
    return diff
end


"""
    iterate!(v::Value, g::Grid, p::Policy, gamma::Float64; kwargs...)

Do a policy improvment iteration by evaluating the policy, and acting greedily
to update it for a discounted return gamma. Use max_iter::Int and eps::Float64
to specify convergence criteria for evaluation.
"""
function iterate!(v::Value, g::Grid, p::Policy, gamma::Float64; kwargs...)
    # Loop through until the policy is unchanged
    diff = 1
    while diff > 0
        evaluate!(v, g, p, gamma; kwargs)
        diff = greedyUpdate(v, g, p)
    end
end
