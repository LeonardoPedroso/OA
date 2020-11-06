function [xk,k,normGk] = gradientDescent(F,gradF,x0,epsl,...
    alpha_hat,gamma,beta,maxIt)
    %% Description
    % Inputs: 1. F: objective function (as a function handle)
    %         2. gradF: gradient of teh objective function (as a function 
    %         handle)
    %         3. x0: initialization
    %         4. epsl: stopping criterion
    %         5. alpha_hat: initialization of alpha_k for the backtracking
    %         routine
    %         6. gamma: gamma of backtraking routine
    %         7. beta: beta of backtraking routine
    %         8. maxIt: maximum number of iterations
    % Outputs: 1. x: output of the gradient descent method (returns NaN if
    %          stopping criterion not met after the maximum number of 
    %          iterations chosen
    %          2. k: number of iterations required for convergence if a
    %          solution was found
    %          3. normGk: norm of the gradient of the objective function
    %% Gradient descent routine 
    k = 0;
    xk = x0;
    normGk = zeros(maxIt,1);
    while k < maxIt
        gk = gradF(xk); % Compute gradient at xk
        normGk(k+1) = norm(gk);
        if normGk(k+1) < epsl % Stopping criterion
           break; 
        end
        % ---------  backtracking routine  ---------
        alpha_k = alpha_hat;
        % It is guaranteed that there is convergence, no maximum number of 
        % iterations needed (obviously for beta < 0)
        while true 
            % check if F(alpha_k) < phi(0)+gamma*phi_dot(0)+alpha_k 
            if F(xk-alpha_k*gk) < F(xk)-gamma*alpha_k*(gk'*gk) 
                break; % alpha_k found
            else
                alpha_k = beta*alpha_k; % Update alpha_k
            end
        end
        xk = xk - alpha_k*gk; % update xk
        % -------  End backtracking routine  -------
        k = k + 1; % Increment iteration count
    end   
    if k == maxIt
        % No solution found within the maximum number of iterations
        xk = NaN;
    else
        normGk = normGk(1:k+1);
    end
end
