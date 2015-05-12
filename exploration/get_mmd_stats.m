function mmd_stats = get_mmd_stats(X, ref_len, B, kernel_options)
    ref_data = X(:, 1 : ref_len)';
    ref_kernel_matrix = constructKernel(ref_data, [], kernel_options);
    
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
    for pos = ref_len + 1 : sequence_length - B + 1
        idx = idx + 1;
        
        test_data = X(:, pos : pos + B - 1)';
        T = constructKernel(test_data, [], kernel_options);
        T(logical(eye(size(T)))) = 0;
        
        mmd_stats(idx) = avg_kxx + sum(T(:)) / B / (B - 1);
        
        tmp = 0;
        for i = 1 : num_blocks
            C = constructKernel(ref_data((i - 1) * B + 1 : i* B, :), test_data, kernel_options);
            tmp = tmp - 2.0 * sum(C(:)) / B / (B - 1);
        end
        mmd_stats(idx) = mmd_stats(idx) + tmp / num_blocks;
    end
end