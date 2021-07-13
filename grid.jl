#=
    Create a grid with the define rewards for each action.

    Rewards are a three-dimensional array, r[x, y, a], where x and y are the
    grid coordinates. The a specifies the direction, 1: up, 2: right, 3:down,
    4: left.
=#

mutable struct Grid
    size::Int
    rewards::Array{Float64, 3}
end

"""
    state, reward = move(g::grid, x::Int, y::Int, a::Int)

Given a grid, position coordinates x and y, and an action, calculate the new
state and the reward.
"""
function move(g::Grid, x::Int, y::Int, a::Int)
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

    return (xPrime, yPrime), g.rewards[y, x, a]
end

"""
    neighbours(g::Grid, x::Int, y::Int)

Returns the neighbouring tiles to a given position.
"""
function neighbours(g::Grid, x::Int, y::Int)
    tiles = []
    if x != 1
        push!(tiles, [x-1, y])
    end
    if y != 1
        push!(tiles, [x, y-1])
    end
    if x != g.size
        push!(tiles, [x+1, y])
    end
    if y != g.size
        push!(tiles, [x, y+1])
    end

    return tiles
end

"""
    basicGrid(size::Int)

Creates a grid of size size with a -1 reward for every move, other than those
which result in remaining in the top-left square.
"""
function basicGrid(size::Int)
    rs = -1*ones(size, size, 4)
    rs[1, 1, :] = [0.0, 0.0, 0.0, 0.0]
    return Grid(size, rs)
end


"""
    stochasticGrid(size::Int, alpha::Float64, beta::Float64)

Create a grid where going up and down randomly pick alpha or beta for the reward
(same for left and right). The two will not be the same, but randomly opposite.
"""
function stochasticGrid(size::Int, alpha::Float64, beta::Float64)
    rs = zeros(size, size, 4)
    for x = 1:size
        for y = 1:size
            choices = round.(rand(2), digits=0)
            append!(choices, 1 .- choices)
            rs[x, y, :] = -1 .* (alpha .* choices + beta .* (1 .- choices))
        end
    end
    rs[1, 1, :] = [0.0, 0.0, 0.0, 0.0]
    return Grid(size, rs)
end
