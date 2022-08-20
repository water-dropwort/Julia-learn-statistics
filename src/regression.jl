using LinearAlgebra

# NxKの説明変数の行列とN次元の被説明変数のベクトルを受けとり、K次元のパラメータのベクトルを返す。
function regression(xmat::Matrix{T}, yvec::Vector{X}) where {T,X}
    # 行列の1列目のベクトルの要素数とyvecの要素数の比較。
    if length(xmat[:,1]) != length(yvec)
        @error "Arguments are NxK matrix and N dims vector."
    end

    xmat_t = transpose(xmat)
    return inv(xmat_t * xmat) * xmat_t * yvec
end
