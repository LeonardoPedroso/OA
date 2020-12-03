function [xk,k,costF,normGk] = LMAlgorithm(lambda0,x0,epsl,maxIt)
%% LMAlgorithm.m
% Input: lambda0: initialization lambda of the LM algorithm
%         x0: initialization solution estimate
%         epsl: stopping criterion
%         maxIt: maximum number of iterations
% Output: xk: output of the gradient descent method (returns NaN if
%         stopping criterion not met after the maximum number of 
%         iterations chosen
%         k: number of iterations required for convergence if a
%         solution was found
%         costF: vector of objective function value for each iteration 
%         normGk: vector of the norm of the gradient of the objective 
%         function for each iteration 
%% LM algorithm 
% Initialize variables
costF = zeros(maxIt,1); % vector of objective function value 
normGk = zeros(maxIt,1); % vector of gradient norms of the objective f 
% Initialize LM algorithm
k = 0; % Initialize iteration count
xk = x0; % Initialization solution estimate
lambdak = lambda0; % Initialization lambda
fprintf("Running LM.\n");
% ---------------------------  LM algorithm  ---------------------------
while k < maxIt % iterate up to a limit of maxIt iterations
    % -----------  Compute objective function and gradients  -----------
    if k % store previous A and b, which are used if the step is invalid
        Aprev = A;
        bprev = b;          
    end
    % Compute objective f value, norm of the gradient, A and b for xk
    % note that only the entries of A and b that do not depend on lambda 
    % are computed
    [costF(k+1),normGk(k+1),A,b] = objectiveF(xk);
    % ------------------  check stopping criterion  --------------------
    if normGk(k+1) < epsl % Stopping criterion´
            break; 
    end
    %  ----------------  Check validity of last step  ------------------
    if k && costF(k+1)<costF(k) % if step is valid
        lambdak = 0.7*lambdak; % decrease lambda
    elseif k % if step is invalid
        xk = xprev; % redo step
        A = Aprev;
        b = bprev;
        normGk(k+1) = normGk(k);
        costF(k+1) = costF(k);
        lambdak = 2*lambdak; % decrease lambda
    end
    % ------------  New step (solve least squares problem)  ------------
    % store previous estimate, which is used if the step is invalid
    xprev = xk; 
    % Entries of A and b that depend on lambda must be computed
    A(end-size(x0,1)+1:end,:) = sqrt(lambdak)*eye(size(x0,1));
    b(end-size(x0,1)+1:end,1) = sqrt(lambdak)*xk;
    xk = ((A'*A)\A')*b; % solve least squares problem Ax=b

    % ------------------  Increment iteration count  -------------------
    % Display LM status
    if k fprintf("Iteration: %d | cost = %g.\n",k,costF(k+1)); end
    k = k+1; % increment iteration count            
end   
if k == maxIt
    % No solution found within the maximum number of iterations
    xk = NaN; % Output invalid estimate
else
    % Output only relevant data
    costF = costF(2:k+1);
    normGk = normGk(2:k+1);
end
end