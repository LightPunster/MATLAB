clc,clear

A = Event('person has disease',0.001);
A.Compliment();

B = Event('test is positive');
B.addConditions({A,A.c},{0.95,0.05});
B.Compliment();

fprintf('P({%s}|{%s})\n\t= %f\n',A.d,B.d,BayesRule(A,B));