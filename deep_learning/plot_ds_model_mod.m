function [h,xd] = plot_ds_model_mod(A, X_test, Y_test, fig, target, limits, varargin)

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
x=[x_tmp(:), y_tmp(:)]'; % 2 x 40000

% x_ is the shifted grid such that the target (in this case (0,0)) will
% still be in the bottom left corner
x_ = x - repmat(target,1,size(x,2)); % 2 x 40000; 

% vel_size = 0.5;
% vel_points = [X_test; Y_test];
% U = zeros(size(vel_points,2),1);
% V = zeros(size(vel_points,2),1);
% for i = 1:size(vel_points, 2)
%     dir_    = vel_points(3:end,i)/norm(vel_points(3:end,i));
%     U(i,1)   = dir_(1);
%     V(i,1)   = dir_(2);
% end
% h_vel = quiver(vel_points(1,:)', vel_points(2,:)', U, V, vel_size, 'Color', 'k', 'LineWidth',2); hold on;
% 
% startx = 0.1:0.1:1;
% starty = ones(size(startx));
% 
% 
% vec = 1+0.1*(0:size(X_test, 2)-1);
% [x,y] = meshgrid(vec,vec);
% 
% disp(size(x)) % 63 x 63
% 
% 
% u = [vel_points(1,:)', vel_points(2,:)']'; % 2 x 63
% v = [U, V]'; % 2 x 63
% 
% disp(size(u))
% disp(size(v))
% 
% 
% streamline(x,y,u,v,startx,starty)
% 

% xd = feval(ds, x_); % Original, for LPV-DS
xd = (x_.' * A).'; % Y_pred, 40000 x 2

% xd = Y_test'; % 63 x 2

bob = reshape(xd(1,:),ny,nx)
disp(size(x_tmp))
return;

h = streamslice(x_tmp,y_tmp,reshape(xd(1,:),ny,nx),reshape(xd(2,:),ny,nx),4,'method','cubic');
set(h,'LineWidth', 0.75)
set(h,'color',[0.0667  0.0667 0.0667]);
end