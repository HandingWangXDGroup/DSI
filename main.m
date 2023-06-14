


clc;
warning off;
clear;

for pro = 2006 % [Problem: 2006,2010,2017,20103,20173]
    D = 10; % default
    if pro == 2006
        problem = 2006;
        Parameters.fbias = [-15,-0.8036191042559,-30665.538671783332,-6961.81387558015,24.30620906818,-0.0958250414180359,680.630057374402,7049.24802052867,-1.0000000000,-1.90515525853479, -0.866025403784439,32.6555929502463,-5.50801327159536];
        Parameters.D = [];
        problems = 13;
    elseif pro == 2010   % 10 D
        problem = 2010;
        Parameters.fbias = zeros(1,6);
        Parameters.D = 10;
        problems = 6;
    elseif pro ==2017 % 10 D
        problem = 2017;
        Parameters.fbias = zeros(1,9);
        Parameters.D = 10;
        problems = 9;
    elseif pro ==20103 % 30 D
        problem = 2010;
        Parameters.fbias = zeros(1,6);
        Parameters.D = 30;
        problems = 6;
    elseif pro ==20173 % 30 D
        problem = 2017;
        Parameters.fbias = zeros(1,9);
        Parameters.D = 30;
        problems = 9;
    end

    runtimes = 30;  
    Parameters.maxFes = 300;
    Parameters.popsize = 30;
    Parameters.problem = problem;
    value = zeros(runtimes,problems);
    trade_best = cell(problems,1);
    best_pos = cell(problems,1);
    wmax_iter = cell(problems,1);
    algorithms = {'DSI_ECOP'}; % set the algorithm

    Parameters.wmax = 10;   % new parameter in the proposed method

    for alg = 1 : 1
        algorithm = algorithms{alg};
        for p = 1:problems
            Parameters.problemIndex = p;
            for i = 1:runtimes
                [best, iter_best, best_solution,~] = feval(algorithm,Parameters);
                outcome(i) = best;  % save the final fitness
                iter_value{i} = iter_best; % save the best fitness of each iteration
                solutions{i} =  best_solution; % save the best solution
            end
            value(:,p) = outcome;
            trade_best{p} = iter_value;
            best_pos{p} = solutions;
        end

        %  save the results as .m file
        V = 1;
        file_name = [algorithm,'_',num2str(problem),'_D',num2str(Parameters.D),'_',num2str(runtimes),'runs_V',num2str(V),'.mat'];
        flag = exist(file_name,'file');
        while flag == 2
            V = V+1;
            file_name = [algorithm,'_',num2str(problem),'_D',num2str(Parameters.D),'_',num2str(runtimes),'runs_V',num2str(V),'.mat'];
            flag = exist(file_name,'file');
        end
        save(file_name);
    end
end