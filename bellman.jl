#=
    Uses the bellman equations to calculate value functions and policies.
=#

"""
    bellmanUpdate(v::Value, g::Grid, p::Policy, gamma:Float64)

Applies one iteration of an asynchronous bellman update. Returns the maximum
difference in value functions of states.
"""
function bellmanUpdate(v::Value, g::Grid, p::Policy, gamma::Float64)
    diff = 0
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

                # Add to the Bellman equation
                vs += pa * (r + gamma * getValue(v, xPrime, yPrime))
            end

            # Calculate the difference
            diff = max(diff, abs(vs-getValue(v, x, y)))

            # Update the value function immediately; this is an asynchronous
            # update
            setValue!(v, x, y, vs)
        end
    end
    return diff
end
