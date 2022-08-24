# 最急降下法
# absはϵ>0と比較するためのR^n->Rの関数
function gradient_descent(f′ ,x , η, ϵ, max_epochs, abs)
    history = gradient_descent_with_history(f′ ,x , η, ϵ, max_epochs, abs)
    return history[length(history)]["x"]
end

# パラメータの更新過程を配列として返す
function gradient_descent_with_history(f′ ,x , η, ϵ, max_epochs, abs)
    history = Dict{String,Any}[]
    for t in (1:max_epochs)
        grad = f′(x)
        push!(history, Dict("Grad"=>grad, "η"=>η(t), "x"=>x))
        if abs(grad) < ϵ; break; end
        x -= η(t) * grad
    end
    return history
end
