% Author: Jing Liu
% Supervisor: Prof. Hsiu-Chin Lin, Summer 2020
% Affiliation: McGill University

function [h,xd] = plot_ds_model_mod(method, A, Y_pred, fig, target, limits, varargin)

quality='medium';

if nargin > 4
    quality = varargin{1};
end

if strcmpi(quality,'high')
    nx=400;
    ny=400;
elseif strcmpi(quality,'medium')
    nx=200;
    ny=200;
else
    nx=50;
    ny=50;
end

axlim = limits;
ax_x=linspace(axlim(1),axlim(2),nx); % computing the mesh points along each axis
ax_y=linspace(axlim(3),axlim(4),ny); % computing the mesh points along each axis

[x_tmp, y_tmp]=meshgrid(ax_x,ax_y);  % meshing the input domain
x=[x_tmp(:), y_tmp(:)]'; % 200 x 200

% x_ is the shifted grid such that the target (in this case (0,0)) will
% still be in the bottom left corner
x_ = x - repmat(target,1,size(x,2)); % 2 x 40000; 

% xd = feval(ds, x_); % Original, for LPV-DS

if strcmpi(method,'mvr')
    xd = (x_.' * A).'; % Y_pred, 40000 x 2
elseif strcmpi(method,'dl')
    xd = Y_pred;
end

h = streamslice(x_tmp,y_tmp,reshape(xd(1,:),ny,nx),reshape(xd(2,:),ny,nx),4,'method','cubic');
set(h,'LineWidth', 0.75)
set(h,'color',[0.0667  0.0667 0.0667]);
end