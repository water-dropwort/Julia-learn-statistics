# 最急降下法
# absはϵ>0と比較するためのR^n->Rの関数
function gradient_descent(f′ ,x , η, ϵ, max_epochs)
    history = gradient_descent_with_history(f′ ,x , η, ϵ, max_epochs)
    return history[length(history)]["x"]
end

# パラメータの更新過程を配列として返す
function gradient_descent_with_history(f′ ,x , η, ϵ, max_epochs)
    history = Dict{String,Any}[]
    for t in (1:max_epochs)
        grad = f′(x)
        push!(history, Dict("Grad"=>grad, "η"=>η(t), "x"=>x))
        if sum(abs.(grad)) < ϵ; break; end
        x -= η(t) * grad
    end
    return history
end

# アルミホルールを用いた最急降下法
# 参照:http://www-optima.amp.i.kyoto-u.ac.jp/~nobuo/Ryukoku/2002/course7.pdf
function gradient_descent_armijo(f, f′, x, ϵ, max_epochs, α, β)
    for t in (1:max_epochs)
        grad = f′(x)
        d = -grad
        if sum(abs.(grad)) < ϵ; return x; end

        # アルミホのルールでステップ幅を求める
        step = 0.0
        grad_t = transpose(grad)
        fx = f(x)
        for i in (0:1000)
            step = β^i
            if f(x + step*d) - fx <= α*step*grad_t*d; break; end
        end
        x += step * d
    end
    return x
end
