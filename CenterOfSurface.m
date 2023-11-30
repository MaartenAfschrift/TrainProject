syms z
l = 18.5+(57-18.5)/142*z;
opp1 = (l+18.5)*z*0.5;
opp2 = (l+57)*(142-z)*0.5;
eq = opp1==opp2;
sol = solve(eq);

disp(sol)