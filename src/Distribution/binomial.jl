include("../Common/math.jl")

# 2項確率分布
# n回中x回事象が発生する確率
binom_dist(n::Int,x::Int,p::Float64) = x <= 0 ? (1-p)^n : n / x * p * binom_dist(n-1,x-1,p)
# 累積2項確率
binom_cdf(n::Int,x::Int,p::Float64) = sum(map(x -> binom_dist(n,x,p), 0:x))
