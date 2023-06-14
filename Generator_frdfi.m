
function[A1, Half] = Generator_frdfi(A1,popsize,para_obj,para_con,wmax,bound)


w = 1;
p = A1.D;
objF = A1.F;
conV = A1.cV;
minVar = bound(1,:);
maxVar = bound(2,:);

while w <= wmax

    trial = DEgenerator_frdfi(p,objF,minVar,maxVar);
    [U_F,~] = RBFInterp(trial , para_obj,0);
    [U_C,~] = RBFInterp(trial , para_con,0);

    U_FCV1 = [U_F,U_C];

    objFtrial = U_FCV1(:,1);
    temp_V1 = max(0,U_FCV1(:,2:end));
    conVtrial = sum(temp_V1,2);

    [p,objF,conV,recordp,recordobjF,recordconV]=Debselect(p,objF,conV,trial,objFtrial,conVtrial);
    [p,objF,conV]=replacement(p,objF,conV,recordp,recordobjF,recordconV);


    % mutation
    [popsize,n]=size(p);
    minConV=min(conV);
    if  minConV ~= 0
        [~,maxConVIndex]=max(conV);
        randIndex=floor(rand*popsize)+1;
        term=p(randIndex,:);
        randD=floor(rand*n)+1;
        term(randD)=minVar(randD)+rand.*(maxVar(randD)-minVar(randD));

        [U_F,~] = RBFInterp(term , para_obj,0);
        [U_C,~] = RBFInterp(term , para_con,0);
        U_FCV1 = [U_F,U_C];
        objFterm = U_FCV1(:,1);
        temp_V1 = max(0,U_FCV1(:,2:end));
        conVterm = sum(temp_V1,2);


        if  objFterm < objF(maxConVIndex)
            p(maxConVIndex,:)=term;
            objF(maxConVIndex)=objFterm;
            conV(maxConVIndex)=conVterm;
        end

    end


    if w == ceil(wmax/2)
        A1.D = p;
        A1.F = objF;
        A1.cV = conV;
        Half = A1;
    end
    w = w +1;

end
A1.D = p;
A1.F = objF;
A1.cV = conV;

end