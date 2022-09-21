include("../Type/method_parameter.jl")
include("../Optimization/gradient_descent.jl")
include("../Optimization/stochastic_gradient_descent.jl")
include("../Common/math.jl")

# 多クラスロジスティック回帰
# 従属変数の行列の各行は、属するクラス番号の列のみ1で、残りは0とする。
function multiclass_logistic_regression(xmat::Matrix{T}, ymat::Matrix{X}, method_param::MethodParameter) where {T,X}
    if typeof(method_param) == SGD
        sgd_update(i,w) = begin
            y = ymat[i,:]
            x = xmat[i,:]
            classcount = length(y)
            ∇ = zeros(classcount, length(x)) # クラス数 × 説明変数数の行列
            ps = softmax(w*x)
            for j in 1:classcount
                ∇[j,:] = (y[j] - ps[j]) * x
            end
            return -∇
        end
        return stochastic_gradient_descent(sgd_update
                                           , size(ymat,1)
                                           , method_param.initial_parameter
                                           , method_param.calcη
                                           , method_param.ϵ
                                           , method_param.max_epochs)
    end
end
