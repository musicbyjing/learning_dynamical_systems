function [Data, Data_sh, att, x0_all, data, dt] = load_LASA_dataset_DS_mod(n, names, sub_sample, nb_trajectories)
% This is a matlab function illustrating 30 human handwriting motions
% recorded from Tablet-PC. These datas can be found in the folder
% 'DataSet'.
%
% Please acknowledge the authors in any academic publications
% that have made use of this library by citing the following paper:
%
%  S. M. Khansari-Zadeh and A. Billard, "Learning Stable Non-Linear Dynamical
%  Systems with Gaussian Mixture Models", IEEE Transaction on Robotics, 2011.
%
% To get latest upadate of the software please visit
%                          http://lasa.epfl.ch/khansari
%
% Please send your feedbacks or questions to:
%                           mohammad.khansari_at_epfl.ch
%
%% Modified by NADIA FIGUEROA. Sept 2018.

D = load(['DataSet/' names{n}],'demos','dt');
dt = D.dt;
demos = D.demos;
N = length(demos);
att = [0 0]';
Data = []; x0_all = [];
trajectories = randsample(N, nb_trajectories)';
for l=1:nb_trajectories
    % Check where demos end and shift
    id_traj = trajectories(l);
    data{l} = [demos{id_traj}.pos(:,1:sub_sample:end); demos{id_traj}.vel(:,1:sub_sample:end)];
    Data = [Data data{l}];
    x0_all = [x0_all data{l}(1:2,20)];
end
Data_sh = Data;

end