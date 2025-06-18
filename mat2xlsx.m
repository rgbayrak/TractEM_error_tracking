data = load('BLSA18_above0_below40.mat');
writetable(struct2table(data.list_of_low), 'BLSA18_above0_below40.xlsx')

