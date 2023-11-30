function [out] = Moments3D(COP,F,M)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
out = zeros(size(F));
out(:,1)= (COP(:,2).*F(:,3) - COP(:,3).* F(:,2))- M(:,1);
out(:,2) = (COP(:,3).*F(:,1) - COP(:,1).* F(:,3)) -M(:,2);
out(:,3) = (COP(:,1).*F(:,2) - COP(:,2).* F(:,1)) - M(:,3);
end