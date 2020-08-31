function [ N,M,A,Ag ] = Read_File( file )


N = fscanf(file,'%5d',[1,1]);
M = fscanf(file,'%5d',[1,1]);
E = fscanf(file,'%5d',[2,M]);
A=zeros(N,N);
Ag=zeros(N,N);
for k=1 : M
    i=E(1,k);
    j=E(2,k);
    A(i,j)=1;
    Ag(i,j)=1;
    A(j,i)=1;
end

end

