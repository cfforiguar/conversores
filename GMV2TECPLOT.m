% GMV2TECPLOT(nodes,'plotgmv00',0)
function []=GMV2TECPLOT()
    %%%%%%%%%%%%%%%%%
    %Entradas
    archivo='plotgmv00';
    keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl' 'fuel' 'O2' 'N2' 'H' 'H2' 'OH' 'CH3'};
    %keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl' 'er' 'totmass'};
    %keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl' 'er' };
    %keywords={'nodes' 'cells'};
    %keywords={'nodes' 'cells' 'pressure' 'temp' 'density' 'tke' 'scl' 'er' 'totmass'};
    %Tst1
    %keywords={'nodes' 'cells' 'velocity'};%Ok
    %Tst2
    %keywords={'nodes' 'cells' 'velocity' 'pressure'};%Ok
    %Tst3
    %keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp'};%ok
    %Tst4
    %keywords={'nodes' 'cells' 'pressure' 'temp'};%ok
    index=1;
    clc
    %%%%%%%%%%%%%%%%%
    Variables=[];
    Celda=ScanArchivo(keywords,archivo);
    fid=fopen('GMV2TECPLOT.dat','wt+');
    for i=1:size(keywords,2)
        if str2double(Celda{1}{i})==0
            %Valores de tipo cell centered: presi�n, temp, etc
            Variables=[Variables ',"' keywords{i} '"'];
        end
        if str2double(Celda{1}{i})==1
            %Valores de tipo nodal ej:velocidad
            Variables=[Variables ',"' keywords{i} 'X"' ',"' keywords{i} 'Y"' ',"' keywords{i} 'Z"'];
        end
        if str2double(Celda{1}{i})>1&&i~=2
            %Nodos (se deja aparte por conveniencia)
            Variables=[Variables '"x"' ',"y"' ',"z"'];
        end
    end
    fprintf(fid, '   TITLE = "Archivo convertido de GMV a Tecplot GMV2TECPLOT 1.0"\n');
    fprintf(fid, ['    VARIABLES =' Variables '\n']);
    fclose(fid);
    maquillaje(keywords,Celda,0,0);
    for i=1:index
        %Cambia el nombre de archivo para que lo escanee
        chain=num2str(i)
        archivo(size(archivo,2)-size(chain,2)+1:size(archivo,2))=chain
        %Escanea el nuevo archivo
        Celda=ScanArchivo(keywords,archivo);
        %Escribe los valores cargados
        maquillaje(keywords,Celda,0,i)
    end
    %ClearNAN('GMV2TECPLOT.dat')
    disp('funci�n agonia')
