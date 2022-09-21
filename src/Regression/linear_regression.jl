using LinearAlgebra
include("../Type/method_parameter.jl")
include("../Optimization/gradient_descent.jl")
include("../Optimization/stochastic_gradient_descent.jl")

# 線形回帰(最小二乗法)
function linear_regression(xmat::Matrix{T}, yvec::Vector{X}, method_param::MethodParameter = Diff0()) where {T,X}
    xmat_t = transpose(xmat)
    # 解析的に解く
    if typeof(method_param) == Diff0
        return inv(xmat_t * xmat) * xmat_t * yvec
    # 最急降下法
    elseif typeof(method_param) == GD
        return gradient_descent(w -> 2 * xmat_t * (xmat * w - yvec)
                                , method_param.initial_parameter
                                , method_param.calcη
                                , method_param.ϵ
                                , method_param.max_epochs)
    # 確率的勾配降下法
    elseif typeof(method_param) == SGD
        return stochastic_gradient_descent((i,w) -> 2 * (dot(xmat[i,:],w) - yvec[i]) * xmat[i,:]
                                           , length(yvec)
                                           , method_param.initial_parameter
                                           , method_param.calcη
                                           , method_param.ϵ
                                           , method_param.max_epochs)
    else
        @error "Not supported $typeof(method_param)"
    end
end
