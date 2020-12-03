%% Part 3 - Task 3 - Bonus (part3task3_bonus.m)
%% Initialize cost function dataset
% Load distances matrix of the dataset of task 1
load("./data/distancesTask1.mat",'D','N');

%% Solve optimization problem for k = 2,3
for k = 4:10 % target space dimension
    % Set up parameters
    maxIt = 200*k; % maximum number of iterations
    lambda0 = 1; % initial value for lambda of the LM method
    epsl = k*1e-2; % stopping criterion
    % set up data for the compuattion of the quatities related to the 
    % objective function in objectiveF(y)
    save("./data/objectiveFData.mat",'D','N','k'); 
    y0 = 200*2*(rand()-0.5)*2*(rand(N*k,1)-0.5); % initialization of LM
    clear objectiveF; % clear persistent variables in objectiveF
    fprintf("--------------------- Task 3 - bonus ---------------------\n");
    tic; % start counting LM time
    % run LM method
    [solLM,itLM,costLM,normGradLM] =...
        LMAlgorithm(lambda0,y0,epsl,maxIt);
    elapsedTimeLM = toc; % save elapsed time
    if ~isnan(solLM) % if a solution was found
        fprintf("Solution found for dataset of task 1 with k = %d "+...
            "using LM algorithm.\n",k);
        fprintf("- Objective function value: %g.\n",costLM(end,1));
        fprintf("- Elapsed time: %g s.\n", elapsedTimeLM);
    else % if a solution was not found
        fprintf("Solution could not be found for dataset of task 1 "+...
            "with k = %d using\n LM algorithm with the provided "+...
            "stopping criterion and maximum number of iterations.\n",k);
    end
    % Save solutions
    save(sprintf("./data/solTask3_2_k%d.mat",k),...
    'solLM','itLM','elapsedTimeLM','costLM','normGradLM');
end

%% Plot results
for k = 0:-1
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