function output = tract_dice(exdensDir, newdensDir, threshold)

    ex_density = load_density(exdensDir);    
    new_density = load_density(newdensDir);            
    
    El = length(exdensDir);
    Nl = length(newdensDir);
    
    ex_density = normalize(ex_density, El);
    new_density = normalize(new_density, Nl);

    % Binarize
    ex_density(ex_density <= threshold) = 0;
    ex_density(ex_density > threshold) = 1;  
    
    new_density(new_density <= threshold) = 0;
    new_density(new_density > threshold) = 1;  
    
    % Dice calculation
    init = 0;
    diceMatrix = [];
    nameMe = [];
    second_name = [];
    
    for i = 1:El
    % Getting the names of compared files
    partsi = strsplit(exdensDir(i).folder, '/');
    dirParti = partsi{end-1};
    
        for j = 1:Nl
            
            partsj = strsplit(newdensDir(j).folder, '/');
            dirPartj = partsj{end-1};
            
            % Initialization
            if ~init
                diceMatrix = zeros([El 1]);
                init = 1;
            end
                
            if strcmp(dirParti, dirPartj) == 1
            
                im1 = ex_density(:,:,:,i);
                im2 = new_density(:,:,:,j); 
                dice_score = dice_func(im1, im2);

                % Converting it into a symmetric matrix form
                diceMatrix(i) = dice_score;
                nameMe = [nameMe convertCharsToStrings([dirParti ' ,' dirPartj])]; % getting the subject names 
            end  
        end
        second_name = [second_name convertCharsToStrings(dirParti)];
    end
    output = [second_name' diceMatrix];
end