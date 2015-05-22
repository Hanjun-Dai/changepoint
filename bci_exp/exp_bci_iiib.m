clear;
clc;

%%
load ../IIIb/X11b.mat;

sequence = s(HDR.TRIG(1) : end, :)';
sequence = sequence(:, 1 : 10000);
ref_len = 700;
B = 10;

seg_labels = HDR.Classlabel(2 : end);
seg_labels(isnan(seg_labels)) = 0;
seg_labels = seg_labels - 1;


%%
options.KernelType = 'Gaussian';

ref_data = sequence(:, 1 : ref_len)';
dist_mat = EuDist2(ref_data);
options.t = median(dist_mat(dist_mat ~= 0));
options.prob = 0.05;

[normed_mmd_stats, labels] = get_segment_labels(sequence, ref_len, B, options);
fprintf('done\n');
