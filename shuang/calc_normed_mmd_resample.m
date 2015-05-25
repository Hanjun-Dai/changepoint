function [normed_mmd_stats, threshold] = calc_normed_mmd_resample(X, ref_len, B, options)
    dim = size(X, 1);
    sequence_length = size(X, 2);
    
    num_blocks = floor(ref_len / B);
    ref_len = num_blocks * B;
    ref_data = X(:, 1 : ref_len);
    var_zb = get_var_zb(ref_data, B, options.t)
    
    ref_data = [];
    for i = 1 : num_blocks
        ref_data = [ref_data, X(:, (i - 1) * B + 1 : i * B)'];
    end
    
    ref_kernel_mat = cell(1, num_blocks);
    for i = 1 : num_blocks
        ref_kernel_mat{i} = constructKernel(ref_data(:, (i - 1) * dim + 1 : i * dim), [], options);
    end
    
    test_data = X(:, ref_len + 1 : ref_len + 1 + B - 1)';
    
    threshold = get_threshold(B, 100, options.prob);
    normed_mmd_stats = [];
    
    idx = 0;
    for pos = ref_len + 1 : sequence_length - B + 1
        idx = idx + 1
    end
end