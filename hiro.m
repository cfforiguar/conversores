%de la parte m�s exterior del taz�n de derecha al centro
%Medidas en mil�metros
function [y]=hiro()
clear all
paso_c=.01;
paso_r=.01;
%x_cc1
m_r1=tand(85);
x_r=28.35;
y_r=0;
y_cc1=-10.7;
r_c1=9;
x_cc2=0;
y_cc2=-10.4;
r_c2=4.4;
DataAcople1=AcopleR_C(m_r1,x_r,y_r,y_cc1,r_c1,'arriba');
x_cc1=DataAcople1(1);
DataAcople2=AcopleC_R_C(x_cc1,y_cc1,r_c1,x_cc2,y_cc2,r_c2);
x1=0:paso_c:DataAcople2(2);
x2=x1(end-1):paso_r:DataAcople2(4);
x3=x2(end-1):paso_c:DataAcople1(2);
x4=x3(end-1):paso_c:x_r;
y1=circulo(x_cc2,y_cc2,4.4,x1,'arriba');
y2=recta(DataAcople2(1),DataAcople2(2),DataAcople2(3),x2);
y3=circulo(x_cc1,y_cc1,9,x3,'abajo');
y4=recta(m_r1,x_r,y_r,x4);
%plot([x1 x2 x3 x4],[y1 y2 y3 y4])
tmp=EscogePuntos(x_r,23,19.7,13,9,[x1 x2 x3 x4],[y1 y2 y3 y4],0.2);
tmp(:,2)=tmp(:,2)-min(tmp(:,2));
plot(tmp(:,1),tmp(:,2),'+');
y=tmp;
end
function ptos=EscogePuntos(MaxX,MaxX2,MaxZ,NumPtosX,NumPtosZ,x,z,Ajuste)
    EspX1=(MaxX2)/(NumPtosX);
    coord=ones(1,NumPtosX+NumPtosZ);
    for i=2:1:NumPtosX
        coord(i)=find(x>x(coord(i-1))+EspX1,1,'first');
    end
    % Escogiendo los segundos 11 puntos (avanzo en z)
    EspZ1=MaxZ/(NumPtosZ+1)-Ajuste;
    for i=(NumPtosX+1):1:(NumPtosX+NumPtosZ)
        %coord(i)=find(z(coord(i-1):1:end)<z(coord(i-1))+EspZ1,1,'first');
        coord(i)=coord(i-1)+find(z(coord(i-1):1:end)>z(coord(i-1))+EspZ1,1,'first');
    end
    %plot(x(coord),z(coord))
    Topex=MaxX:-MaxX/(NumPtosX):0;
    Topez=zeros(1,size(Topex,2));
    nbox=[x(coord) Topex]';
    nboz=[z(coord) Topez]';
    %plot(nbox,nboz,'+');
    ptos=[nbox nboz]/10;
end
function y=circulo(x0,y0,r,x,caso)
switch caso
    case 'arriba'
        y=(r.^2-(x-x0).^2).^(.5)+y0;
    case 'abajo'
        y=-(r.^2-(x-x0).^2).^(.5)+y0;
end
end
function y=recta(m,x0,y0,x)
    y=m.*(x-x0)+y0;
end
function y=AcopleR_C(m,x_r,y_r,y_cc,r_c,concavidad)
% Halla coord x del centro del de radio conocido c�rculo que acopla 
% con una recta conocida
%m Pendiente de la recta
%x_r Coordenada x de la recta
%y_r Coordenada y de la recta
%x_cc Centro de la circunferencia x
%y_cc Centro de la circunferencia y
%r_c Radio del c�rculo
switch concavidad
case 'abajo'
    t0=180-tand(m);
case 'arriba'
    t0=360-tand(m);
end;
PtoAcopleY=(y_cc+r_c*sind(t0));
x_acople=(1/m)*(PtoAcopleY-y_r)+x_r;
xcc=x_acople-r_c*cosd(t0);
y=[xcc x_acople PtoAcopleY];
end
function [y]=AcopleC_R_C(x_cc1,y_cc1,r_c1,x_cc2,y_cc2,r_c2)
%m Pendiente de la recta
%x_cc Centro de la circunferencia x
%y_cc Centro de la circunferencia y
%r_c Radio del c�rculo
DeltaX=x_cc1-x_cc2;
DeltaY=y_cc1-y_cc2;
H1=sqrt(DeltaX^2+DeltaY^2)/(1+r_c2/r_c1);%Trigonometr�a, es una de las 
% hipotenusas que se forman cuando se intersecta la l�nea tangente a los 2
% c�rculos con la recta que une los centros de los 2 c�rculos
theta2=asind(-r_c1/H1);
theta1=360+rad2deg(atan2(DeltaY,DeltaX));
m=tand(theta2+theta1);
t_c1=theta2+theta1+270;
t_c2=theta2+theta1+90;
x_f=r_c1*cosd(t_c1)+x_cc1;
y_f=r_c1*sind(t_c1)+y_cc1;
x_i=r_c2*cosd(t_c2)+x_cc2;
y_i=r_c2*sind(t_c2)+y_cc2;
y=[m x_i y_i x_f y_f];
end