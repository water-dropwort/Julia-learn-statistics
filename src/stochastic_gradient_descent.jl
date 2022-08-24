# 確率的勾配降下法
# f′はランダムに選択されたインデックスiとパラメータxを引数とする関数
function stochastic_gradient_descent(f′ ,n ,x , η, ϵ, max_epochs, abs)
    history = stochastic_gradient_descent_with_history(f′ ,n ,x , η, ϵ, max_epochs, abs)
    return history[length(history)]["x"]
end

# パラメータの更新過程を配列として返す
function stochastic_gradient_descent_with_history(f′ ,n ,x , η, ϵ, max_epochs, abs)
    history = Dict{String,Any}[]
    for t in (1:max_epochs)
        i = rand(1:n)
        grad = f′(i,x)
        push!(history, Dict("index"=>i, "Grad"=>grad, "η"=>η(t), "x"=>x))
        if abs(grad) < ϵ; break; end
        x -= η(t) * grad
    end
    return history
end
