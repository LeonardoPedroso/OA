%% Part 3 - Task 3 (part3task3.m)
%% Initialize cost function dataset
% Load distances matrix of the dataset of task 1
load("./data/distancesTask1.mat",'D','N');
% Initialize variables to hold the solution and status parameters of the LM
% algorithm for K = 2,3
solLM = cell(2,1); % solution of the optimization problem
itLM = zeros(2,1); % number of iterations ran
elapsedTimeLM = zeros(2,1); % time elapsed running LM
costLM = cell(2,1); % vector of cost function values for each iteration
% vector of gradient norm of the cost function for each iteration
normGradLM = cell(2,1);

%% Solve optimization problem for k = 2,3
for k = 2:3 % target space dimension
    % Set up parameters
    maxIt = 200; % maximum number of iterations
    lambda0 = 1; % initial value for lambda of the LM method
    epsl = k*1e-2; % stopping criterion
    % set up data for the compuattion of the quatities related to the 
    % objective function in objectiveF(y)
    save("./data/objectiveFData.mat",'D','N','k'); 
    y0 = csvread(sprintf("./data/yinit%d.csv",k)); % initialization of LM
    clear objectiveF; % clear persistent variables in objectiveF
    fprintf("------------------------ Task 3 ------------------------\n");
    tic; % start counting LM time
    % run LM method
    [solLM{k-1,1},itLM(k-1,1),costLM{k-1,1},normGradLM{k-1,1}] =...
        LMAlgorithm(lambda0,y0,epsl,maxIt);
    elapsedTimeLM(k-1,1) = toc; % save elapsed time
    if ~isnan(solLM{k-1,1}) % if a solution was found
        fprintf("Solution found for dataset of task 1 with k = %d "+...
            "using LM algorithm.\n",k);
        fprintf("- Objective function value: %g.\n",costLM{k-1,1}(end,1));
        fprintf("- Elapsed time: %g s.\n", elapsedTimeLM(k-1,1));
    else % if a solution was not found
        fprintf("Solution could not be found for dataset of task 1 "+...
            "with k = %d using\n LM algorithm with the provided "+...
            "stopping criterion and maximum number of iterations.\n",k);
    end
end
% Save solutions
save("./data/solTask3.mat",...
    'solLM','itLM','elapsedTimeLM','costLM','normGradLM');
%% Plot results
for k = 2:3
    figure('units','normalized','outerposition',[0 0 1 1]);
    yyaxis left
    plot(0:itLM(k-1,1)-1,costLM{k-1,1},'LineWidth',3);
    hold on;
    ylabel('$f(y)$','Interpreter','latex');
    set(gca, 'YScale', 'log');
    yyaxis right
    plot(0:itLM(k-1,1)-1,normGradLM{k-1,1},'LineWidth',3);
    ylabel('$||\nabla f (y)||$','Interpreter','latex');
    set(gca,'FontSize',35);
    ax = gca;
    ax.XGrid = 'on';
    ax.YGrid = 'on'; 
    title(sprintf("LM algorithm | Dataset task 1 | k = %d",k));
    set(gca, 'YScale', 'log');
    xlabel('$k$','Interpreter','latex');
    saveas(gcf,sprintf("./data/task3_LM_k_%d.fig",k));
    hold off;
    y = reshape(solLM{k-1},[k,N]);
    figure('units','normalized','outerposition',[0 0 1 1]);
    if k == 2
        scatter(y(1,:),y(2,:),100,'o','b','LineWidth',1,...
            'MarkerFaceColor','flat');
    else
        scatter3(y(1,:),y(2,:),y(3,:),100,'o','b','LineWidth',1,...
            'MarkerFaceColor','flat'); 
    end
    hold on;
    set(gca,'FontSize',35);
    ax = gca;
    ax.XGrid = 'on';
    ax.YGrid = 'on'; 
    title(sprintf("LM algorithm | Dataset task 1 | k = %d",k));
    saveas(gcf,sprintf("./data/task3_lowerDim_k_%d.fig",k));
    hold off;
end