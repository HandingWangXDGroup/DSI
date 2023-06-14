function  [p,fit,voi]=epsSelect(p,fit,voi,trial,fittrial,voitrial)
%%
[popsize,~]=size(p);
global VAR 


for i=1:popsize
    if voitrial(i) < VAR && voi(i) < VAR
        if fittrial(i) < fit(i)
            
            p(i,:)=trial(i,:);
            fit(i)=fittrial(i);
            voi(i)=voitrial(i);

        end
    elseif voitrial(i) == voi(i) 
        if fittrial(i) < fit(i)

            p(i,:)=trial(i,:);
            fit(i)=fittrial(i);
            voi(i)=voitrial(i);
            
        end
    elseif voitrial(i) < voi(i)

        p(i,:)=trial(i,:);
        fit(i)=fittrial(i);
        voi(i)=voitrial(i);
        
    end
end


