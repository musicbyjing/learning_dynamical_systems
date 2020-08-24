% Author: Jing Liu
% Supervisor: Prof. Hsiu-Chin Lin, Summer 2020
% Affiliation: McGill University

% This function prints errors for mvr

function [] = get_mvr_results()

file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'graph_data.mat');
load(file, 'graph_data');

%%%%%%%%%%%%% CHECK CORRECT ROWS! %%%%%%%%%%%%%%%%%%
rmse_test = graph_data(3,:);
edot_test = graph_data(4,:);

fprintf('RMSE: %.4f ± %.4f\n', mean(rmse_test), std(rmse_test));
fprintf('Edot: %.4f ± %.4f\n', mean(edot_test), std(edot_test));

end