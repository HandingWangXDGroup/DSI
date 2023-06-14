function [y,sigma2,num] = RBFInterp_01(x, para,ff)
ax = para.nodes;
nx = size(x, 1);
np = size(ax, 1);    % np: the size of data set

xmin = para.xmin;
xmax = para.xmax;
ymin = para.ymin;
ymax = para.ymax;
% normalization
% x = 2./(repmat(xmax - xmin, nx, 1)) .* (x - repmat(xmin, nx, 1)) - 1;
for i = 1 : length(xmin)
   if xmin(i) ~= xmax(i)
       x(:, i) = 2 ./ (repmat(xmax(i) - xmin(i), nx, 1)) .* (x(:, i) - repmat(xmin(i), nx, 1)) - 1;
   end
end

r = dist(x, ax');
switch para.kernel
    case 'gaussian'
        Phi = radbas(sqrt(-log(.5))*r);
    case 'cubic'
        Phi = r.^3;
    case 'multiquadric'
        Phi=sqrt(r.^2+0.8^2);
end
for i = 1:nx
  weight = Phi(i,:)'.* para.alpha; 
  cv_weight = weight;
  cv  = sum(cv_weight,2);
  [~,num(i,1)] = min(cv);
  [~,num(i,2)] = max(cv);
end

y = Phi * para.alpha + [ones(nx, 1), x] * para.beta;
% y1 = y;

% renormalization
% y = repmat(ymax - ymin, nx, 1)./2 .* (y + 1) + repmat(ymin, nx, 1);
for i = 1 : length(ymin)
   if ymin(i) ~= ymax(i)
       y(:, i) = repmat(ymax(i) - ymin(i), nx, 1)./2 .* (y(:, i) + 1) + repmat(ymin(i), nx, 1);
       
   end
end

if ff == 1
switch para.kernel
    case 'gaussian'
        sigma2 = 1 / sqrt(2 * pi) - Phi*(para.Phi\(Phi'));
    case 'cubic'
        sigma2 =  - Phi*(para.Phi\(Phi'));
end
sigma2 = abs(diag(sigma2));
else
    sigma2= [];
end

end