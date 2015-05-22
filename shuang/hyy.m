function sigma_2=hyy(X,bandw)

[m,L]=size(X);



h1=zeros(floor(L/6),2);

for j=1:floor(L/6)
    
       Y=X(:,(j-1)*6+1:j*6);
       
       %% calculate the kernel matrix
      
       D=zeros(6,6); % D is the pairwise distance matrix
       for i=1:6
         temp=bsxfun(@minus,Y(:,(i+1):6),Y(:,i));
         D(i,(i+1):6)=dot(temp,temp);
       end
     % use rule of thumb to determine the bandwidth
     
        
        D=D+D';
    % apply RBF and obtain kernel matrix Kxx
      Kxx = exp(-1/2/bandw * D);
    
           
      h1(j,1)=Kxx(1,2)+Kxx(5,6) - ...
             Kxx(1,5) -Kxx(2,6) ;
      h1(j,2)=Kxx(3,4)+Kxx(5,6) - ...
             Kxx(3,5) -Kxx(4,6) ;
end
       
       sigma_2=(1/(floor(L/6)-1))*(h1(:,1)-mean(h1(:,1)))'*(h1(:,2)-mean(h1(:,2)));




end
