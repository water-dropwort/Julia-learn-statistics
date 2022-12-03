using SpecialFunctions

# ベータ分布の確率密度関数
function beta_pdf(x, a, b)
    if a <= 0 || b <= 0
        @error "Either parameter a or b is less than or equal 0."
    elseif x < 0 || 1 < x
        @error "x is not between 0 and 1."
    end
    return 1/beta(a,b) * x^(a-1) * (1-x)^(b-1)
end

# 累積密度関数
function beta_cdf(x, a, b)
    if a <= 0 || b <= 0
        @error "Either parameter a or b is less than or equal 0."
    elseif x < 0 || 1 < x
        @error "x is not between 0 and 1."
    end

    return beta_inc(Float64(a), Float64(b), x)[1]
end

# 逆累積密度関数
function beta_cdf_inv(p, a, b)
    if a <= 0 || b <= 0
        @error "Either parameter a or b is less than or equal 0."
    elseif p < 0 || 1 < p
        @error "p is not between 0 and 1."
    end

    return beta_inc_inv(Float64(a), Float64(b), p)[1]
end

# 100(1-α)%HPD領域を求める
function beta_hpd(α, a, b, interval = 0.0001, threshold = 0.0001)
    if a <= 0 || b <= 0
        @error "Either parameter a or b is less than or equal 0."
    elseif α < 0 || 1 < α
        @error "α is not between 0 and 1."
    end

    # 単峰
    if a > 1 && b > 1
        searchmax = beta_cdf_inv(α, a, b)
        prediff = nothing
        for x in 0.0:interval:searchmax
            y = beta_cdf_inv(beta_cdf(x,a,b)+(1-α), a, b)
            fx = beta_pdf(x, a, b)
            fy = beta_pdf(y, a, b)
            diff = abs(fx-fy)
            if isnothing(prediff) || prediff > diff
                prediff = diff
            else
                return [x, y]
            end
        end
        return [nothing]
    # 一様分布
    elseif a == 1 && b == 1
        @error "Not implemented"
    #
    elseif (a == 1 && b > 1) || (a < 1 && b == 1)
        @error "Not implemented"
    #
    elseif (a > 1 && b == 1) || (a == 1 && b < 1)
        @error "Not implemented"
    elseif (a < 1 && b < 1)
        @error "Not implemented"
    end
end
