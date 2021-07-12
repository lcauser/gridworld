#=
    Deals with value functions of a grid given a policy.
=#

mutable struct value
    size::Int
    vals::Array{Float64, 2}
end

"""
    zeroValues(size)

Creates a value function estimate of zero for each state.
"""
function zeroValues(size)
    return value(size, 0.0*zeros(size, size))
end


function bellmanUpdate(v::value, g::grid, p::policy)
    # Loop through each grid
    for x = 1:g.size
        for y = 1:g.size
            vs = 0
            # Loop through each action
            for a = 1:4
                # Get the policy
                pa = action(p, x, y, a)
                # Get the state and reward for the action
                (xPrime, yPrime), r = move(g, x, y, a)
            end
        end
    end
end
