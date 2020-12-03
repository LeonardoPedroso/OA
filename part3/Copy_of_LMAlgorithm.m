function [xk,k,costF,normGk] = LMAlgorithm(dimTargetSpace,lambda0,x0,epsl,maxIt)
    % Inputs: 1. dimTargetSpace: target space dimension (k)
    %         2. lambda0: initialization lambda of the LM algorithm
    %         3. hessF: hesssian of the objective function (as a function 
    %         handle)
    %         4. x0: initialization estimate
    %         5. epsl: stopping criterion
    %         6. maxIt: maximum number of iterations
    % Outputs: 1. x: output of the gradient descent method (returns NaN if
    %          stopping criterion not met after the maximum number of 
    %          iterations chosen
    %          2. k: number of iterations required for convergence if a
    %          solution was found
    %          3. costF: cost of the objective function
    %          4. normGk: norm of the gradient of the objective function
    %% LM algorithm 
    % Init variables
    costF = zeros(maxIt,1);
    normGk = zeros(maxIt,1);
    % Init algorithm
    k = 0;
    xk = x0;
    xprev = NaN;
    lambdak = lambda0;
    needToComputeAb = true;
    fprintf("Running LM.\n");
    % ---------  LM algorithm  ---------
    % ---------  compute initial objective function and gradients  ---------
    [costF0,normGk0,~,~] = objectiveF(xk,dimTargetSpace,0);
    while k < maxIt
        % ---------  check stopping criterion  ---------
        if k && normGk(k) < epsl % Stopping criterion
           break; 
        end
        % ---------  solve least squares  ---------
        if needToComputeAb
            [~,~,A,b] = objectiveF(xk,dimTargetSpace,1);
        else
            needToComputeAb = true;
        end
        A(end-size(x0,1)+1:end,:) = sqrt(lambdak)*eye(size(x0,1));
        b(end-size(x0,1)+1:end,1) = sqrt(lambdak)*xk;
        xprev = xk;
        xk = ((A'*A)\A')*b;
   
        % ---------  compute objective function and gradients  ---------
        [costF(k+1),normGk(k+1),~,~] = objectiveF(xk,dimTargetSpace,0);
        
        %  ---------  check validity step  ---------
        if k 
            costCmp =  costF(k);
            normGkCmp = normGk(k);
        else
            costCmp =  costF0;
            normGkCmp = normGk0;
        end
        if costF(k+1)<costCmp
            lambdak = 0.7*lambdak;
        else
            xk = xprev;
            normGk(k+1) = normGkCmp;
            costF(k+1) = costCmp;
            lambdak = 2*lambdak;
            needToComputeAb = false;
        end    
        %  ---------  Increment iteration count  ---------
        fprintf("Iteration: %d | cost = %g.\n",k,costF(k+1));
        k = k+1;                 
    end   
    if k == maxIt
        % No solution found within the maximum number of iterations
        xk = NaN;
    else
        costF = costF(1:k);
        normGk = normGk(1:k);
    end
    clear objectiveF; % clear persistent variables
end
