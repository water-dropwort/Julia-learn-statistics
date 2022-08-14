include("mean.jl")
include("variance.jl")
using LinearAlgebra

# 単回帰(傾きa、切片bを返す)
function simple_regression(xs,ys)
    if length(xs) != length(ys)
        @error "input same size data."
    end

    a = covariance(xs,ys) / variance(xs)
    b = mean(ys) - a * mean(xs)

    return (a,b)
end

# 平均二乗残差L(a,b)を返す
function mean_square_residual(xs,ys)
    m_x2 = mean(dot(xs,xs)) # E(X^2)
    m_x  = mean(xs) # E(X)
    m_xy = mean(dot(xs,ys)) # E(X,Y)
    m_y  = mean(ys) # E(Y)
    m_y2 = mean(dot(ys,ys)) # E(Y^2)

    return f(a,b) = m_x2*a^2 + b^2 + 2*m_x*a*b - 2*m_xy*a - 2*m_y*b + m_y2
end
