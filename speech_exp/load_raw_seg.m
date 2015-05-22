function [sequence, segments] = load_raw_seg(fileprefix)
    raw_fid = fopen([fileprefix, '.raw'], 'r', 'l');
    sequence = fread(raw_fid, 'int16');
    sequence = reshape(sequence, 1, length(sequence));
    fclose(raw_fid);
    
    seg_fid = fopen([fileprefix, '.seg']);
    a = fscanf(seg_fid, '%d');
    segments = reshape(a, 2, length(a) / 2)';
end