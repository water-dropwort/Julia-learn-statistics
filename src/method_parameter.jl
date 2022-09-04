abstract type MethodParameter end

# 最小二乗法
struct OLS <: MethodParameter
end

# 最急降下法
struct GD <: MethodParameter
    initial_parameter
    calcη
    ϵ
    max_epochs
end

# 確率的勾配降下法
struct SGD <: MethodParameter
    initial_parameter
    calcη
    ϵ
    max_epochs
end
