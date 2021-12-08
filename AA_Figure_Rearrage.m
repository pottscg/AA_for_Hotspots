% --- AA_Figure
% creates two figures for a processed archetype dataset. 
% Figure 1 - first 9 archetypes reshaped and displayed in image
% Figure 2 - heat map of alpha's indicating which frame gets what weight
%          in reconstruction

% filepath = "FIGURES/SKETCHES/1_23_Day7_12_originalpreprocessing_8_3424_9AA_rearranged";

means = mean(S');
indices = zeros(1,9);
for i = 1:9
   binary = find(S(i,:) > means(i));
   indices(i) = floor(mean(binary));
end
rearrange = zeros(1,9);

sorted_indices = sort(indices);
for i = 1:9
    place = find(indices == sorted_indices(i));
    if (size(place) == 1)
        rearrange(i) = place;
    else
        rearrange(i) = place(1);
    end
end
XC = XC(:,rearrange);
S = S(rearrange,:);

filepath = strcat('FIGURES/HOTSPOTS_Z/',filename);

    figure;
    for k = 1:9
        subplot(3,3,k);
        imagesc(reshape(full(XC(:,k)), m,n));
        axis off;
        title(['Archetype ' num2str(k)]);
    end
    
    saveas(gcf,strcat(filepath,'_ARCHETYPES_9AA'),'epsc');
    close;
    
    figure;
    imagesc(S/max(S(:)));
    colorbar;
    axis off; 
%     ylabel('Archetype'); xlabel('Frame (time)'); title('Reconstruction weights');
    saveas(gcf,strcat(filepath,'_RECONSTRUCTION_WEIGHTS_9AA'),'epsc');
    close;
     
    for k = 1:9
%         image = reshape(full(XC(:,k)),m,n);
        % for archetype figures
        image = reshape(full(XC(:,k)),m,n);
%         image(1:26,n-25:n) = max(max(image));
%         image(250:255, 200:325) = max(max(image));
%         
        figure; imagesc(image);

        axis off;
        
        saveas(gcf,strcat(filepath,'_9AA_ARCHETYPE_',num2str(k)),'epsc');
        close;
        
%        
    end

    