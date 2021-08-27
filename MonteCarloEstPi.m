N = 10000; % number of random points
local_hits = 0;
for i = 1:N+1
   x = rand - 0.5; % rand chooses a random number between [0,1]
   y = rand - 0.5; % rand chooses a random number between [0,1]
   
   if (x * x + y * y < 0.25)
       local_hits = local_hits + 1; % check to see how many fall into area
   end
end

pi_approx = 4 * local_hits/N; % since only found a quarter of circle, multiply by 4 to get pi
pi_exact = pi;

error = abs(pi_exact - pi_approx) % subtract pi from our approx to see how far off our approx is