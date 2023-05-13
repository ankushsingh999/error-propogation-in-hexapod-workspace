function Error_model
close all
clc
%Given
td = 250;  %top platform diameter
bd = 650;  %base platform diameter
lmin = 604.8652;
lmax = 1100; 
hp = 800;
a = 0;
b = 0;
c = 0;
Rm=250/2;
Rf=650/2;
alpha=40*pi/180;
beta=85*pi/180;

%calculating the spheres centers based on the parameters from the  Given data in the question for hexapod

c1=[Rf*cos(alpha/2) , Rf*sin(alpha/2), 0]' - [Rm*cos(beta/2) , Rm*sin(beta/2), 0]'
c2=[-Rf*sin(pi/6-alpha/2) , Rf*cos(pi/6-alpha/2), 0]' - [-Rm*sin(pi/6-beta/2) , Rm*cos(pi/6-beta/2), 0]'
c3=[-Rf*sin(pi/6+alpha/2) , Rf*cos(pi/6+alpha/2), 0]' - [-Rm*sin(pi/6+beta/2) , Rm*cos(pi/6+beta/2), 0]'
c4=[-Rf*cos(pi/3-alpha/2) , -Rf*sin(pi/3-alpha/2), 0]' - [-Rm*cos(pi/3-beta/2) , -Rm*sin(pi/3-beta/2), 0]'
c5=[-Rf*cos(pi/3+alpha/2) , -Rf*sin(pi/3+alpha/2), 0]' - [-Rm*cos(pi/3+beta/2) , -Rm*sin(pi/3+beta/2), 0]'
c6=[Rf*cos(alpha/2) , -Rf*sin(alpha/2), 0]' - [Rm*cos(beta/2) , -Rm*sin(beta/2), 0]'

%The real and nominal values taken from Table 1 and Table 2 of the paper.
%nk = nominal value of kinematic parameteres (nominal si(1-3), ui(4-6) and l(7))
%rk = real values of kinematic parameters    (real si(1-3), ui(4-6) and l(7))

nk = [92.1597 84.4488 0 305.4001 111.1565 0 604.8652;
       27.055 122.037 0 -56.4357 320.0625 0 604.8652;
      -119.2146 37.5882 0 -248.9644 208.9060 0 604.8652;
      -119.2146 -37.5882 0 -248.9644 -208.9060 0 604.8652;
       27.055 -122.037 0 -56.4357 -320.0625 0 604.8652;
       92.1597 -84.4488 0 305.4001 -111.1565 0 604.8652;]';

rk = [96.6610 81.7602 1.0684 305.2599 115.0695 2.6210 604.4299;
       22.2476 125.2511 -0.5530 -55.2814 322.9819 4.2181 607.2473;
      -122.4519 36.6453 4.3547 -244.7954 208.0087 3.9365 600.4441;
      -120.6859 -34.4565 -4.9014 -252.5755 -211.8783 -3.0128 605.9031;
       24.7769 -125.0489 -4.8473 -53.9678 -320.6115 4.3181 604.5251;
       91.3462 -80.9866 0.2515 302.4266 -109.4351 3.3812 600.0616;]';


ns = nk(1:3,:); %nominal s
nu = nk(4:6,:);% nominal u
nl = nk(7,:); %nominal Leg length
rs = rk(1:3,:);%real s
ru = rk(4:6,:);%real k
rl = rk(7,:);%real l

%The centers of the spheres will be displaced from the point of contact of
%the base and are give by si - ui
%csn = sphere centers from the nominal values 
 csn = nu - ns;
%Since the workspace we need is a plane at height 800 we consider the
%workspace as circle than spheres (with radius lmax)
rwc = sqrt(lmax.^2- 800.^2);

%Intersection points of the circle are found an the ones that lie inside
%the workspace are chosen
ip = [];
for i = 1:5
    [x,y]= circcirc(csn(1,i), csn(2,i),rwc,csn(1,i+1), csn(2,i+1),rwc);
    for i =1:2
    ip = vertcat(ip,[x(i),y(i)]);
    i = i+1;
    end
