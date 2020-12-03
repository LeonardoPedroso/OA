%% Task 4
clear;
clear objectiveF;

%% Set parameters
RUN = 1;
computedD = true;

NRuns = 1;
NIts = 12*2;
%% Load or compute data
if ~computedD
    X = csvread("./data/dataProj.csv");
    N = size(X,1);
    D = zeros(N);
    for m = 1:N
        for n = m+1:N
           D(m,n) = norm(X(m,:)-X(n,:),2);
           D(n,m) = D(m,n);
        end
    end
    % Save data
    save("./data/distancesTask4.mat",'D','N');
else
    load("./data/distancesTask4.mat",'D','N');
end


%% Run various iteration for randomly initializations

k = 2;
lambda0 = 1;
maxIt = 200;
epsl = k*1e-4;

solLM = cell(NIts,1);
itLM = zeros(NIts,1);
elapsedTimeLM = zeros(NIts,1);
costLM = cell(NIts,1);
normGradLM = cell(NIts,1);
fprintf("----------------------- Task 4 -----------------------\n");
for it = 1:NIts
    y0 = 200*2*(rand()-0.5)*2*(rand(N*k,1)-0.5);
    tic;
    
    fprintf("---------------- RUN 02%d - Attempt %02d ----------------\n",RUN,it);
    [solLM{it,1},itLM(it,1),costLM{it,1},normGradLM{it,1}] =...
        LMAlgorithm(k,lambda0,y0,epsl,maxIt);
    elapsedTimeLM(it,1) = toc;
    clear objectiveF;
    if ~isnan(solLM{it,1})
        fprintf("Solution found for dataset of task 4 with k = %d using LM algorithm.\n",k);
        fprintf("- Objective function value: %f.\n",costLM{it,1}(end,1));
        fprintf("- Elapsed time: %g.\n", elapsedTimeLM(it,1));
    else
        fprintf("Solution could not be found for dataset of task 1 with "+...
            "k = %d using\n LM algorithm with the provided stoppin criterion"+...
            " and maximum number of iterations.\n",k);
    end
    
end

% Save whole run
save(sprintf("./data/RunsTask4/solRUN%02d.mat",RUN),...
    'solLM','itLM','elapsedTimeLM','costLM','normGradLM');

%% Sort runs
