#=
    Create a grid with the define rewards for each action.

    Rewards are a three-dimensional array, r[x, y, a], where x and y are the
    grid coordinates. The a specifies the direction, 1: up, 2: right, 3:down,
    4: left.
=#

mutable struct grid
    size::Int
    rewards::Array{Float64, 3}
end

"""
    state, reward = move(g::grid, x, y, a)

Given a grid, position coordinates x and y, and an action, calculate the new
state and the reward.
"""
function move(g::grid, x, y, a)
    if x == 1 && y == 1
        return (1, 1), 0.0
    end

    if a == 2
        yPrime = y
        if x == g.size
            xPrime = x
        else
            xPrime = x + 1
        end
    elseif a == 4
        yPrime = y
        if x == 1
            xPrime = x
        else
            xPrime = x - 1
        end
    elseif a == 1
        xPrime = x
        if y == 1
            yPrime = y
        else
            yPrime = y - 1
        end
    elseif a == 3
        xPrime = x
        if y == g.size
            yPrime = y
        else
            yPrime = y + 1
        end
    end

    return (xPrime, yPrime), g.rewards[x, y, a]
end

"""
    basicGrid(size)

Creates a grid of size size with a -1 reward for every move, other than those
which result in remaining in the top-left square.
"""
function basicGrid(size)
    rs = -1*ones(size, size, 4)
    rs[1, 1, :] = [0.0, 0.0, 0.0, 0.0]
    return grid(size, rs)
end
