
N = 10000; % number of random points
e = 0;
x = 0;
i = 0;
maxi = 0;
e_approx = 0;
while N > 0
   x = x + rand;
   i = i + 1;
 
   if x > 1
      if i > maxi
          e(i) = 1;
          maxi = i;
      else
          e(i) = e(i) + 1;
      end
      i = 0;
      x = 0;
      N = N - 1;
   end
end

newe = e/sum(e) 

for i = 1:length(newe)
   e_approx = e_approx + i * newe(i);
end

e_approx

e_exact = exp(1);

error = abs(e_exact - e_approx)
