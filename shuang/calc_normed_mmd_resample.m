function [normed_mmd_stats, threshold] = calc_normed_mmd_resample(X, ref_len, B, options)
    ref_data = X(:, 1 : ref_len);
    var_zb = get_var_zb(ref_data, B, options.t)
    ref_data = ref_data';
    ref_kernel_matrix = constructKernel(ref_data, [], options);
    
    sequence_length = size(X, 2);
    num_blocks = floor(ref_len / B);
end