end
[x,y] = circcirc(csn(1,1), csn(2,1),rwc,csn(1,6), csn(2,6),rwc);
    for i =1:2
    ip = vertcat(ip,[x(i),y(i)]);
    end
    ip;
%To check if the points ;lie in the circle we run a loop to test if those
%point lie inside or on the boundary of the 6 circles
pts = [];
for i=1:12
    for j=1:6
        if ((( csn(1,j)- ip(i,1))^2 + (csn(2,j) -ip(i,2))^2) <= (rwc)^2)
        if j== 6
        pts = vertcat(pts,[ip(i,1),ip(i,2)]);
        end
        end
  
   end
end


%Divivding the mesh in steps of 5mm 
%The xmax and xmin is being considered. The points of intersection points
%calcuklated previously are taken for the max 
xr = -865:5:967;
yr = -838:5:838;
mesh_pts = [];
graph = NaN(size(xr,2),size(yr,2));
for i = 1:size(xr,2)
    for j = 1:size(yr,2)
        ct = 0;
        for k = 1:6
            if (((xr(i)-csn(1,k))^2 + (yr(j)-csn(2,k))^2) <= (rwc)^2)
                ct = ct + 1;
            end
        end
        if (ct >= 6)
            mesh_pts = vertcat(mesh_pts,[xr(i),yr(j)]);
            graph(i,j) = 1;
        end
    end
end
mesh_pts;
 
%Plots the worksoace plane at height Z= 800
figure
plot(mesh_pts(:,1),mesh_pts(:,2),'r*')
title("Workspace Plane of the Hexapod at Height 800")

%error in parameters (real - nominal) (6x7)
dp = [ (rs-ns)' (ru-nu)' (rl-nl)'] ;
%the size of mesh point gives us the possible end effector positions for
%the hexapod. The size of it would give us the number of possible positions
%on the workspace plane reachable by the end effector.
for i = 1:size(mesh_pts)
%The P aka the pose matrix is created using the X and Y from the mesh
%points  and the height Z is taken as 800 and the Euler angles a b c are
%considered 0. So for every point in the workspace:
    p(:,i) = [mesh_pts(i,1),mesh_pts(i,2),800,0,0,0];
    [l n R] = IK1P3(p(:,i),ns,nu);
    Jv = [ n' cross(R*rs,n)'];
    si = length (n);
    A =  (-1).* ones(6,1);
    Js = [ n'*R (-1)*n' A];
    Jvi = pinv(Jv);
    %Converting the jacobian in into 6x42 for matrix multiplication
    Jsc = [ Js(1,:) zeros(1,35);
             zeros(1,7) Js(2,:) zeros(1,28); 
             zeros(1,14) Js(3,:) zeros(1,21);
             zeros(1,21) Js(4,:) zeros(1,14);
             zeros(1,28) Js(5,:) zeros(1,7);
             zeros(1,35) Js(6,:);];
    %Reshaping it to 42x1 for matrix multiplication
    dp = reshape(dp.',1,[]);
    %Equation 9 from the paper
    ep = Jvi*(0 - (Jsc*dp'));
    %RSS is the residual sum of squares is used to measure variance in the
    %data 
    RSS(i) = sqrt(ep(1)^2 + ep(2)^2 + ep(3)^2);
end

% The Surf plot gives us the error plot

figure
plot3(mesh_pts(:,1),mesh_pts(:,2),RSS)
title("Error Plot")
rss_map = 1;
[graph_x,graph_y] = size(graph);
for i = 1:graph_x
    for j = 1:graph_y
        if graph(i,j) == 1
            graph(i,j) = RSS(rss_map);
            rss_map = rss_map + 1; 
        end
    end
end
surfc(xr,yr,graph','LineStyle',"none")
title("Surf Plot for the RSS Error")

disp ["Intersection Points of the Circle inside the workspace is given by pts:"]
pts

        disp ["Equations at the height Z= 800 are given in the pdf"]


