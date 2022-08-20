using LinearAlgebra
# リッジ回帰
function ridge_regression(X::Matrix{T}, y::Vector{U}, α::V)  where {T,U,V}
    X_T = transpose(X)
    Imat = Matrix{Int64}(I,length(y),length(y)) # 単位行列
    return inv(X_T * X + α*Imat) * X_T * y
end
