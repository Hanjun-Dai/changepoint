function var_zb = get_var_zb(X, B, bandwidth)
    n = size(X, 2) / B;
    
    E_h2 = hxxyy(X, bandwidth);
    cov_hxy = hyy(X, bandwidth);
    
    var_zb = E_h2 / n + (n - 1) * cov_hxy / n;
    
    var_zb = var_zb * 2 / B / (B - 1);
end