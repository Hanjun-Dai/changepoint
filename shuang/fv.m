function y=fv(x)

format long

 temp1=2/x*(normcdf(x/2)-0.5);
 temp2=x/2*normcdf(x/2)+normpdf(x/2);
 y=temp1/temp2;

end