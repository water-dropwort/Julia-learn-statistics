#ポアソン分布
#平均λ回発生する事象がx回発生する確率
poisson_dist(λ::Float64, x::Int) = x <= 0 ? exp(-λ) : (λ/x) * poisson_dist(λ,x-1)
#累積確率分布
poisson_cdf(λ::Float64, x::Int) = sum(map(x -> poisson_dist(λ,x), 0:x))
