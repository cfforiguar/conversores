function []=datX()
%dir: para listar todo de forma chevere y de paso buscar
%cd: 
%pwd: Para listar el path actual
%Legend: Para ponerle colorsitos a los ploteos
%fullfile: Para crear las cadenas de archivos
%y=dir('*plotgmv*');str2num(y(19,1).name(8:end))
clc
    y=dir;
    %colores=['r' 'g' 'b' 'c' 'm' 'y' 'k'];
    colores=['+' 'o' '*' '.' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'];
    cont=1;
    handle=0;
    s={};
    for i=3:size(y,1) %comienza en 3 por que los primeros 3 directorios son "." y ".."
        if getfield(y(i,1),'isdir')
            cd(fullfile(pwd,getfield(y(i,1),'name')));
            Salida=datX2;
            Unidades=Salida{1,:};
            Labels=Salida{2,:};
            Mtx=cell2mat(Salida{3,:});
            for n=2:size(Labels,2)
                handle=handle+1;
                FigHandle(handle)=figure(n-1);
                PlotHandle(handle)=plot(Mtx(:,1),Mtx(:,n),colores(cont));% Si hay muchas carpetas por ac� se cae: se acaban los colores
                %set(PlotHandle(handle),'userdata',y(i,1).name);
                s{handle}=y(i,1).name;
                hold on;
                plot(Mtx(:,1),Mtx(:,n));
                xlabel([Labels{1} '[' Unidades{1} ']']);
                ylabel([Labels{n} '[' Unidades{n} ']']);
                hold on;
                grid;
            end
            pwd
            cd('..');
            cont=cont+1;
        end
    end
    for i=1:size(PlotHandle,2)/(cont-1)
       Vector=int8([0:size(PlotHandle,2)/(cont-1):size(PlotHandle,2)*(1-1/(cont-1))]);
       legend(PlotHandle(Vector+i),s(Vector+i),'Location','SouthOutside');
       Nombre=regexp(get(get(get(FigHandle(i),'CurrentAxes'),'YLabel'),'String'),'\w+','match');
       saveas(FigHandle(i),cell2mat(Nombre(1)),'jpg');
       saveas(FigHandle(i),cell2mat(Nombre(1)),'fig');
    end
end
function Celda=datX2()
% Saca los datos de las funciones dat.xxx y las plotea
    archivo='dat.dynamic';
    fid=fopen(archivo,'r');
    cont=1;
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        if cont==1
            Unidades=minador(' ',tline,4);
            cont=2;
        elseif cont==2
            Labels=minador(' ',tline,4);
            cont=3;
        end
        dato=minador(' ',tline,1);
        if ~isempty(dato)
            Mtx(cont-2,:)=cell2mat(cell2double(dato));
            cont=cont+1;
        end
    end
    %Celda={Unidades;Labels;mat2cell(Mtx)};
    Celda={Unidades;Labels;{Mtx}};
%     for i=2:size(Labels,2)
%         figure
%         plot(Mtx(:,1),Mtx(:,i));
%         xlabel([Labels{1} '[' Unidades{1} ']']);
%         ylabel([Labels{i} '[' Unidades{i} ']']);
%         grid
%     end
end
function y=cell2double(Celda)
%Uso: cell2double(Celda{1,2}{1})
    for i=1:1:size(Celda,1)
        for j=1:1:size(Celda,2)
            Celda{i,j}=str2double(Celda{i,j});
        end
    end
    y=Celda;
end
function y=minador(Keyword,str,Case_Mtx)
%Saca los datos de acuerdo a los par�metros de entrada. Saca los datos para
%los valores nu�ricos, matriz de conectividades y caracter�sticas de las
%variables (n�mero de nodos, n�m de celdas y tipo de variable-nodal, cell centered-)
    switch Case_Mtx
        case 0
        %Genera una expresi�n regular con la palabra clave keyword
        %Sirve para los casos el tipo "nodes 234324" donde genera la salida
        %de la variable y = 234324
        RegExpr=strcat('(?<=',Keyword,' +)\d+');
        case 1
        %Genera una expresi�n regular para sacar los n�meros de las
        %cadenotas de n�meros en formato double que aparecen en las
        %posiciones nodales, velocidades, etc.
        RegExpr='\<(-|)\d+.\d+E.\d+';
        case 2
        %Genera una expresi�n regular para quitar expresiones de tipo 
        %"hex     8" en la matriz de conectividades como por ejemplo:
        %hex      8    152    154    169    168    283    285    300    299
        %Funciona simplemente cogiendo los valores num�ricos que son 
        %antecedidos por n�meros y no por letras.
        RegExpr='(?<= +\d+ +)\d+';
        case 3
        %Genera una expresi�n regular con la palabra clave keyword
        %Sirve para los casos el tipo "var 23.E+4324" donde genera la salida
        %de la variable y = 23.E+4324 (fusion de los casos 0 y 1)
        RegExpr=strcat('\s(?<=','\<',Keyword,' +)\d+.\d+E.\d+');
        case 4
        %Saca las palabras y quita los espacios.
        RegExpr=strcat('\<\S+');
    end
    %Coje la expresi�n regular y saca los valores que coinciden con la
    %misma.
    y=regexp(str,RegExpr,'match');
end