
function[A1, Half] = Generator_decode(A1,popsize,para_obj,para_con,wmax,bound)



p = A1.D;
objF = A1.F;
conV = A1.cV;
minVar = bound(1,:);
maxVar = bound(2,:);

archive = p;
archiveobjF = objF;
archiveconV=conV;

w = 1;
X = 0;
recordvoi = mean(conV);
n = size(A1.D,2);
VAR0 = min(10^(n/2),max(conV));
cp=(-log(VAR0)-6)/log(1-0.85);
pmax=1;
Y=0; flag=0;

while w <= wmax

    if X < 0.85
                VAR=VAR0*(1-X)^cp;
    else
                VAR=0;
    end

    if length(find(conV==0)) > 0.85*popsize
        VAR=0;
    end

     if isempty(find(conV<VAR))
                pmax=1.e-18;
      end
      pr=max(1.e-18,pmax/(1+exp(30*(w/wmax-0.75))));

      if std(conV)<1.e-6  && isempty(find(conV==0)) 
         p(1:popsize,:)=repmat(minVar,popsize,1)+rand(popsize,n).*repmat((maxVar-minVar),popsize,1);
        [U_F,~] = RBFInterp(p, para_obj,0);
        [U_C,~] = RBFInterp(p , para_con,0);
        U_FCV1 = [U_F,U_C];
        objF = U_FCV1(:,1);
        temp_V1 = max(0,U_FCV1(:,2:end));
        conV = sum(temp_V1,2);
      end
    weights = [0:pr/popsize:pr-pr/popsize]';
    sortindex=randperm(popsize);
     weights(sortindex)=weights;
    trial=DEgenerator_decode(p,objF,conV,weights,minVar,maxVar,w,wmax);
    [U_F,~] = RBFInterp(trial , para_obj,0);
    [U_C,~] = RBFInterp(trial , para_con,0);

    U_FCV1 = [U_F,U_C];

    objFtrial = U_FCV1(:,1);
    temp_V1 = max(0,U_FCV1(:,2:end));
    conVtrial = sum(temp_V1,2);

    [p,objF,conV]=environmentSelect(p,objF,conV,trial,objFtrial,conVtrial,weights);

    [archive,archiveobjF,archiveconV]=Debselect_decode(archive,archiveobjF,archiveconV,trial,objFtrial,conVtrial);


    if w == ceil(wmax/2)
        A1.D = archive;
        A1.F = archiveobjF;
        A1.cV = archiveconV;
        Half = A1;
    end

    X = X+1/wmax;
    w = w +1;

end
 A1.D = archive;
        A1.F = archiveobjF;
        A1.cV = archiveconV;

end