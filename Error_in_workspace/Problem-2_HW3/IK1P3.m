%Inverse Kinematics of Parallel Robots with Prismatic Legs

function [l n R S] = IK1P3(P,s,u)

%% Desired Pose (Given)
%P = [10 20 150 7 3 5]';
%P = [ 10.0000 20.0000 150.0000 0.0961 0.2000 0.3039]';


%% Robot Parameters (Given)
Rm=250/2;
Rf=650/2;
alpha=40*pi/180;
beta=80*pi/180;

%% Extracting Position and Euler Angle Information from the given desired pose

o=P(1:3,1); 
a=P(4)*pi/180; 
b=P(5)*pi/180; 
c=P(6)*pi/180;

%% Calculating Rotation Matrix from Euler Angles

R1=[1,0,0;0,cos(a),-sin(a);0,sin(a),cos(a)]; % Rx,a
%R1=[cos(a),-sin(a),0;sin(a),cos(a),0;0,0,1]; % Rz,a
R2=[cos(b),0,sin(b);0,1,0;-sin(b),0,cos(b)]; % Ry,b
R3=[cos(c),-sin(c),0;sin(c),cos(c),0;0,0,1]; % Rz,c

%R = R1*R2*R3; % Rxyz
R = R1*R2*R3; % Rzyz

%% Calculating upper joint positions wrt. the upper coordinate frame

%s1=[Rm*cos(beta/2) , Rm*sin(beta/2), 0]';
%s2=[-Rm*sin(pi/6-beta/2) , Rm*cos(pi/6-beta/2), 0]';
% s3=[-Rm*sin(pi/6+beta/2) , Rm*cos(pi/6+beta/2), 0]';
% s4=[-Rm*cos(pi/3-beta/2) , -Rm*sin(pi/3-beta/2), 0]';
% s5=[-Rm*cos(pi/3+beta/2) , -Rm*sin(pi/3+beta/2), 0]';
% s6=[Rm*cos(beta/2) , -Rm*sin(beta/2), 0]';

S = [s(:,1) , s(:,2) , s(:,3), s(:,4) , s(:,5) , s(:,6)];

%% Calculating lower joint positions wrt. the lower corrdinate frame
1

% u1=[Rf*cos(alpha/2) , Rf*sin(alpha/2), 0]';
% u2=[-Rf*sin(pi/6-alpha/2) , Rf*cos(pi/6-alpha/2), 0]';
% u3=[-Rf*sin(pi/6+alpha/2) , Rf*cos(pi/6+alpha/2), 0]';
% u4=[-Rf*cos(pi/3-alpha/2) , -Rf*sin(pi/3-alpha/2), 0]';
% u5=[-Rf*cos(pi/3+alpha/2) , -Rf*sin(pi/3+alpha/2), 0]';
% u6=[Rf*cos(alpha/2) , -Rf*sin(alpha/2), 0]';
 
U = [u(:,1) , u(:,2) , u(:,3) , u(:,4) , u(:,5) , u(:,6)];


%% Put it in the IK equation

for i = 1:6
    L (: , i) = o + R * S(: , i) - U (: , i);
    l(i) = norm (L (: , i));
    n(:,i) = L (: , i)/l(i);

end