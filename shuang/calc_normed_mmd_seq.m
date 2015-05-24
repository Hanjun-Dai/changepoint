function [normed_mmd_stats, threshold] = calc_normed_mmd_seq(X, ref_len, B, options)
    
    ref_data = X(:, 1 : ref_len);
    var_zb = get_var_zb(ref_data, B, options.t)
    ref_data = ref_data';
    ref_kernel_matrix = constructKernel(ref_data, [], options);
    
    sequence_length = size(X, 2);
    num_blocks = floor(ref_len / B);
    
    avg_kxx = 0;
    for i = 1 : num_blocks
        A = ref_kernel_matrix((i - 1) * B + 1 : i * B, (i - 1) * B + 1 : i * B);
        A(logical(eye(size(A)))) = 0;
        avg_kxx = avg_kxx + sum(A(:)) / B / (B - 1);
    end
    avg_kxx = avg_kxx / num_blocks;
    
    idx = 0;
    T = sequence_length - B + 1 - ref_len;
    threshold = get_threshold(B, 100, options.prob)
    
    for pos = ref_len + 1 : sequence_length - B + 1
        idx = idx + 1
        
        test_data = X(:, pos : pos + B - 1)';
        T = constructKernel(test_data, [], options);
        T(logical(eye(size(T)))) = 0;
        
        mmd = avg_kxx + sum(T(:)) / B / (B - 1);
        
        tmp = 0;
        for i = 1 : num_blocks
            C = constructKernel(ref_data((i - 1) * B + 1 : i* B, :), test_data, options);
            tmp = tmp - 2.0 * sum(C(:)) / B / (B - 1);
        end
        mmd = mmd + tmp / num_blocks;
        
        % normalize
        normed_mmd_stats(idx) = mmd / sqrt(var_zb);
        
        if normed_mmd_stats(idx) > threshold
            labels(idx) = 1;
        else
            labels(idx) = 0;
        end
    end
end