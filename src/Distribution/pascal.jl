include("binomial.jl")

# パスカル分布
# r回成功するまでの試行回数x。
pascal_dist(x::Int, r::Int, p::Float64) = p * binom_dist(x-1,r-1,p)
# 累積確率分布
pascal_cdf(x_lim::Int, r::Int, p::Float64) = sum(map(x->pascal_dist(x,r,p), r:x_lim))
