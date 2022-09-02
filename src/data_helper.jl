# 指定された割合でランダムにデータを2つに分ける
function randomsplit(xs::Vector{T}, ratio) where T
    if false == (0.0 < ratio < 1.0)
        @error "ratio should be element of (0.0,1.0)."
    end

    #分割後の配列のサイズが変化しないように、あらかじめ枠を用意しておき、
    #どちらのグループに割り当てるかをランダムに決めて、埋めていく。
    N = length(xs)
    N1 = Int(floor(N*ratio))
    N2 = N - N1
    res1 = Array{T}(undef, N1)
    res2 = Array{T}(undef, N2)

    i1 = 0; i2 = 0
    for x in xs
        if (i1 >= N1 || i2 >= N2) ; break; end
        if rand(Bool)
            i1 += 1; res1[i1] = x
        else
            i2 += 1; res2[i2] = x
        end
    end

    #先のループで埋まらなかった方のグループに残りのデータを詰める。
    if i1 >= N1
        for i in (i1+i2+1:N); i2 += 1; res2[i2] = xs[i]; end
    else
        for i in (i1+i2+1:N); i1 += 1; res1[i1] = xs[i]; end
    end

    return (res1, res2)
end

# 配列を各要素の個数の辞書に変換する
# e.g. ["a","b","c","a","b","a"] -> ("c"=>1,"b"=>2,"a"=>3)
function counter(items::Vector{T}) where {T}
    counter_dict = Dict{T,Int}()
    for item in items
        if haskey(counter_dict, item)
            counter_dict[item] += 1
        else
            push!(counter_dict, item=>1)
        end
    end
    return counter_dict
end

# 辞書の配列と、その辞書のキー一覧から、Matrixを作成する。
function makeMatrixfromDicts(dicts::Vector{Dict{T,U}}, uniquekeys::Array{T}) where {T,U<:Real}
    N = length(dicts)
    M = length(uniquekeys)
    matrix = ones(U, N, M+1)
    for i in (1:N)
        for j in (1:M)
            key = uniquekeys[j]
            matrix[i,j] = get(dicts[i], key, 0)
        end
    end
    return matrix
end
