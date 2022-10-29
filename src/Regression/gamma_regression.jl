include("../Type/method_parameter.jl")
include("../Optimization/gradient_descent.jl")
using LinearAlgebra

# ガンマ回帰(対数リンク関数)
function gamma_regression(xmat::Array{T}, yvec::Vector{X}, method_param::MethodParameter) where {T,X}
    if typeof(method_param) == GD
        xmat_t = transpose(xmat)
        vec1 = ones(size(xmat,1))
        return gradient_descent(w -> xmat_t * (vec1 - diagm(exp.(-xmat*w))*yvec)
                                , method_param.initial_parameter
                                , method_param.calcη
                                , method_param.ϵ
                                , method_param.max_epochs)
    else
        @error "Not supported $typeof(method_param)"
    end
end
