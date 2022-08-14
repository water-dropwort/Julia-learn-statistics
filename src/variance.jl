include("mean.jl")

# 分散
function variance(data)
    return covariance(data,data)
end

# 標準偏差
function stdev(data)
    return sqrt(variance(data))
end

# 共分散
function covariance(xs,ys)
    if length(xs) != length(ys)
        @error "input same size data."
    end

    m_xs = mean(xs)
    m_ys = mean(ys)
    tmp = 0
    for i in (1:length(xs))
        tmp += (xs[i]-m_xs) * (ys[i]-m_ys)
    end
    return tmp / length(xs)
end
