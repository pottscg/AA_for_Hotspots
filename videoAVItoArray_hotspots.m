%% -- videoAVItoArray_hotspots
% Code processes entire video and sends back as an array
% Input:    filename - video file stored under subfolder RECORDINGS
%           sparsity_threshold - cutoff to remove random noise in image
% Output:   imageData - m*n by numberofframes array storing sparse
%                  processed image information
%           m - number of rows in processed image (useful for
%                  reconstruction)
%           n - number of cols in processed image

function [imageData, m, n] = videoAVItoArray_hotspots(filename, sparsity_threshold)
    tic
    % video processing 
    % .avi to .m matrix
     videoName = strcat('RECORDINGS/',filename,'.avi');
     folder = fileparts(which(videoName));
     movieFullFileName = fullfile(folder, videoName);

    %read file
    videoObject = VideoReader(movieFullFileName);
    numberOfFrames = videoObject.NumberOfFrames;

    %setup storage and store green image
    thisFrame = read(videoObject, 1);
    thisImage = im2double(thisFrame(:,:,2));
    clear thisFrame;

%     thisImage = prepimage_avg(thisImage,image_Average,DS,k);
    [m,n] = size(thisImage);

    thisImage = reshape(thisImage,[],1);
    thisImage = sparse(thisImage);

    imageData = sparse(size(thisImage,1),ceil(numberOfFrames));
    %imageData(:,1) = thisImage;
    clear thisImage;

    % pull frame by frame
    disp('Processing frames');
    index = 1;
    
    for frame = 2 : numberOfFrames
%     for frame = 2:80
            thisFrame = read(videoObject, frame);
            thisImage = im2double(thisFrame(:,:,2));
            
            thisImage(thisImage <= sparsity_threshold) = 0;
            
            thisImage = reshape(thisImage,[],1);
            thisImage = sparse(thisImage);
            imageData(:,index) = thisImage;
            if mod(frame, 20)==0
                disp(frame);
            end
            index = index +1;

    end


    toc
    save(strcat('DATASETS/',filename,'_hotspotsAA_sparsitythreshold',num2str(sparsity_threshold),'.mat'), ...
            'imageData','m','n', '-v7.3');
end