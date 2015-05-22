%%
addpath('/Users/kangaroo/Research/changepoint/shuang/');
addpath('/Users/kangaroo/Research/changepoint/exploration/');

%%
clear;
clc;

%%
file_prefix = '../speech/speech_jp/tool/fvad/FAK';

[sequence, segments] = load_raw_seg(file_prefix);

sequence = [sequence(:, 1 : 3200), sequence(:, 1 : 10000)];

ref_len = 6400;
B = 32;

%%
options.KernelType = 'Gaussian';

ref_data = sequence(:, 1 : ref_len)';
dist_mat = EuDist2(ref_data);
options.t = median(dist_mat(dist_mat ~= 0))
options.t = 8;
options.prob = 0.05;

[normed_mmd_stats, labels] = get_segment_labels(sequence, ref_len, B, options);
fprintf('done\n');
