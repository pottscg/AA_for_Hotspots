    addpath('PCHA');

    U=1:size(imageData,2); % Entries in X used that is modelled by the AA model
    I=1:size(imageData,2); % Entries in X used to define archetypes
    % if two expensive to useall entries for I find N relevant observations by
    % the following procedure:
    % N=100;
    % I=FurthestSum(X,N,ceil(rand*size(X,2)));

    delta=0;
    opts.maxiter=1000;
    opts.conv_crit=1e-7;

    tic
    % Use PCHA.m
    [XC,S,C,SSE,varexpl]=PCHA(imageData,noc,I,U,delta,opts);

    toc

    save(strcat('DATASETS/',filename,'_', num2str(noc), 'AA.mat'),'m','n', 'XC', 'S', 'C', 'SSE', 'varexpl');
