using LinearAlgebra
include("../Type/method_parameter.jl")
include("../Optimization/gradient_descent.jl")
include("../Optimization/stochastic_gradient_descent.jl")

# リッジ回帰
function ridge_regression(xmat::Matrix{T}, yvec::Vector{U}, α::V, method_param::MethodParameter = OLS())  where {T,U,V}
    xmat_t = transpose(xmat)
    k = size(xmat,2)
    Imat = Matrix{Int64}(I,k,k) # 単位行列
    # 最小二乗法
    if typeof(method_param) == OLS
        return inv(xmat_t * xmat + α*Imat) * xmat_t * yvec
    # 最急降下法
    elseif typeof(method_param) == GD
        return gradient_descent(w -> 2*xmat_t*(xmat*w - yvec) + 2*α*w
                                , method_param.initial_parameter
                                , method_param.calcη
                                , method_param.ϵ
                                , method_param.max_epochs)
    # 確率的勾配公開法
    elseif typeof(method_param) == SGD
        N = length(yvec)
        return stochastic_gradient_descent((i,w) -> 2*((dot(xmat[i,:],w)-yvec[i])*xmat[i,:] + α*w/N)
                                           , N
                                           , method_param.initial_parameter
                                           , method_param.calcη
                                           , method_param.ϵ
                                          , method_param.max_epochs)
    else
        @error "Not supported $typeof(method_param)"
    end
end
