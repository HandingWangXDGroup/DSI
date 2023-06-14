function  [p,objF,conV,flag]=Debselect_decode(p,objF,conV,trial,objFtrial,conVtrial)



termconV=conV;
termobjF=objF;


flag=0;
betterIndex=find(conVtrial < termconV);
p(betterIndex,:)=trial(betterIndex,:);
objF(betterIndex)=objFtrial(betterIndex);
conV(betterIndex)=conVtrial(betterIndex);
flag=flag+length(betterIndex);

betterIndex=find(conVtrial==termconV & objFtrial < termobjF);
p(betterIndex,:)=trial(betterIndex,:);
objF(betterIndex)=objFtrial(betterIndex);
conV(betterIndex)=conVtrial(betterIndex);
flag=flag+length(betterIndex);
