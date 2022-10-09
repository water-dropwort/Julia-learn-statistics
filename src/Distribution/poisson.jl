#ポアソン分布
#平均λ回発生する事象がx回発生する確率
poisson_dist(λ::Float64, x::Int) = x <= 0 ? exp(-λ) : (λ/x) * poisson_dist(λ,x-1)
#累積確率分布
poisson_cdf(λ::Float64, x::Int) = sum(map(x -> poisson_dist(λ,x), 0:x))

function poisson_inv(λ::Float64, p::Float64)
    if p < 0 || 1 < p; @error "P is not between 0 to 1"; end

    x = 0
    poisson_p = 0.0
    while true
        poisson_p += poisson_dist(λ, x)
        if p <= poisson_p; return x; end
        x += 1
    end
end
