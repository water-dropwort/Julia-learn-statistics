using SpecialFunctions

function beta_dist(x, a, b)
    if a <= 0 || b <= 0
        @error "Either parameter a or b is less than or equal 0."
    elseif x < 0 || 1 < x
        @error "x is not between 0 and 1."
    end
    return 1/beta(a,b) * x^(a-1) * (1-x)^(b-1)
end
