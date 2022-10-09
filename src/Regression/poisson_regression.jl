include("../Type/method_parameter.jl")
include("../Optimization/gradient_descent.jl")
include("../Optimization/stochastic_gradient_descent.jl")

# ポアソン回帰
function poisson_regression(xmat::Matrix{T}, yvec::Vector{X}, method_param::MethodParameter) where {T,X}
    if typeof(method_param) == GD
        xmat_t = transpose(xmat)
        return gradient_descent(w -> xmat_t * (map(exp, xmat*w) - yvec)
                                , method_param.initial_parameter
                                , method_param.calcη
                                , method_param.ϵ
                                , method_param.max_epochs)
    else
        @error "Not supported $typeof(method_param)"
    end
end

