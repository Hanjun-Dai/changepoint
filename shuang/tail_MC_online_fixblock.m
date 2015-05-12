% Monte Carlo 

% B test
% With sliding windows
clear 

close all

mu_0=0; % the mean before the change point
sigma_1=1; % the standard deviation before the change point


%% CUSUM_B_test
N=10; % N is the total number of blocks
M=2; % M is the upper bound for size of blocks
%B=2:M;

rep=1000; 


%% estimate bandwidth

X_s=zeros(20,500);
X_s(:,[1:500])=normrnd(mu_0,sigma_1,[20,500]);


%% calculate the kernel matrix
[ms,ns]=size(X_s);
Ds=zeros(ns,ns); % D is the pairwise distance matrix
for i=1:ns
    temp=bsxfun(@minus,X_s(:,(i+1):ns),X_s(:,i));
    Ds(i,(i+1):ns)=dot(temp,temp);
end
% use rule of thumb to determine the bandwidth
bandw=median(Ds(Ds~=0));


sigma_2_sq=0.004574751923643;
sigma_4_sq=0.018622680903357;
C=(sigma_4_sq/N) +(N-1)*sigma_2_sq/N;

S_var=C*2/M/(M-1);



output=[];


b=5; 
freq=0;
h=1;




for t=1:rep % total number of runs    
    
      Y=normrnd(mu_0,sigma_1,[20,1000]); % Y is testing data
      [m,n]=size(Y);
       
      flag=1; % once cross the threshold, set the flag=0
       
      %% initialize      
      % sample data
        
       index=M;  
       X=normrnd(mu_0,sigma_1,[20,N*M]); % X is reference data
       X_sample=normrnd(mu_0,sigma_1,[20,N*M]); % X is reference data      
       
       Kxx_post=fKxx1(Y(:, index-M+1:index), Y(:, index-M+1:index),M,bandw,1); % M by M
       
       Kxx_pre=[];
       Kxx_cross=[];
       
       for j=1:N       
        Kxx_pre=[Kxx_pre; fKxx1(X(:,(j-1)*M+1: j*M),X(:,(j-1)*M+1: j*M),M,bandw,1)]; %  N*M by M 
        Kxx_cross=[Kxx_cross; fKxx1(X(:,(j-1)*M+1: (j-1)*M+M), Y(:, index-M+1: index),M,bandw,2)]; % N*M by M
       end
       
      
   while (flag==1) && (index < n)    
   
       %S=[];
      
         
          MMD=[];
             T=Kxx_post;
             temp1=1/M/(M-1)*sum(T(:));
         for j=1:N  
             A=Kxx_pre( j*M-M+1:j*M,  1:M );
             C=Kxx_cross( j*M-M+1:j*M,  1:M);
             MMD(j)= 1/M/(M-1)*sum(A(:))+ temp1 - 2/M/(M-1)*sum(C(:));
         end 
         S=mean(MMD);
   
       
         B_stat=(S./sqrt(S_var)) ;
     
     if B_stat > b
         freq=freq+1; 
         index
         
         flag=0;
     end
        
     
           index=index+1; % index is the end of sliding window
           
           Kxx_post(1:M-1,1:M-1)=Kxx_post(2:M,2:M);
           temp=fKxx1(Y(:,index-M+1:index),Y(:, index),M,bandw,3); % M by 1
           Kxx_post(:,M)=temp;
           Kxx_post(M,:)=temp';
           
     
           % given new data, we need to update Kxx_post, Kxx_pre, and Kxx_cross
          
           r=mod(index,M); % if r==0, we need to sample the reference data blocks
           
           
           
           if r==0
               
               
                for j=1:N
                  
               Kxx_pre((j-1)*M+1:(j-1)*M+M-1, 1:M-1)=Kxx_pre((j-1)*M+2:(j-1)*M+M, 2:M);
               temp=fKxx1( X_sample(:,(j-1)*M+1:(j-1)*M+M), X_sample(:, (j-1)*M+M),M,bandw,3);
               Kxx_pre((j-1)*M+1:(j-1)*M+M, M)=temp;
               Kxx_pre((j-1)*M+M,:)=temp';
                                
           % Kxx_cross
                     
               Kxx_cross((j-1)*M+1:(j-1)*M+M-1, 1:M-1)=Kxx_cross((j-1)*M+2:(j-1)*M+M, 2:M);
               temp1=fKxx1(X_sample(:,(j-1)*M+1:(j-1)*M+M), Y(:,index),M,bandw,3);
               temp2=fKxx1( Y( :,index-M+1:index), X_sample(:,(j-1)*M+M),M,bandw,3);
               Kxx_cross((j-1)*M+1:(j-1)*M+M, M)=temp1;
               Kxx_cross((j-1)*M+M,:)=temp2';
                end
                
                X=X_sample;   
                X_sample=normrnd(mu_0,sigma_1,[20,N*M]); % X is reference data      
             
           elseif r~=0
           
               for j=1:N
                  
               Kxx_pre((j-1)*M+1:(j-1)*M+M-1, 1:M-1)=Kxx_pre((j-1)*M+2:(j-1)*M+M, 2:M);
               temp=fKxx1( [X(:, j*M-(M-r)+1:j*M), X_sample(:,(j-1)*M+1:(j-1)*M+r)], X_sample(:, (j-1)*M+r),M,bandw,3);
               Kxx_pre((j-1)*M+1:(j-1)*M+M, M)=temp;
               Kxx_pre((j-1)*M+M,:)=temp';
                                
           % Kxx_cross
                     
               Kxx_cross((j-1)*M+1:(j-1)*M+M-1, 1:M-1)=Kxx_cross((j-1)*M+2:(j-1)*M+M, 2:M);
               temp1=fKxx1([X(:, j*M-(M-r)+1:j*M), X_sample(:,(j-1)*M+1:(j-1)*M+r)] , Y(:,index),M,bandw,3);
               temp2=fKxx1( Y( :,index-M+1:index), X_sample(:,(j-1)*M+r),M,bandw,3);
               
              % temp2=fKxx1( X( :,index-(j+2)*M+1:index-(j+2)*M+M), X(:,index-(j+2)*M+M),M,bandw,3);
               Kxx_cross((j-1)*M+1:(j-1)*M+M, M)=temp1;
               Kxx_cross((j-1)*M+M,:)=temp2';
                           
              end   
                             
               
           end
  
 
    end         

fprintf(1, '--experiment no %d of %d\n', t, rep);
end

output(h,1)=b;
output(h,2)=freq/rep;
output


         
 