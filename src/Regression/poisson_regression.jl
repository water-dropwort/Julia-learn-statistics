include("../Type/method_parameter.jl")
include("../Optimization/gradient_descent.jl")
include("../Optimization/stochastic_gradient_descent.jl")

# ポアソン回帰(対数リンク関数)
function poisson_regression(xmat::Array{T}, yvec::Vector{X}, method_param::MethodParameter) where {T,X}
    if typeof(method_param) == GD
        xmat_t = transpose(xmat)
        return gradient_descent(w -> xmat_t * (map(exp, xmat*w) - yvec)
                                , method_param.initial_parameter
                                , method_param.calcη
                                , method_param.ϵ
                                , method_param.max_epochs)
    elseif typeof(method_param) == GD_ARMIJO
        xmat_t = transpose(xmat)
        return gradient_descent_armijo(w -> -poisson_logLik(xmat,yvec,w)
                                       , w -> xmat_t * (map(exp, xmat*w) - yvec)
                                       , method_param.initial_parameter
                                       , method_param.ϵ
                                       , method_param.max_epochs
                                       , method_param.α
                                       , method_param.β)
    else
        @error "Not supported $typeof(method_param)"
    end
end

function poisson_logLik(x,y,w)
    logLik = 0.0
    xw = x*w
    for i in (1:length(y))
        logLik += y[i]*xw[i] - exp(xw[i]) - sum(log.(1:y[i]))
    end
    return logLik
end
