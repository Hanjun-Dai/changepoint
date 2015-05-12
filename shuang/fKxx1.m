function [K]=fKxx1(A,B,M,bandw,flag )
    

% we use row index to refer to pre-data and 
% column index to refer to post-data
% Here, we use A refer to pre-data and
% B refer to post-data



switch flag
    
    
    case 1  %  Kxx_post=fKxx1(X(:, index-M+1: index), X(:, index-M+1: index),1);  
        
        
        D=[];
        for i=1:M
            temp=bsxfun (@minus, A(:,(i+1):M), B(:, i)); 
            D((i+1):M,i)=dot(temp,temp)';
        end

          D=D+D'; % D is the pairwise distance matrix

          K = exp(-D/2/bandw);
          K(logical(eye(size(K))))=0; % set the diagonal entries 0
                     
        
    case 2
        
         
             D=[];
              for i=1:M
                  temp=bsxfun (@minus, A(:,1:M), B(:, i));
                  D(1:M,i)=dot(temp,temp)';
                
              end
         
           K=exp(-1/2/bandw * D);
           %K(logical(eye(size(K))))=0; % set the diagonal entries 0
   
                
         
    case 3  % temp=fKxx(X(:,index-M+1:index), X(:, index),N,M,4); % M by 1
        
        K=[];
        
         temp=bsxfun (@minus, A, B);
         D=dot(temp,temp)';
         K=exp(-1/2/bandw * D);
         K(M)=0;
         
  
        
end

