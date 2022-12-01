include("../Common/math.jl")

# 2項確率分布
# n回中x回事象が発生する確率
binom_dist(n::Int,x::Int,p::Float64) = x <= 0 ? (1-p)^n : n / x * p * binom_dist(n-1,x-1,p)
# 累積2項確率
binom_cdf(n::Int,x::Int,p::Float64) = n == x ? 1.0 : sum(map(x -> binom_dist(n,x,p), 0:x))
# 累積2項確率の逆関数
function binom_inv(n::Int, p1::Float64, p2::Float64)
    if n <= 0
        @error "n is less than or equal 0"
    elseif p1 < 0 || 1 < p1
        @error "p1 is not between 0 and 1."
    elseif p2 < 0 || 1 < p2
        @error "p2 is not between 0 and 1."
    end
    _p = 0.0
    _sum_p = 0.0
    for x in 0:n
        _p = x == 0 ? (1-p1)^n : _p * (n-x+1) / x * p1 / (1-p1)
        _sum_p += _p
        if p2 <= _sum_p
            return x
        end
    end
end
