%%
clear;
clc;

%%
ref_len = 300;
B = 5;
datapath = 'dataset2012/dataset/baseline/pedestrians/input';
patch_width = 8;
patch_height = 8;
channels = 3;
%%
frame_sequence = loadvideo(datapath);

%%
height = size(frame_sequence, 1);
width = size(frame_sequence, 2);
sequence_length = size(frame_sequence, 4);
sub_sequences = {};
num_seq = 0;
textprogressbar('extracting subsequences');
for i = 1 : patch_height : height
    textprogressbar(i / height * 100);
    h = min(patch_height, height - i + 1);
    for j = 1 : patch_width : width
        w = min(patch_width, width - j + 1);
        num_seq = num_seq + 1;
        sub_sequences{num_seq} = frame_sequence(i : i + h - 1, j : j + w - 1, :, :);
        rects{num_seq} = [j, i, w, h];
    end
end
textprogressbar('done');

%%

kernel_options.KernelType = 'Gaussian';

subseq_idx = 586;

subseq = sub_sequences{subseq_idx};
subseq = reshape(subseq, size(subseq, 1) * size(subseq, 2) * size(subseq, 3), size(subseq, 4));
ref_data = subseq(:, 1 : ref_len)';
dist_mat = EuDist2(ref_data);
kernel_options.t = median(dist_mat(dist_mat ~= 0));
kernel_options.t = 0.1;
mmd_stats = get_mmd_stats(subseq, ref_len, B, kernel_options);

%%
implay(frame_sequence);
