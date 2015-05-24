%%
clear;
clc;

%%
root_folder = '~/Research/changepoint';

addpath(fullfile(root_folder, 'shuang'));
addpath(fullfile(root_folder, 'exploration'));

%%
file_prefix = [root_folder, '/dataset/speech/testb/clean2/FBW'];

[sequence, segments] = load_raw_seg(file_prefix);

%%
sequence = sequence(:, 1 : 10000);

ref_len = 3200;
B = 16;

%% ours
options.KernelType = 'Gaussian';

ref_data = sequence(:, 1 : ref_len)';
dist_mat = EuDist2(ref_data);
options.t = median(dist_mat(dist_mat ~= 0))
%options.t = 1
options.prob = 0.02;

[normed_mmd_stats, threshold] = calc_normed_mmd_seq(sequence, ref_len, B, options);
fprintf('done\n');

%% baseline - density ratio

addpath(genpath(fullfile(root_folder, 'baseline/density_ratio')));

n = 50;
k = 50;
alpha = 0.1;

score1 = change_detection(sequence, n, k, alpha);
score2 = change_detection(sequence(:,end:-1:1),n,k,alpha);
score2 = score2(end:-1:1);

score = score1 + score2;
