function[A1,A2,Half] = Generator_code(A1,popsize,para_obj,para_con,wmax,bound)

global VAR
X=0;
VAR0=max(A1.cV);
cp=(-log(VAR0)-6)/log(1-0.5);

w = 1;
n = size(A1.D,2);
m = size(A1.C,2);

while w <= wmax
            if X < 0.5
                VAR=VAR0*(1-X)^cp;
            else
                VAR=0;
            end
    
    
    trial = zeros(3*popsize,n);
    sizepop = popsize;%size(pop,1);
        index = find(A1.cV == 0);
        if ~isempty(index)
            Best_solution = A1.D(index,:);
        else
            [~,bestid] = min(A1.cV);
            Best_solution = A1.D(bestid,:);
        end
    
    for i = 1:popsize
        %% 从CA中选取多的个体，从DA中选择目标值更好的个体
        l=rand;
        if l <= 1/3
            F  = .6;
        elseif l <= 2/3
            F= 0.8;
        else
            F = 1.0;
        end
        
        l=rand;
        if l <= 1/3
            CR  = .1;
        elseif l <= 2/3
            CR = 0.2;
        else
            CR = 1.0;
        end
        
        indexset = 1:popsize;
        indexset(i)=[];  r1=floor(rand*(popsize-1))+1; xr1=indexset(r1);
        indexset(r1)=[]; r2=floor(rand*(popsize-2))+1; xr2=indexset(r2);
        
        [~,best] = min(A1.F);
%         [~,best]= min(A1.F);
        v=A1.D(i,:)+F*(A1.D(best,:)- A1.D(i,:))+F*(A1.D(xr1,:)-A1.D(xr2,:));
        v = Repair(v, bound);
        t = rand(1, n) < CR;
        j_rand = floor(rand * n) + 1;
        t(1, j_rand) = 1;
        t_ = 1 - t;
        trial(3*(i-1)+1, :) = t .* v + t_ .* A1.D(i,:);
        %%  从DA中选取多个个体？， 从CA中选择约束更好的个体
        l=rand;
        if l <= 1/3
            F  = .6;
        elseif l <= 2/3
            F= 0.8;
        else
            F = 1.0;
        end
        
        l=rand;
        if l <= 1/3
            CR  = .1;
        elseif l <= 2/3
            CR = 0.2;
        else
            CR = 1.0;
        end
        indexset=1:sizepop;
        indexset(i)=[];
        r1=floor(rand*(sizepop-1))+1;
        xr1=indexset(r1);
        indexset(r1)=[];
        r2=floor(rand*(sizepop-2))+1;
        xr2=indexset(r2);
        indexset(r2)=[];
        r3=floor(rand*(sizepop-3))+1;
        xr3=indexset(r3);
        indexset(r3)=[];
        r4=floor(rand*(sizepop-4))+1;
        xr4=indexset(r4);

        
        bestt = size(Best_solution,1);
        bestid = floor(rand*(bestt))+1;
        
        v =A1.D(xr1,:)+ F*( Best_solution(bestid,:)-A1.D(xr2,:))+F*(A1.D(xr3,:)-A1.D(xr4,:));
        v = Repair(v, bound);
        t = rand(1, n) < CR;
        j_rand = floor(rand * n) + 1;
        t(1, j_rand) = 1;
        t_ = 1 - t;
        trial(3*(i-1)+2, :) = t .* v + t_ .* A1.D(i,:);
        
        %%
        l=rand;
        if l <= 1/3
            F  = .6;
        elseif l <= 2/3
            F= 0.8;
        else
            F = 1.0;
        end

        % CR: the crossover control parameter of DE
        indexset=1:popsize;
        indexset(i)=[];
        r1=floor(rand*(popsize-1))+1;
        xr1=indexset(r1);
        indexset(r1)=[];
        r2=floor(rand*(popsize-2))+1;
        xr2=indexset(r2);
        indexset(r2)=[];
        r3=floor(rand*(popsize-3))+1;
        xr3=indexset(r3);
        v=A1.D(i,:)+rand*(A1.D(xr1,:)-A1.D(i,:))+F*(A1.D(xr2,:)-A1.D(xr3,:));
        v = Repair(v, bound);
        trial(3*(i-1)+3, :) = v;
        
    end
    
    [U_F,~] = RBFInterp(trial , para_obj,0);
    [U_C,~] = RBFInterp(trial , para_con,0);
    
    U_FCV1 = [U_F,U_C];
    
    temp = trial;
    objFtemp = U_FCV1(:,1);
    temp_V1 = max(0,U_FCV1(:,2:end));
    conVtemp = sum(temp_V1,2);
    [trial, objFtrial, conVtrial]=preSelect_3(temp,objFtemp,conVtemp);
    
    
    offspring = trial;
    temp_F = objFtrial;
    temp_C = ones(popsize,m);
    temp_V = ones(popsize,m);
    temp_cV = conVtrial;%sum(temp_V,2);
    Off.D = offspring;
    Off.F = temp_F;
    Off.C = temp_C;
    Off.V = temp_V;
    Off.cV = temp_cV;
    
    % for A2
    Off2.D = temp;
    Off2.F = objFtemp;
    Off2.C = U_FCV1(:,2:end);
    Off2.V = temp_V1;
    Off2.cV = conVtemp;
    
%     [A1] = UpdateA1_steady(cat_struct(A1,Off),popsize);
    [A1] = Update_A1(A1,Off);
    [A1.D,A1.F,A1.cV]=epsSelect(A1.D,A1.F,A1.cV,Off.D,Off.F,Off.cV); 
    
%     [p,objF,conV]=epsSelect(p,objF,conV,trial,objFtrial,conVtrial); 
    
 
    
    
%     [A2] = Update_A2(cat_struct(A2,Off),popsize);
    if w ==  ceil(wmax/2)
        index = find(A1.cV == 0);
        if ~isempty(index)
            [~,bestid] = min(A1.F(index,1));
            Half.D = A1.D(index(bestid),:);
            Half.cV = A1.cV(index(bestid),:);
            Half.F = A1.F(index(bestid),:);
            
        else
            [~,bestid] = min(A1.cV);
            Half.D = A1.D(bestid,:);
            Half.cV = A1.cV(bestid,:);
            Half.F = A1.F(bestid,:);
        end
    end
    
    w = w+1;
    
    X = X+1/wmax;
end
A2 = A1;
end



