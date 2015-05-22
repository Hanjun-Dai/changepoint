function [img_sequence, video_path] = loadvideo(folder_name)
    data_root = '/Users/kangaroo/Research/changepoint/';
    folder = fullfile(data_root, folder_name, '*.jpg');
    image_names = dir(folder);
    image_names = {image_names.name};
    image_names = sort(image_names);
    if nargout > 1
        video_path = fullfile(data_root, folder_name, 'video.avi');
        video = VideoWriter(video_path);
        open(video);
    end
    textprogressbar(sprintf('loading images from %s\t', folder_name));
    for i = 1 : length(image_names)
        textprogressbar(i * 100.0 / length(image_names));
        img = imread(fullfile(data_root, folder_name, image_names{i}));
        if i == 1
            img_sequence = zeros(size(img, 1), size(img, 2), size(img, 3), length(image_names));
        end
        img_sequence(:, :, :, i) = double(img) ./ 255.0;
        if nargout > 1
            writeVideo(video, img);
        end
    end
    if nargout > 1
        close(video);
    end
    textprogressbar('done');
end