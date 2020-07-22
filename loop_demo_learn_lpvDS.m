% MAKE SURE TO COMMENT STEP 0 OPTION 1 IN demo_learn_lpvDS_mod WHEN RUNNING
% THIS FILE

delete(fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'graph_data.mat'));

% Parameters to be set
n = 8;
select_area = 1;
% prop_to_delete assigned below
store_params = 1;

props = 0:0.05:0.99;

for j = 1:length(props)
    prop_to_delete = props(j);
    run("demo_learn_lpvDS_mod.m")
end