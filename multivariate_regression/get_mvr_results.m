% Author: Jing Liu
% Supervisor: Prof. Hsiu-Chin Lin, Summer 2020
% Affiliation: McGill University

% This function prints errors for mvr

function [] = get_mvr_results()

file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'graph_data.mat');
load(file, 'graph_data');

%%% Make sure these are the correct rows in graph_data (may vary depending
%%% on which script wrote to graph_data)
rmse_test = graph_data(2,:);
edot_test = graph_data(3,:);

fprintf('RMSE: %.4f ± %.4f\n', mean(rmse_test), std(rmse_test));
fprintf('Edot: %.4f ± %.4f\n', mean(edot_test), std(edot_test));

end