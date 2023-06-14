function trial=DEgenerator_decode(p,objF,conV,weights,minVar,maxVar,w,wmax)

gen = w;
maxGen = wmax;
lu=[minVar;maxVar];
[popsize,n]=size(p);


% 试验向量
trial=zeros(popsize,n);

% 归一化

normalvoi=(conV-min(conV))./(max(conV)-min(conV)+eps(0));
normalfit=(objF-min(objF))./(max(objF)-min(objF)+eps(0));


%%
for i=1:popsize
    
    
    l=rand;
    
    if l < 1/3
        F=1.0;
    elseif l <2/3
        F=0.8;
    else
        F=0.6;
    end
    
    
   l=rand;
    
    if l < 1/3
        CR=1.0;
    elseif l <2/3
        CR=0.2;
    else
        CR=0.1;
    end
    
    
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
 
    
    FIT=weights(i)*normalfit+(1-weights(i))*normalvoi;

        
    [~,best]=min(FIT);
    
    if rand < gen/maxGen
        
        v=p(xr1,:)+F*(p(best,:)-p(xr1,:))+F*(p(xr3,:)-p(xr2,:));
        flag=0;
        
    else
        

        v=p(i,:)+rand*(p(xr1,:)-p(i,:))+F*(p(xr2,:)-p(xr3,:));
        flag=1;
    end
    
    
    
    % Handle the elements of the mutant vector which violate the boundary
     w = find(v < lu(1, :));
    if ~isempty(w)
        l=rand;
        if l < 0.5
            v(1, w) = 2 * lu(1, w) -  v(1, w);
            w1 = find( v(1, w) > lu(2, w));
            if ~isempty(w1)
                v(1, w(w1)) = lu(2, w(w1));
            end
        else
            if rand <0.4
                v(1, w) =  lu(1, w);
            else
                v(1, w) =  lu(2, w);
            end
        end
    end
    
    y = find(v > lu(2, :));
    if ~isempty(y)
        l=rand;
        if l<0.5
            
            v(1, y) =  2 * lu(2, y) - v(1, y);
            y1 = find(v(1, y) < lu(1, y));
            if ~isempty(y1)
                v(1, y(y1)) = lu(2, y(y1));
            end

        else
           if gen < maxGen*0.4
               v(1, y) =  lu(1, y);   
           else
               v(1, y) =  lu(2, y);  
           end
        end
    end
    
    
    if flag==0
        % Binomial crossover
        t = rand(1, n) < CR;
        j_rand = floor(rand * n) + 1;
        t(1, j_rand) = 1;
        t_ = 1 - t;
        trial(i, :) = t .* v + t_ .* p(i, :);
    else
        trial(i,:)=v;
    end
end

end