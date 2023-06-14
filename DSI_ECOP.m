function [outcome, fbest, Best_solution,ww] = DSI_ECOP(Parameters)

warning off

[~,problemIndex,problem,func,lu, D, aaa] = parameter_setting(Parameters);


popsize = Parameters.popsize;
wmax = Parameters.wmax;

fbias = Parameters.fbias;
maxFes = Parameters.maxFes;

fbest = [];
minVar = lu(1,:);
maxVar = lu(2,:);

LHSsamples = lhsdesign(popsize,D);
pop = repmat(minVar,popsize ,1)+(repmat(maxVar - minVar,popsize ,1)).*LHSsamples;
[objF,conC, conV] = func(pop,problem,aaa);
cV = sum(conV,2);

if aaa == 0   % this is a flag for 2010 and 2017 problem 
    aaa = 1;
end

A.D = pop;
A.F = objF;
A.C = conC;
A.cV = cV;

Train = A;
Fes = popsize;

[fb,~,~,Best_solution ] = findbest(A);% find best in A
fbest(1) = (fb-fbias(problemIndex));
iter = 1;
A1 = UpdateA1(A,popsize);


obj_delete = [];  % Obj_rm
con_delete0 = []; % D_rm in the paper
con_delete1 = []; % D_rm in the paper

flag = 1;
while Fes < maxFes
    train_X = Train.D;
    train_Y = Train.F;
    train_C = Train.C;
    [~,distinct] = unique(roundn(train_X,-6),'rows');
    train_X = train_X(distinct,:);
    train_Y = train_Y(distinct,:);
    train_C = train_C(distinct,:);
    
    
    train_YY = [train_Y,train_C];
    para = RBFCreate(train_X, train_YY, 'cubic');

    con_delete = [con_delete0;con_delete1]; % D_rm in the paper

    %obj model
    [~,distinct] = unique(obj_delete,'rows');
    obj_delete = obj_delete(distinct,:);
    X1 = train_X;
    Y1 = train_Y;
    
    if ~isempty(obj_delete)  % remove some training data
        index = ismember(train_X,obj_delete,'rows');
        X1 = train_X(~index,:);
        Y1 = train_Y(~index,:);
    end
    
    para_obj = RBFCreate(X1,Y1,'cubic'); % build surrogate model for objective function
    
    %con model
    [~,distinct] = unique(con_delete,'rows');
    con_delete = con_delete(distinct,:);
    X2 = train_X;
    Y2 = train_C;
   
    if ~isempty(con_delete) % remove some training data
        index = ismember(train_X,con_delete,'rows');
        X2 = train_X(~index,:);
        Y2 = train_C(~index,:);
    end
    
    para_con = RBFCreate(X2,Y2,'cubic');  % build surrogate model for constraint functions

    iter = iter + 1;

    [AA1,Half] = Generator_c2ode(A1,popsize,para_obj,para_con,wmax,lu); % embedding algorithm 'c2ode'
 
    AA = AA1;
