function [RegInfo] = LinearRegression(F,V)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
iDel  = isnan(F) | isnan(V);
F(iDel) = [];
V(iDel) = [];
x = [ones(length(V),1) V.^2];
RegInfo.A = x\F;
RegInfo.F_recon = x*RegInfo.A;
RegInfo.R = corrcoef(F,RegInfo.F_recon);
RegInfo.Rsq = RegInfo.R(1,2).^2;

end