end
function []=ClearNAN(StrArchivo)
    while 1
        fid=fopen(StrArchivo,'a');
        tline = fgetl(fid);
        if ~ischar(tline), break, end %cuando llegue a EOF s�lgase
        tline = regexprep(tline,' nan ','','ignorecase');
    end
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
function []=maquillaje(keywords,Celda,Compartida,Paso)
%Compartida=1 en caso de que sea malla compartida
%Paso es el paso en el que va
    fid=fopen('GMV2TECPLOT.dat','a');
    CellCenter=[];
    if Compartida==0
        for i=1:size(Celda{1},2)
            if str2double(char(Celda{1}{i}))==0
                if strcmp(char(keywords{3}),'velocity')
                    CellCenter=[CellCenter ' ' num2str(i+3)]; %Por que posici�n y velocidad son 6 variables ocupa la 7ma pos en adelante
                else
                    CellCenter=[CellCenter ' ' num2str(i+1)]; %Por que posici�n son 3 variables ocupa la 4ta pos en adelante
                end
            end
        end
        if ~isempty(CellCenter)
            CellCenter=[', VARLOCATION=([' CellCenter ']=CELLCENTERED) '];
        end
        fprintf(fid, ['ZONE T= "PASO      ' num2str(Paso) '"   N=' char(Celda{1}{1}) ',   E=' char(Celda{1}{2}) ',   F=FEBLOCK,  ET=BRICK' CellCenter '\n']);
        for i=1:size(keywords,2)
            if i~=2
                %haga la cadena de acuerdo al tama�o de cada Cell
                Cadena=['\n'];
                for j=1:size(Celda{1,2}{1,i},2)
                    Cadena=[' %+12.4E' Cadena];
                end
                fprintf(fid,Cadena,cell2mat(cell2double(Celda{1,2}{1,i}))'); %la comilla para qu� se pone-pw se transpone la matriz-?
            end
        end
        fprintf(fid, '%6d  %6d  %6d  %6d  %6d  %6d  %6d  %6d\n', cell2mat(cell2double(Celda{1,2}{1,2}))');
    else
        fprintf(fid, ['ZONE T= "PASO      ' num2str(Paso) '"   N=' char(Celda{1}{1}) ',   E=' char(Celda{1}{2}) ',   F=FEBLOCK,  ET=BRICK, D=(1,2,3,FECONNECT) \n']);
        %fprintf(fid, 'ZONE T= "PASO      1"   N=5832,   E=4913,   F=FEBLOCK,  ET=BRICK D=(1,2,3,FECONNECT) \n ');
        for i=3:size(keywords,2)
            %haga la cadena de acuerdo al tama�o de cada Cell
            Cadena=['\n'];
            for j=size(Celda{1,2}{1,i},2)
                Cadena=[' %12.4E' Cadena];
            end
            fprintf(fid,Cadena,cell2mat(cell2double(Celda{1,2}{1,i}))'); %la comilla para qu� se pone-pw se transpone la matriz-?
        end
    end
    fclose(fid);
end    
function CeldaTot=ScanArchivo(keywords,StrArchivo)
    %mandar un vector de palabras clave para que busque cuando las halle
    %saque la info clave que sea del caso y luego saque una matriz hasta que
    %le llegue una vac�a, si le llega una vac�a entonces busque la
    %siguiente palabra clave
    %keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl' 'er' 'totmass'}
    %keywords={'nodes'};
    fid=fopen(StrArchivo);
    %Inicializa la variables data y Celda de tipo cell
    data=cell(1,size(keywords,2));
    Celda=cell(1,size(keywords,2));
    i=1;
    j=1;
    %Flag que se usa para saber si ha pasado por cadenas tipo 'char #' ej:
    %cell 3466
    flag =0;
    ParamCell=1;%Parametro que se usa para saber si est� en la mtx de conectividad
    DimFlag=0;%Flag que se usa para dimensionar la matrices de n�meros
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end %cuando llegue a EOF s�lgase
        %keywords(i)
        %minador(char(keywords(i)),tline,0)
        if i>size(keywords,2),break, end %Si se acaba la cadena s�lgase
        numeros=minador(char(keywords(i)),tline,ParamCell); %Se demora 2.6 secs
        %numeros=str2num(tline); %Se demora 5.6 secs
        if ~isempty(numeros)
            if DimFlag==1
                DimHorizontal=size(numeros,2);
                Key=char(keywords{i});
                Num=char(data{i});
                %Este if dimensiona la celda seg�n sea el caso cell, nodal,
                %cell-centered
                if strcmp(Key,'nodes')||strcmp(Num,'1')
                    NumData=str2double(cell2mat(data{1}));
                    Celda{i}=cell(ceil(NumData/DimHorizontal)*3,DimHorizontal);
                elseif strcmp(Key,'cells')
                    NumData=str2double(cell2mat(data{2}));
                    Celda{i}=cell(NumData,DimHorizontal);
                elseif strcmp(Num,'0')
                    NumData=str2double(cell2mat(data{2}));
                    Celda{i}=cell(ceil(NumData/DimHorizontal),DimHorizontal);
                end
                DimCelda=size(Celda{i},1);
                DimFlag=0;
                Celda{i}(j,:)=numeros;
                j=j+1;
            else
                if j>=DimCelda
                    %Ac� es una fuente potencial de un bug. Ojo a los
                    %mensajes de TECPLOT diciendo que el n�mero de cells no
                    %es suficiente. Puede deberse a que se ha comido de 1 a
                    %3 l�neas de los nodos.
                    %if 
                    Celda{i}(j,1:1:size(numeros,2))=numeros;
                    j=j+1;
                    %%%%
                    keywords{i}
                    fprintf(' %12.4E %12.4E %12.4E %12.4E %12.4E %12.4E %12.4E %12.4E\n',cell2mat(cell2double(numeros)))
                    %%%%%
                    %Condicional para avanzar en las palabras clave que se quiere
                    %alcanzar usando el contador i
                    if flag
                        i=i+1;
                        flag=0;
                    end
                else
                    Celda{i}(j,1:1:size(numeros,2))=numeros;
                    j=j+1;
                end
            end
        else
            data{i}=minador(char(keywords(i)),tline,0);
            if ~isempty(char(data{i}))
                j=1;
                %flag de control para avanzar en la cadena
                flag=1;
                %flag de control para dimensionar la matriz.
                DimFlag=1;
                %Caso especial de la matriz de conectividades
                if strcmp(char(keywords{i}),'cells')
                    ParamCell=2;
                else
                    ParamCell=1;
                end
%                 TmpData=str2double(cell2mat(data{i}));
%                 if TmpData==0
%                     %Valores de tipo cell centered: presi�n, temp, etc
%                     NumData=str2double(cell2mat(data{2}));
%                 end
%                 if TmpData==1
%                     %Valores de tipo nodal ej:velocidad
%                     NumData=str2double(cell2mat(data{1}))*3;
%                 end
%                 if TmpData>1
%                     %cell{i}=zeros()
%                     if ParamCell==2
%                         NumData=str2double(cell2mat(data{i}))*8;
%                     else
%                         NumData=str2double(cell2mat(data{i}))*3;
%                     end
%                 end
            end
        end
%         %Condicional para avanzar en las palabras clave que se quiere
%         %alcanzar usabndo el contador i
%         if flag
%             i=i+1;
%             flag=0;
%         end
    end
    fclose(fid);
    CeldaTot={data Celda};
    %minador('nodes','nodes         3180',0)
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
