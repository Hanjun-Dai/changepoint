function Pr = calc_tail_prob(b, M, T)
  
    Pr = 0;
    temp1=exp(-0.5*(b^2));
    temp2=1/sqrt(2* pi);
        temp3=b*sqrt(2*(2*M-1)/M/(M-1));
        temp4=fv(temp3);
        temp5=(b^2)*(2*M-1)/M/(M-1);
        temp6=temp4*temp5;
        Pr=Pr+temp6 * (T - M + 1);
    Pr=Pr*temp1*temp2;
end