

function [A2] = Update_A2(A2,MaxSize)

% A1的更新比较偏重于个体进入到可行解，

% 双档算法的核心在于  一个存档用于保存可以促进多样性的解，一个存档保存可以促进收敛性的解;
% A1用于可行性规则的保留  用于选择出来更多的可行解。
% A2用于目标值的保留，但是目标值如果单纯的用目标值来保留的话会导致一个问题，即完全都是不可行解
% 在CA DA 中 DA 有一个前提是保证可行，那么也就是说，可行解是最大的前提，之后再根据
% 目标空间的多样性去筛选，那么A1的作用同理，则A1首先保留可行解，因此直接使用可行性规则来做，但是有个问题需要注意的是，前期很少可行解的时候
% 当产生的可行解正好与其他解比较了的时候 需要将其优先保留下来。

% 复活赛原理， 选中和不被选中的前一半再次进行pk
% A2 更加注重目标值的优化，因此呢 偏重于目标值更好的解，
% 但是目标值更好的解会导致其约束值很差，这个地方是否可以用一个多目标的选择方式来选择。
% IBEA 更注重收敛性好的解，也就是说，  目标好，  约束值好。算了就用多目标的选择方式吧，
% 但是会存在约束为0  ojbk
     
    [~,distinct] = unique(roundn(A2.D,-6),'rows');   
    A2.D = A2.D(distinct,:);
    A2.F = A2.F(distinct,:);
    A2.cV = A2.cV(distinct,:);


    Dec = A2.D;
    Obj = [A2.F,A2.cV];
    Dec_Nor = (Dec - repmat(min(Dec,[],1),size(Dec,1),1))...
               ./repmat(max(Dec,[],1) - min(Dec,[],1),size(Dec,1),1);
    Obj_Nor = (Obj - repmat(min(Obj,[],1),size(Obj,1),1))...
               ./repmat(max(Obj,[],1) - min(Obj,[],1),size(Obj,1),1);
%    Obj = [1, 3
%           1, 4
%           1,0
%           0,1
%           0,1.0001
%           2,0
%            
%    ];


    ND = NDSort(Obj,1);
    
    p = 1/2;
    
    
    Dec = Dec(ND==1,:);
    Obj = Obj(ND==1,:);
    Dec_Nor = Dec_Nor(ND==1,:);
    Obj_Nor =  Obj_Nor(ND==1,:);
    N = size(Obj,1);

    if N <= MaxSize
        A2.D = Dec;
        A2.F = Obj(:,1);
        A2.cV = Obj(:,2);
        return;
    end
    
    
    
    Choose = false(1,N);
    
    [~,Extreme1] = min(Obj,[],1);
    [~,Extreme2] = max(Obj,[],1);
    Choose(Extreme1) = true;
    Choose(Extreme2) = true;
    if sum(Choose) > MaxSize
        Choosed = find(Choose);
        k = randperm(sum(Choose),sum(Choose) - MaxSize);
        Choose(Choosed(k)) = false;
    elseif sum(Choose) < MaxSize
        
        [~,index] = sort(Obj_Nor(:,2),'ascend');
         Choose(index(1:MaxSize)) = true;

          
    end
        
    A2.D = Dec(Choose,:);
    A2.F = Obj(Choose,1);
    A2.cV = Obj(Choose,2);
    
end