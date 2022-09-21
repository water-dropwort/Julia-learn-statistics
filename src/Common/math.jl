function sigmoid(x)
    return 1 / (1 + exp(-x))
end

function softmax(xs)
    exs = exp.(xs)
    return exs ./ sum(exs)
end
