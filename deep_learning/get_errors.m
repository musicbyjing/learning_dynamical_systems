function [rmse, edot] = get_errors(X, Y, A) 

Y_pred = (X'*A)';

rmse_vec = sqrt(mean((Y' - Y_pred').^2, 2))';
rmse = mean(rmse_vec);

[D, N] = size(Y_pred);
trajectory_edot = zeros(1,N);

disp(size(Y_pred))
disp(size(Y))

for i=1:N
    trajectory_edot(1,i) = abs(1 - Y_pred(:,i)'*Y(:,i) / (norm(Y_pred(:,i))*norm(Y(:,i))));
    if isnan(trajectory_edot(1,i))
        trajectory_edot(1,i) = 0;
    end
end
edot = mean(trajectory_edot);

end
