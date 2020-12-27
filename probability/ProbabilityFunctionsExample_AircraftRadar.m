clc,clear

A = Event('aircraft present',0.05);
A.Compliment();

B = Event('radar generates alarm');
B.addConditions({A,A.c},{0.99,0.1});
B.Compliment();

%Example 1
P_Ac_int_B = Intersect(A.c,B);
fprintf('P({%s} U {%s})\n\t= %f\n',A.c.d,B.d,P_Ac_int_B);
P_A_int_Bc = Intersect(A,B.c);
fprintf('P({%s} U {%s})\n\t= %f\n',A.d,B.c.d,P_A_int_Bc);

%Example2
A.invertConditions(B);
fprintf('P({%s}|{%s})\n\t= %f\n',A.d,B.d,A.P_cond(B.d));