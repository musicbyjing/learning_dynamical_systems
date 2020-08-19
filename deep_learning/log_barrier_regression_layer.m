% Author: Jing Liu
% Supervisor: Prof. Hsiu-Chin Lin, Summer 2020
% Affiliation: McGill University

% Reference: https://www.mathworks.com/help/deeplearning/ug/define-custom-regression-output-layer.html

classdef log_barrier_regression_layer < nnet.layer.RegressionLayer
        
    properties
        X
        target
    end
    
    methods
        function layer = log_barrier_regression_layer(X, target)
            layer.X = X;
            layer.target = target; % the target point of the trajectory
        end

        function loss = forwardLoss(layer, Y, T)
            % Return the loss between the predictions Y and the training
            % targets T.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         loss  - Loss between Y and T
            
            X = dlarray(layer.X);
            target = dlarray(layer.target);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % When testing with the command window. Initialize:
%             X = rand(2, 229);
%             target = zeros(2, 229);
%             Y = rand(2,1,229);
%             T = rand(2,1,229);
%               R = size(Y, 1); 
%             S = size(Y, 3);

            % In example 8: 
            % X and target have dims 2 x 229
            % Y and T have size 2 x 1 x 229;
            %       this is R x N x S, where R is the number of responses, 
            %       N is the number of observations, and S is the sequence length
            % 

            
            % Y has size 2 x 1 x 229
R = size(Y, 1); % 2
S = size(Y, 3); % 229
part1 = sum(abs(Y-T).^2, 3) / S; % size 2 x 1
part1 = sum(part1, 1) / R; % size 1 x 1

% 2.*Y.*(X-target)+1 has size 2 x 229 x 229                     
part2 = sum((2.*Y.*(X-target)+1), 3) / S; % size 2 x 229
sum(part2, 2); % also check abs
part2 = log(abs(part2));
part2 = sum(part2, 2) / S; % size 2 x 1
part2 = sum(part2, 1) / R; % size 1 x 1

loss = part1 - part2;
loss = [loss 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_points = size(Y,3) ; 
for n = 1:num_points 
    y_n(1) = Y(1,1,n) ; 
    y_n(2) = Y(2,1,n); 
    x_n = X(:,n)
end

part2 = sum (( 2.* y_n' * ( x-target) + 1)) 
part2 = sum (( 2.* y_n' * ( x-target))) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            
%             R = size(Y, 1);
%             N = size(Y, 2);
%             S = size(Y, 3);
%             part1 = sum(abs(Y-T).^2, 3); % size 2 x 1
%             part1 = sum(part1, 1); % size 1 x 1
%           
%             disp("fine")
%             
%             Y = permute(Y,[1,3,2]); % 2 x 229 x 1
%             
%             disp(size(Y));
%             disp(size(X-target))
%             for s = 1:N
%                 Z(:,:,s) = Y(:,:,s) .* (X-target);
%             end
%             
%             
%             disp("fine2")
%             
%             part2 = 2*Z+1; % 
%                        
%             part2 = log(abs(part2));
%             part2 = sum(part2, 2);
%             part2 = sum(part2, 1);
% %             part2 = sum(part2, 2); % size 1 x 1
% 
%             loss = (part1 - part2) / S;
%             
%             disp("fine3")
           
        end
        
%         function dLdY = backwardLoss(layer, Y, T)
            % (Optional) Backward propagate the derivative of the loss 
            % function.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         dLdY  - Derivative of the loss with respect to the 
            %                 predictions Y        

            % Layer backward loss function goes here.
%         end
    end
end

