function I = mcintegralfunction(f,a,b,n)
tic
for i = 1:n
   

    randPoints = a + (b-a) .* rand(n,1);
    
    I = ((b-a)/n)* sum(f(randPoints));
  
end
toc
end