%    Half
    index = find(Half.cV == 0);
        if ~isempty(index)
            [~,bestid] = min(Half.F(index,1));
            offspring02 = Half.D(index(bestid),:);
            
        else
            [~,bestid] = min(Half.cV);
            offspring02 = Half.D(bestid,:);
        end
   
    ind = find(AA.cV == 0); 
    if ~isempty(ind)
        [~,bestid] = min(AA.F(ind,:));
        offspring01 = AA.D(ind(bestid),:);
        CV = 1;
    else
        [~,bestid] = min(AA.cV);
        offspring01 = AA.D(bestid,:);
        CV = 0;
    end
    
    offspring = [offspring01;offspring02];    
    % using uncertainty information
    dist1 = pdist2(offspring01,Train.D);
    if min(dist1) <= 1e-11
         AA = Half;
        [UFC,sigma] = RBFInterp(AA.D , para,1);  % 1 resprents output uncertainty information
        temp_V1 = max(0,UFC(:,2:end));
        conVtemp = sum(temp_V1,2);
        ind  = find( conVtemp == 0);
        if ~isempty(ind)
            [~,ind1] = max(sigma(ind));
            offspring = AA.D(ind(ind1),:);
        else
            [~,ind1] = max(sigma);
            offspring = AA.D(ind1,:);
        end
        flag = 0;
    end
    
    % expensive function evalution
    [objF,conC, conV] = func(offspring,problem,aaa);
    cV = sum(conV,2);
    Fes = Fes + size(offspring,1);
    O.D = offspring;
    O.F = objF;
    O.C = conC;
    O.cV = cV;  
    Off = O ;
    
    
    if size(offspring,1) > 1
    if pdist2(offspring01,offspring02) == 0 
         Fes = Fes -1;  
         Off.D = O.D(1,:);
         Off.F = O.F(1,:);
         Off.C = O.C(1,:);
         Off.cV = O.cV(1,:); 
    end
    end
    
    
    
    A1 = UpdateA1(cat_struct(A1,Off),popsize);

    Train = cat_struct(Train,Off);
            index = find(Train.cV == 0);
        if ~isempty(index)
            [fb,bestid] = min(Train.F(index,1));
            Best_solution = Train.D(index(bestid),:);

        else
            [~,bestid] = min(Train.cV);
            Best_solution = Train.D(bestid,:);
            fb = NaN;
        end
    
    if flag == 1
        % modify the wmax
        if O.cV(1) > O.cV(2)
            wmax = wmax*0.5;
        elseif O.cV(1) == O.cV(2)
            if O.F(1) >= O.F(2)
                wmax = wmax *0.5;  
               [~,Index] = max(Y1(:,1));
               obj_delete = [obj_delete;X1(Index,:)];  % modify the obj training data
            else
                wmax = wmax *2;
            end
        else
            wmax = wmax *2; 
        end 
        
        % modify the con training data
        if O.cV(1) == 0
            CV_real1 = 1;
            if CV_real1 ~= CV  % A feasible solution is predicted as infeasible
               [~,~,num] = RBFInterp_01(offspring01,para_con,0);
               index = num(2); 
               con_delete1 = [ con_delete1;X2(index,:) ]; 
               if ~isempty(con_delete0)
                   n_0 =size(con_delete0,1);
                   con_delete0(floor(n_0*rand)+1,:) = [];
               end
            end    
        else
            CV_real1 = 0;
            if CV_real1 ~= CV % An infeasible solution is predicted as feasible 
                [~,~,num] = RBFInterp_01(offspring01 , para_con,0);
                index = num(1);
                con_delete0 = [ con_delete0;X2(index,:) ]; 
                if ~isempty(con_delete1)
                   n_0 =size(con_delete1,1);
                   con_delete1(floor(n_0*rand)+1,:) = [];
               end
            end
        end
              
       
    end
    
    flag = 1;
    
    wmax = max(wmax,5);
    wmax = min(wmax,80);
    ww(iter-1) = wmax;
    fbest(iter) = fb - fbias(problemIndex);
end
outcome = fb - fbias(problemIndex);

end



function [fb,Best_solution_F,Best_solution_CV,Best_solution ] = findbest(Train)

index = find(Train.cV == 0);
if ~isempty(index)
    [fb,bestid] = min(Train.F(index,1));
    Best_solution = Train.D(index(bestid),:);
    Best_solution_F = Train.F(index(bestid),:);
    Best_solution_CV  = 0;
else
    [~,bestid] = min(Train.cV);
    Best_solution = Train.D(bestid,:);
    Best_solution_F = Train.F(bestid,:);
    fb = NaN;
    Best_solution_CV = Train.cV(bestid,:);
end

end




function [problemSet,problemIndex,problem,func,lu, D, aaa] = parameter_setting(Parameters)

if Parameters.problem == 2006
    
    problemSet = [1,2,4,6,7,8,9,10,12,16,18,19,24];
    problemIndex = Parameters.problemIndex;
    problem =  problemSet(problemIndex);
    func = @fitness_2006;
    [lu, D, aaa, ~] = problemsetting(problem);
    
elseif Parameters.problem  == 2010
    
    problemSet = [1,7,8,13,14,15];
    problemIndex = Parameters.problemIndex;
    problem =  problemSet(problemIndex);
    func = @fitness_2010;
    D = Parameters.D;
    [lu] = problemsetting_cec2010(problem,D);
    aaa = [];
    
else
    
   
    problemSet = [1, 2, 4, 5, 13, 19, 20, 22, 28];
    problemIndex = Parameters.problemIndex;
    problem =  problemSet(problemIndex);
    func = @fitness_2017;
    D = Parameters.D;
    [lu] = problemsetting_cec2017(problem,D);
    aaa = 0;
    
end

end