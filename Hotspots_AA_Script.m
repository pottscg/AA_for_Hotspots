%% Set-up
% file to process
filename = 'DIV13lif-C5-1'

% file type (.avi or .tiff)
file_type = '.avi'

% percent of thresholding 0 - 1 
thresholding = 0.975

% number of archetypes (components)
noc = 9


%% Calculate sparsity threshold
if file_type == '.avi'
    videoName = strcat('RECORDINGS/',filename,'.avi');
    folder = fileparts(which(videoName));
    movieFullFileName = fullfile(folder, videoName);

    %read file
    videoObject = VideoReader(movieFullFileName);
    numberOfFrames = videoObject.NumberOfFrames;
    thisFrame = read(videoObject, fix(numberOfFrames/2));

    % calculate threshold via quantiles
    thisImage = im2double(thisFrame(:,:,2));
    sparsity_threshold = quantile(reshape(thisImage, [],1),thresholding);
    disp(strcat('sparsity threshold -- ', num2str(sparsity_threshold)));
    filename = strcat(filename, '_sparsitythreshold_',num2str(sparsity_threshold));
else
    disp('Invalid file type, must be .avi');
end

%% Image preprocessing

if file_type == '.avi'
    [X, m, n] = videoAVItoArray_hotspots(filename, sparsity_threshold);
else
    disp('Invalid file type, must be .avi');
end

disp('Image processing completed');

%% Sketch

% sketch projection dimension
D = 1024;

% Gaussian projection
PSI = reshape(randn(D*n*m,1),[D,n*m]);
% disp('PSI calculated');

% sketched data storage
imageData = sparse(D,size(X,2));

% create sketch
for i = 1:size(X,2)
    sketched_image = PSI*X(:,1);
    sketched_image = sparse(sketched_image);
    imageData(:,i) = sketched_image;
end

disp('Sketching completed');

%% Run AA

disp('ready to start AA');

filename = strcat(filename, '_hotspots_sketchdim_', num2str(D));
filepath = filename;

Run_AA_Script;

% calculate archetypes for figures
XC = X*C;

disp('Archetypes Calculated');

AA_Figure_Rearrage;

disp('Figures completed');