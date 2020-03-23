function [y,d] = LorX(p,x)

g = sqrt(p(4));
D = p(4) + (x - p(5)./x).^2;

y = p(1) + p(2).*x + cos(p(6))*p(3)./D - sin(p(6))*p(3)./D.*(p(5)./x - x)./g;

if nargout > 1
    
    % calculate Jacobian of the function
    d(:,1) = ones(length(x),1);
    
    d(:,2) = x;

    d(:,3) = cos(p(6))./D - sin(p(6))./D.*(p(5)./x - x)./g;

    d(:,4) = p(3)./(D.^2).*(-cos(p(6)) + sin(p(6))/g*(p(5)./x - x)) + sin(p(6))*p(3)./D.*(p(5)./x - x)./2./(g^3);

    d(:,5) = p(3)./(x.*D.^2).*(2.*cos(p(6)).*(x - p(5)./x) + sin(p(6))/g*(2.*(x - p(5)./x).^2 - D));

    d(:,6) = p(3)./D.*(-sin(p(6)) - cos(p(6)).*(p(5)./x - x)./g);
    
    
end

end