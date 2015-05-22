function b = get_threshold(B, T, prob)

    l = 1.0;
    r = 1.0;
    while 1==1
        if calc_tail_prob(l, B, T) < prob
            l = l / 2;
        else
            break
        end
    end
    
    while 1==1
        if calc_tail_prob(r, B, T) > prob
            r = r * 2;
        else
            break
        end
    end
    
    while abs(l - r) > 1e-6
        b = (l + r) / 2;
        pr = calc_tail_prob(b, B, T);
        if (pr < prob)
            r = b;
        else
            l = b;
        end
    end
end