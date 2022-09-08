using LinearAlgebra

# 偏り具合を計算するときの方法
abstract type DistanceMeasureMethod end
struct Range <: DistanceMeasureMethod; end
struct Variance <: DistanceMeasureMethod; end
struct Max <: DistanceMeasureMethod; end

# 既に割付済みのデータ(assigned_data)を見て、各グループ内のFactorが偏らないように、
# 新しいデータ(new_data)の割付先グループを決定する。
# (ex.性別が薬の効きに影響するとして、治療群/プラセボ群間で男女比の偏りが少なくなるようにする。)
# assigned_data : 各データのfactor(男or女、成人or子供 など) と割つけられたグループ
# prob : 最も偏りが少なくなるグループに、確実に割り当てるか(prob=1.0)、確率的に割り当てるか(prob<1.0)
# new_data : 未割当のデータ。各Factorの値が入っている。
# group_ratio_pairs : 各グループとその配分比率。(ex.治療群/プラセボ群が 2:1 になるようにしたい場合、[("治療",2),("プラセボ",1)] などを与える。)
# method : 偏り具合の計算方法
function assign(assigned_data::Vector{Tuple{Vector{Factor},Group}}, prob::AbstractFloat, new_data::Vector{Factor}, group_ratio_pairs::Vector{Tuple{Group,Int}}, method::DistanceMeasureMethod) where {Group,Factor}
    if prob < 0.0 || 1.0 < prob; @error "Prob should be between 0 and 1.";
    elseif length(group_ratio_pairs) <= 1; @error "Length of alloc_ratio is less than or equal 1."
    elseif any(<(1), last.(group_ratio_pairs)); @error "Each allocation ratio should be greater than 0."
    end

    group_set = first.(group_ratio_pairs)

    # 一番最初は等確率に、いずれかのグループに割り当てる
    if length(assigned_data) == 0
        return rand(group_set)
    end

    group_index_dict = Dict(zip(group_set, 1:length(group_set)))

    counting_mat = count_by_group_by_factor(assigned_data, new_data, group_index_dict)
    dist_meas_mat = calc_dist_meas_mat(counting_mat, last.(group_ratio_pairs), method)
    imbalance_scores = calc_imbalance_score(dist_meas_mat)
    return group_set[_assign(imbalance_scores, prob)]
end

# 各ファクターごとに、new_dataのファクターの値と一致するデータ数を、グループ別に集計する。
# 戻り値の行列の各要素は、i番目のグループに属する割付済データで、新規データのj番目のファクターの値と一致するデータ数
function count_by_group_by_factor(assigned_data::Vector{Tuple{Vector{Factor},Group}}, new_data::Vector{Factor}, group_index_dict::Dict{Group,Int}) where {Group,Factor}
    factor_len = length(new_data)
    group_num = length(group_index_dict)
    counting_mat = zeros(Int, group_num, factor_len)
    for (factors, group) in assigned_data
        cmat_row_no = group_index_dict[group]
        for j in (1:factor_len)
            if factors[j] == new_data[j]
                counting_mat[cmat_row_no,j] += 1
            end
        end
    end
    return counting_mat
end

# 期待値(alloc_ratios通りの比率で割付た場合のデータ数)の行列
function calc_expectation_mat(counting_mat::Matrix{Int}, alloc_ratios::Vector{Int})
    total_by_column_vec = sum(counting_mat,dims=1).+1 # 新規データを割付た場合の期待値なので、+1 している。
    ratio_total = sum(alloc_ratios)
    return [total * ratio / ratio_total for ratio in alloc_ratios, total in Iterators.flatten(total_by_column_vec)]
end

# もしgroupᵢに割付た場合に生じる偏りの程度を計算する。
# 戻り値の行列の各要素は、i番目のグループに割つけた時の、j番目のファクターの偏りの程度
function calc_dist_meas_mat(counting_mat::Matrix{Int}, alloc_ratios::Vector{Int}, method::DistanceMeasureMethod)
    group_len = size(counting_mat,1)
    factor_len = size(counting_mat,2)
    dist_meas_mat = zeros(group_len, factor_len)
    expectation_mat = calc_expectation_mat(counting_mat, alloc_ratios)
    for i in (1:group_len)
        diff_mat = counting_mat - expectation_mat
        for j in (1:factor_len)
            diff_mat[i,j] += 1
            dist_meas = calc_dist_meas(diff_mat[:,j], method)
            dist_meas_mat[i,j] = dist_meas
        end
    end
    return dist_meas_mat
end

function calc_dist_meas(diffs::Vector{T}, method::DistanceMeasureMethod) where T <: Real
    if typeof(method) == Range
        return abs(maximum(diffs) - minimum(diffs))
    elseif typeof(method) == Variance
        return dot(diffs,diffs)/length(diffs)
    elseif typeof(method) == Max
        return maximum(diffs)
    else
        @error "Undefined method"
    end
end

# インバランススコア計算
# 戻り値のベクトルは、i番目のグループに割つけた場合の、偏りの程度の合計
function calc_imbalance_score(dist_meas_mat::Matrix{T}) where T <: Real
    return collect(Iterators.flatten(sum(dist_meas_mat,dims=2)))
end

# インバランススコアをもとに、最も偏りが少なくなるグループのインデックスを返す
function _assign(imbalance_score::Vector{T}, prob::AbstractFloat) where T <: Real
    group_num = length(imbalance_score)
    # インバランススコアが最小なグループを選択し、そのインデックスを取得する。(複数該当する場合はランダムに選ぶ)
    sorted_score_indexes = sort(collect(zip(imbalance_score,1:group_num)))
    minimums = collect(Iterators.takewhile(t -> t[1] == first(sorted_score_indexes)[1], sorted_score_indexes))
    group_index = rand(minimums)[2]

    if rand() <= prob
        return group_index
    else
        return rand(collect(Iterators.filter(!=(group_index), 1:group_num)))
    end
end
