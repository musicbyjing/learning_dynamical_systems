% Author: Jing Liu
% Supervisor: Prof. Hsiu-Chin Lin, Summer 2020
% Affiliation: McGill University

% This function plots errors as a function of dataset size

function [] = get_transfer_results()

file = fullfile(pwd, 'learning_dynamical_systems', 'data_files', 'graph_data.mat');
load(file, 'graph_data');

rmse_test = graph_data(3,:);
edot_test = graph_data(4,:);
mean_dtwd_test = graph_data(5,:);
std_dtwd_test = graph_data(6,:);
time = graph_data(11,:);
k = graph_data(12,:);

fprintf('RMSE: %.4f ± %.4f\n', mean(rmse_test), std(rmse_test));
fprintf('Edot: %.4f ± %.4f\n', mean(edot_test), std(edot_test));
fprintf('DTWD: %.4f ± %.4f\n', mean(mean_dtwd_test), mean(std_dtwd_test));
fprintf('Time: %.4f ± %.4f\n', mean(time), std(time));
fprintf('k: %.4f ± %.4f\n', mean(k), std(k));

end