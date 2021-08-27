clc;
clear;

% Dimensional, thermal, and material properties
r0 = 0.5; % Rod radius, m
rho = 8933; % Rod density, kg/m^3
c = 385; % Specific heat, J/kg*K
k = 401; % Rod thermal conductivity, W/m*K
q_dot = 400000; % Thermal generation rate, W/m^3
T_i = 330; % Rod initial temperaure, K
T_inf = 300; % Air temperature, K
h = 20; % Convection heat transfer coefficient for air, W/m*K

%% Node settings

phi= 360; % degrees
n_r=41; %number of nodes along radial direction
n_phi=41; %number of nodes along angular direction
total_time= 3600; % 1 hour; s
delta_r = (r0)/(n_r-1); % radial increment
delta_phi = (360)/(n_phi-1); % angular increment
dt=0.1; % time increment; s
nt=total_time/dt+1; % number time steps

m = 1:delta_r:n_r;
n = 1:delta_phi:n_phi;
alpha= k/(rho*c); %thermal diffusivity
Fo = (alpha*dt)/((delta_r)^2);
Bi = (h*delta_r)/k;

time = zeros(nt,1); % time
T = zeros(n_r,n_phi,nt);  %temperature fie1d

% Time steps
for i=1:1:nt
  time(i)=(i-1)*dt;
end

for i=1:1:n_r
   m_i(i)=(i-1)+delta_r;
   n_i(i)=(i-1)*delta_phi;
end

% boundary conditions
for i=1:1:n_r
     for j=1:1:n_phi
      T(i,j,1)=T_i; % initial condition
     end
end

%% Temp equations 

for a=2:1:nt
    for i=1:1:n_r
        for j= 2:1:(n_phi-1)
            if i > 1 && i < n_r % interior node
                T(i,j,a) = Fo* ( ((m_i(i)-0.5)*(T(i-1,j,a-1)-T(i,j,a-1))/m_i(i)) + ((m_i(i)+0.5)*(T(i-1,j,a-1)-T(i,j,a-1))/m_i(i))...
                     + ((T(i,j+1,a-1)+T(i,j-1,a-1)- 2*T(i,j,a-1))/(m_i(i)^2*delta_phi^2)) + ((q_dot*delta_r^2)/k)) + T(i,j,a-1);
            if i == 1 && j == 1 % center node
                T(i,j,a) = Fo* (0.5* (T(1,j,a-1)+T(1,j+1,a-1)+T(1,j+2,a-1)+ T(1,j+3,a-1)...
                    + T(1,j+4,a-1)+T(1,j+5,a-1)+T(1,j+6,a-1)+T(1,j+7,a-1)+T(1,j+8,a-1)...
                    +T(1,j+9,a-1)+T(1,j+10,a-1)+T(1,j+11,a-1)+T(1,j+12,a-1)+T(1,j+13,a-1)...
                    +T(1,j+14,a-1)+T(1,j+15,a-1)+T(1,j+16,a-1)+T(1,j+17,a-1)+T(1,j+18,a-1)...
                    +T(1,j+19,a-1)+T(1,j+20,a-1)+T(1,j+21,a-1)+T(1,j+22,a-1)+T(1,j+23,a-1)...
                    +T(1,j+24,a-1)+T(1,j+25,a-1)+T(1,j+26,a-1)+T(1,j+27,a-1)+T(1,j+28,a-1)...
                    +T(1,j+29,a-1)+T(1,j+30,a-1)+T(1,j+31,a-1)+T(1,j+32,a-1)+T(1,j+33,a-1)...
                    +T(1,j+34,a-1)+T(1,j+35,a-1)+T(1,j+36,a-1)+T(1,j+37,a-1)+T(1,j+38,a-1)...
                    +T(1,j+39,a-1)+T(1,j+40,a-1)-(41* T(1,j,a-1)))+ ((q_dot*delta_r^2)/k))+ T(1,j,a-1);
                
            else % surface node
                T(i,j,a) = Fo* ( ((m_i(i)-0.5)*(T(i-1,j,a-1)-T(i,j,a-1))/m_i(i))...
                    + (( T(i,j-1,a-1)+T(i,j+1,a-1)-2*T(i,j,a-1))/(m_i(i)^2*delta_phi^2))...
                    + (Bi*(T(i,j,a-1)-T_inf))+ ((q_dot*delta_r^2)/k))+ T(i,j,a-1);
            end
            end
        end
   end
end

%% P1otting
 
[Phi,R]=meshgrid(linspace(0,2*pi,n_phi),linspace(0,r0,n_r));
z=T(:,:,:);
[x,y,z] = pol2cart(Phi, R, z);

% Temperature over time plots
figure(1);

[T_center] = squeeze(T(1,1,1:end)); % center node temperature for all time instances
[T_surface] = squeeze(T(n_r,(n_phi-1)/2,1:end)); % surface node temperature for all time instances
[T_interior] = squeeze(T((n_r-1)/2,(n_phi-1)/4,1:end)); % interior node temperature for all time instances
plot(time,T_center,time,T_surface, time, T_interior)
legend('Center Node','Surface Node','Interior Node')
title('Temperature Over Time')
xlabel('Time (s)');
ylabel('Temperature (K)');
grid on

% Initial temperature plot
figure(2)

ph_1=pcolor(x,y,z(:,:,1));
ph_1.ZData = ph_1.CData; %to show z value in pcolor plot
colorbar
shading('interp');
title('Steady State Temperature: Initial')
xlabel('raduis (m)');
ylabel('raduis (m)');
box on;
%
hold on

% Final time plot 
figure(3)

ph_2=pcolor(x,y,z(:,:,nt));
ph_2.ZData = ph_2.CData; %to show z value in pcolor plot
colorbar
shading('interp');
title('Steady State Temperature: Final')
xlabel('raduis (m)');
ylabel('raduis (m)');
box on;
%
hold on
