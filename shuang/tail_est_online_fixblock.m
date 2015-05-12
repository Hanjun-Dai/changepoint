%% analytic computation

clear
close all
format long

%% 
M=10; %M is the maximum block size 
T=1000; % T is the time

b=4:0.01:6;
L=length(b);
output=zeros(L,2);
j=1;

for b=4:0.01:6
    
Pr=0;

 temp1=exp(-0.5*(b^2));
 temp2=1/sqrt(2* pi);
 for t=M:1:T
     
   
    temp3=b*sqrt(2*(2*M-1)/M/(M-1));
    temp4=fv(temp3);
    temp5=(b^2)*(2*M-1)/M/(M-1);
    temp6=temp4*temp5;
    
    Pr=Pr+temp6;
 end
 Pr=Pr*temp1*temp2;

output(j,1)=b;

output(j,2)=Pr;
j=j+1;

end

output

%% tail probability = 0.1
% theory b = 2.6
% simulation b = 2.2