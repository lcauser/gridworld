#=
    Deals with value functions of a grid given a policy.
=#

mutable struct Value
    size::Int
    vals::Array{Float64, 2}
end

"""
    getValue(v::Value, x::Int, y::Int)

Return the value at (x, y) of a value function.
"""
function getValue(v::Value, x::Int, y::Int)
    return v.vals[y, x]
end

"""
    setValue!(v::Value, x::Int, y::Int, val::Float64)

Set the value in a value function at (x, y)
"""
function setValue!(v::Value, x::Int, y::Int, val::Float64)
    v.vals[y, x] = val
end

"""
    zeroValues(size)

Creates a value function estimate of zero for each state.
"""
function zeroValues(size)
    return Value(size, 0.0*zeros(size, size))
end
