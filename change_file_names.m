clc
clear all

path_to_new = '/nfs/masi/wangx41/auto_tracked_from_corrected_regions';

project = {'HCP', 'BLSA', 'BLSA18'};

for p = 1:length(project)
    
    project_dir = dir(fullfile(path_to_new, project{p}, '*/*/*.nii.gz'));
    
    for pd = 1:length(project_dir)
        file = fullfile(project_dir(pd).folder, project_dir(pd).name);
        file_parts = strsplit(project_dir(pd).name, '_');
        if length(file_parts) == 3
            new_parts = [file_parts{1} '_' file_parts{2}];
            system([ 'cp ' file ' ' [project_dir(pd).folder '/' new_parts '_density.nii.gz']]);
            
        elseif length(file_parts) == 2
            new_parts = file_parts{1};
            system([ 'cp ' file ' ' [project_dir(pd).folder '/' new_parts '_density.nii.gz']]);
            
        end       
    end
end