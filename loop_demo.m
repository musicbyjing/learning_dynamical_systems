% Author: Jing Liu
% Supervisor: Prof. Hsiu-Chin Lin, Summer 2020
% Affiliation: McGill University

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMMENT OUT STEP 0 OPTION 1 IN THE MAIN SCRIPT WHEN RUNNING THIS FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delete(fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'graph_data.mat'));

% Parameters to be set
script = "demo_learn_lpvDS_mod.m";
model_number = 5;
select_area = 0;
% prop_to_delete assigned below
learn_from_prev = 1;

test_set_prop = 0.2;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To run with varying dataset sizes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% props = 0:0.05:0.95;
% for j = 1:length(props)
%     prop_to_delete = props(j);
%     run(script)
% end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To run with a fixed dataset size %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prop_to_delete = 0;
for j = 1:10
    run(script)
end