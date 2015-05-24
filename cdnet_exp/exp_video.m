%%
clear;
clc;

%%
root_folder = '~/Research/changepoint';

addpath(fullfile(root_folder, 'shuang'));
addpath(fullfile(root_folder, 'exploration'));

%%
data_root = [root_folder, '/dataset/cdnet/dataset2012/dataset'];
data_path = 'baseline/pedestrians';
fid = fopen(fullfile(data_root, data_path, 'temporalROI.txt'), 'r');
seq_pair = fscanf(fid, '%d %d');
fclose(fid);

ref_len = seq_pair(1) - 1;
seq_len = seq_pair(2);

patch_width = 8;
patch_height = 8;
channels = 3;
B = 5;

%%
frame_sequence = loadvideo(fullfile(data_root, data_path, 'input'), '*.jpg');
label_sequence = loadvideo(fullfile(data_root, data_path, 'groundtruth'), '*.png');

%%
height = size(frame_sequence, 1);
width = size(frame_sequence, 2);
sequence_length = size(frame_sequence, 4);
sub_sequences = {};
sub_labels = {};
num_seq = 0;
textprogressbar('extracting subsequences');
for i = 1 : patch_height : height
    textprogressbar(i / height * 100);
    h = min(patch_height, height - i + 1);
    for j = 1 : patch_width : width
        w = min(patch_width, width - j + 1);
        num_seq = num_seq + 1;
        sub_sequences{num_seq} = frame_sequence(i : i + h - 1, j : j + w - 1, :, :);
        sub_labels{num_seq} = squeeze(label_sequence(i : i + h - 1, j : j + w - 1, :, :));
        rects{num_seq} = [j, i, w, h];
    end
end
textprogressbar('done');

%%
options.KernelType = 'Gaussian';

subseq_idx = 586;

subseq = sub_sequences{subseq_idx};
subseq = reshape(subseq, size(subseq, 1) * size(subseq, 2) * size(subseq, 3), size(subseq, 4));
ref_data = subseq(:, 1 : ref_len)';
dist_mat = EuDist2(ref_data);
options.t = median(dist_mat(dist_mat ~= 0))
options.prob = 0.02;
[normed_mmd_stats, threshold] = calc_normed_mmd_seq(subseq, ref_len, B, options);
fprintf('done\n');


%% baseline - density ratio

addpath(genpath(fullfile(root_folder, 'baseline/density_ratio')));

n = 50;
k = 50;
alpha = 0.1;

score1 = change_detection(subseq, n, k, alpha);
score2 = change_detection(subseq(:,end:-1:1),n,k,alpha);
score2 = score2(end:-1:1);

score = score1 + score2;
