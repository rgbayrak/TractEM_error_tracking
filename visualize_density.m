clc 
clear all
path_to_old = '/nfs/masi/bayrakrg/tractem_data/corrected';
path_to_new = '/nfs/masi/wangx41/auto_tracked_from_corrected_regions';
path_to_t1 = '/share4/bayrakrg/tractEM/postprocessing/tal_T1';

project = {'HCP', 'BLSA', 'BLSA18'};
t1_project = {'HCP', 'BLSA', 'BLSA'};

for p = 1:length(project)
    
    old = dir([path_to_old filesep project{p}]);
    new = dir([path_to_new filesep project{p}]);
    t1 = dir([path_to_t1 filesep t1_project{p}]);
    for j=3:length(old)
        ff = dir([old(j).folder filesep old(j).name]);
        for jj = 1:length(ff)
            % exclude folders       
            ff = ff(~ismember({ff.name},{'.','..'}));
            
            tractfolders = cellstr(char(ff.name));
            dropfolders = false(length(ff),1);
            dropfolders(~contains(tractfolders, {'.', '..', '_fib.gz'})) = true; 
            ff = ff(dropfolders);
            
            density_dir = dir([ff(jj).folder filesep ff(jj).name]);
            
            for f = 3:length(density_dir)
                if contains(density_dir(f).name, 'density.nii.gz')
                    q = load_nii(fullfile(density_dir(f).folder, density_dir(f).name));
                    parts = strsplit(density_dir(f).folder, '/');
                    id_rater = parts{end-1};
                    tract = parts{end};
                    
                    q2 = load_nii(fullfile(path_to_new, project{p}, id_rater, tract, density_dir(f).name));
    
                    id_parts = strsplit(id_rater, '_');
                    id = id_parts{1};
                    t1_dir = dir(fullfile(path_to_t1, project{p}, [id '*.nii']));
                    t1 = load_nii(fullfile(t1_dir.folder, t1_dir.name)); 
                    
                    figure(1)
                    z = sum(sum(q.img,1),2);
                    sl = find(z==max(z));
                    rgb = repmat(t1.img(:,:,sl(1)),[1 1 3])/max(max(t1.img(:,:,sl(1))))*.75;
                    overlay = sum(double(q.img(:,:,:)),3);
                    rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
                    rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
                    imagesc(rgb)
                    h = title(['old ' ff(jj).name]);
                    set(h,'Interpreter','none')
                    
                    figure(4)
                    z = sum(sum(q2.img,1),2);
                    sl = find(z==max(z));
                    rgb = repmat(t1.img(:,:,sl(1)),[1 1 3])/max(max(t1.img(:,:,sl(1))))*.75;
                    overlay = sum(double(q2.img(:,:,:)),3);
                    rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
                    rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
                    imagesc(rgb)
                    h = title(['new ' ff(jj).name]);
                    set(h,'Interpreter','none')
                    
                    pause
                    close all
                    
                    figure(2)
                    z = sum(sum(q.img,1),3);
                    sl = find(z==max(z));
                    rgb = repmat(squeeze(t1.img(:,sl(1),:)),[1 1 3])/max(max(t1.img(:,sl(1),:)))*.75;
                    overlay = squeeze(sum(double(q.img(:,:,:)),2));
                    rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
                    rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
                    imagesc(imrotate(rgb,90))
                    axis equal
                    h = title(['old ' ff(jj).name]);
                    set(h,'Interpreter','none')
                    
                    figure(5)
                    z = sum(sum(q2.img,1),3);
                    sl = find(z==max(z));
                    rgb = repmat(squeeze(t1.img(:,sl(1),:)),[1 1 3])/max(max(t1.img(:,sl(1),:)))*.75;
                    overlay = squeeze(sum(double(q2.img(:,:,:)),2));
                    rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
                    rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
                    imagesc(imrotate(rgb,90))
                    axis equal
                    h = title(['new ' ff(jj).name]);
                    set(h,'Interpreter','none')
                    
                    pause
                    close all

                    figure(3)
                    z = sum(sum(q2.img,2),3);
                    sl = find(z==max(z));
                    rgb = repmat(squeeze(t1.img(sl(1),:,:)),[1 1 3])/max(max(t1.img(sl(1),:,:)))*.75;
                    overlay = squeeze(sum(double(q2.img(:,:,:)),1));
                    rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
                    rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
                    imagesc(imrotate(rgb,90))
                    h = title(['old ' ff(jj).name]);
                    set(h,'Interpreter','none')
                    
                    figure(6)
                    z = sum(sum(q.img,2),3);
                    sl = find(z==max(z));
                    rgb = repmat(squeeze(t1.img(sl(1),:,:)),[1 1 3])/max(max(t1.img(sl(1),:,:)))*.75;
                    overlay = squeeze(sum(double(q.img(:,:,:)),1));
                    rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
                    rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
                    imagesc(imrotate(rgb,90))
                    h = title(['new ' ff(jj).name]);
                    set(h,'Interpreter','none')
                    
                    pause
                    close all
                    
                end
            end
       end
    end
end