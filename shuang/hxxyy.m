function sigma_4=hxxyy(X, bandw)
 % X is the data

[m,L]=size(X);

h=zeros(floor(L/4),1);
  
       for j=1:floor(L/4)
           Y=X(:,(j-1)*4+1:j*4);
           
           D=zeros(4,4); % D is the pairwise distance matrix
         for i=1:4
         temp=bsxfun(@minus,Y(:,(i+1):4),Y(:,i));
         D(i,(i+1):4)=dot(temp,temp);
         end
     % use rule of thumb to determine the bandwidth
         
         D=D+D';
    % apply RBF and obtain kernel matrix Kxx
         Kxx = exp(-1/2/bandw * D);
           
           
         h(j)=Kxx(1,2)+Kxx(3,4) - ...
             Kxx(1,3) -Kxx(2,4) ;
       end
       sigma_4=mean(h.^2);
       
end



















