include("../Type/method_parameter.jl")
include("../Optimization/gradient_descent.jl")
include("../Optimization/stochastic_gradient_descent.jl")
include("../Common/math.jl")

# ロジスティック回帰
# yvecの各要素は{0,1}
function logistic_regression(xmat::Matrix{T}, yvec::Vector{X}, method_param::MethodParameter) where {T,X}
    if typeof(method_param) == GD
        xmat_t = transpose(xmat)
        return gradient_descent(w -> -xmat_t * (yvec - map(sigmoid, xmat*w))
                                , method_param.initial_parameter
                                , method_param.calcη
                                , method_param.ϵ
                                , method_param.max_epochs)
    elseif typeof(method_param) == SGD
        return stochastic_gradient_descent((i,w) -> -(yvec[i]-sigmoid(dot(w,xmat[i,:]))) * xmat[i,:]
                                           , length(yvec)
                                           , method_param.initial_parameter
                                           , method_param.calcη
                                           , method_param.ϵ
                                           , method_param.max_epochs)
    else
        @error "Not supported $typeof(method_param)"
    end
end

