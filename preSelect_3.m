function [trial, objFtrial, conVtrial]=preSelect_3(temp,objFtemp,conVtemp)

[totalSize,n]=size(temp);

popsize=totalSize/3;

trial=zeros(popsize,n);
objFtrial=zeros(popsize,1);
conVtrial=zeros(popsize,1);


for i=1:popsize
    
    
    index=[(i-1)*3+1;(i-1)*3+2;(i-1)*3+3];
   
    fit=objFtemp(index);
    voi=conVtemp(index);
    
    if isempty(find(voi==0))
        [~,r]=min(voi);
    else
        r1=find(voi==0);
        [~,r2]=min(fit(r1));
        r=r1(r2);
    end
    
    trial(i,:)=temp(index(r),:);
    objFtrial(i,:)=objFtemp(index(r),:);
    conVtrial(i,:)=conVtemp(index(r),:); 
    
end

