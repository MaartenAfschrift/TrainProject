syms z % height COM
l = 18.5+(57-18.5)/142*z; % witdh at z
opp1 = (l+18.5)*z*0.5; %
opp2 = (l+57)*(142-z)*0.5;
eq = opp1==opp2;
sol = solve(eq);

disp(sol)

z =(923*2^(1/2)*85^(1/2))/77 - 5254/77;
l = 18.5+(57-18.5)/142*z; % witdh at z
opp1 = (l+18.5)*z*0.5; %
opp2 = (l+57)*(142-z)*0.5;
totOpp = opp1+opp2;
totOpp = totOpp*10^-4;
