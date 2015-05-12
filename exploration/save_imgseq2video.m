function save_imgseq2video(filename, imgseq)
    video = VideoWriter(filename);
    open(video);
    
    for i = 1 : size(imgseq, 4)
        writeVideo(video, imgseq(:, :, :, i));
    end
    
    close(video);
end