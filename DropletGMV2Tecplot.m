%face omar: javier gutierrez

%Ojo al "bug" de las zonas a la hora de fusionar con la malla
    %Toca hacer que las zonas sin gotas queden vac?as para tenerlas en
    %cuenta
%Toca corregir el c?digo para que queden tracersX, tracersY, tracersZ a
%pesar de que no haya gotas para plotear.
function [y]=DropletGMV2Tecplot()
keywords={'tracers' 'u_vel' 'v_vel' 'w_vel' 'temp' 'radius' 'spwall'};
tipos=[1 0 0 0 0 0 0];
%Incluir la funci?n para que encuentre todos los archivos
MaximoSize=ScanMaxFile();
Maximo=MaximoSize(1);
Tamano=MaximoSize(2);
archivo=['plotgmv' strrep(num2str(zeros(1,Tamano)),' ','')];
%archivo='plotgmv09';
y=ScanArchivo(keywords,archivo,tipos);
    fid=fopen('DropletGMV2TECPLOT.dat','wt+');
    fprintf(fid, '   TITLE = "Archivo convertido de GMV a Tecplot DropletGMV2TECPLOT 1.0"\n');
    Variables=[];
    %%%%%%%%%%
    for i=1:size(keywords,2)
        Variables=[Variables '"' char(keywords(i)) '",'];
    end
    fprintf(fid, ['    VARIABLES =' Variables '\n']);
    fclose(fid);
    %%%%%%%%%%
%if ~isempty(y) %En caso de no encontrar archivo
    %%%%%%%%%%%%%%%      maquillaje(y,)
    for i=1:Maximo
        i
        %Cambia el nombre de archivo para que lo escanee
        chain=num2str(i);
        archivo(size(archivo,2)-size(chain,2)+1:size(archivo,2))=chain;
        y=ScanArchivo(keywords,archivo,tipos);
        if isempty(y);continue; end %En caso de no encontrar archivo
        maquillaje(y,i)
    end
%end %En caso de no encontrar archivo
end
function MaximoSize=ScanMaxFile()
    y=dir;
    Vector=[];
    Maximo=-1;
    for i=3:size(y,1)
        if size(y(i).name,2)>7
            if strcmp(y(i).name(1:7),'plotgmv')
                if ~strcmp(y(i).name,'plotgmv_mesh')
                    Vector=[Vector i];%Pulir este detallito
                end
            end
        end
    end
    for i=Vector
        Maximo=max(Maximo,str2double(y(i).name(8:end)));
    end
    MaximoSize=[Maximo size(y(i).name(8:end),2)];
end
function y=ScanArchivo(keywords,archivo,tipos)
    cont=1;
    fid=fopen(archivo);
    y=[];
    if fid<0
        disp('Archivo no encontrado u otro error');
        return;
    end
    for i=1:size(keywords,2)
        test=SacaParam(fid,keywords{1,i},0);
        if TestEOF(fid)
            return;%Salgase en caso de EOF
            fclose(fid);
        end 
        isempty(test{1,1});
        while isempty(test{1,1})
            if TestEOF(fid)
                return;%Salgase en caso de EOF
            end 
            test=SacaParam(fid,keywords{1,i},1);
            %i=i+1
        end
        ConvSpec='%f %f %f %f %f %f %f %f %f %f';%Cambiar en la migraci?n para cell
        %Ac? aplicar funci?n CambioFormato para las salidas
        TmpMtx=SacaNum(fid,ConvSpec,0);
        if tipos(i)==1||tipos(i)==3
            salida=CambioFormato(keywords{i},tipos(i),TmpMtx,test{1,2}{1});
            cont=cont+3;
        else
            salida(cont).Keyword={keywords{i}};
            salida(cont).Param=test{1,2}{1};
            salida(cont).Tipo=tipos(i);
            salida(cont).Mtx=TmpMtx;
            cont=cont+1;
        end
    end
    y=salida;
end
function maquillaje(StruData,Paso)
    %Asegurarse de limpiar los NAN
    fid=fopen('DropletGMV2TECPLOT.dat','a');
    fprintf(fid,['ZONE T= "PASO      ' num2str(Paso) '" DATAPACKING=BLOCK  I=' num2str(StruData(1).Param) '\n']);
    for i=1:size(StruData,2)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Cadena=['\n'];
        for j=1:size(StruData(1).Mtx,2)
            Cadena=[' %+12.4E' Cadena];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf(fid,Cadena,StruData(i).Mtx(1:end-1,:)');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Cadena=['\n'];
        for j=1:max(find(~isnan(StruData(1).Mtx(end,:))))
            Cadena=[' %+12.4E' Cadena];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf(fid,Cadena,StruData(i).Mtx(end,1:j)');
    end
    fclose(fid);
end
function y=CambioFormato(keyword,tipo,TmpMtx,Param)
%     if tipo==0 %Nodal
%         y(i).Keyword=keyword;
%         y(i).Mtx=TmpMtx;
%         y(i).Param=Param;
%         y(i).Tipo=tipo;
%     end
    if tipo==1 %Nodal xyz
        Numdata=ceil(Param/size(TmpMtx,2));
        chain=struct('data',{'X' 'Y' 'Z'});
        for i=1:1:3
            y(i).Keyword=[keyword chain(i).data];
            y(i).Mtx=TmpMtx(Numdata*(i-1)+1:1:i*Numdata,:);
            y(i).Param=Param;
            y(i).Tipo=tipo;
        end
    end
    if tipo==2 %Cell centered ?se necesita?
    end
    if tipo==3 %Conectividades
    end
end
function Mtx=SacaNum(fid,ConvSpec,HeaderLines)
%'HeaderLines' n?mero de l?neas a saltar
%textscan(fopen('plotgmv09'),'%f %f %f %f %f %f %f %f %f %f','HeaderLines',2)
%textscan(fopen('plotgmv09'),'nodes %f','HeaderLines',1)
%Evaluar la conveniencia de usar la opci?n CollectOutput de textscan
    Mtx=cell2mat(textscan(fid,ConvSpec,'HeaderLines',HeaderLines,'CollectOutput',1));
end
function Celda=SacaParam(fid,keyword,HeaderLines)
%Busque y capture algo que se parezca al keyword de entrada
    TmpCell=textscan(fid,['%[' keyword ']' '%f \n'],'HeaderLines',HeaderLines);
    if ~strcmp(TmpCell{1,1},keyword) %Mire si el par?metro es coincidente
        TmpCell=cell(1,2);%Si no es coincidente devuelva una cell vac?a
    end
    %textscan('  qwerta 134','%*s %f')
    Celda={TmpCell{1,1} {TmpCell{1,2}}};
end
function y=TestEOF(fid)
%aunque matlab recomienda usar fgetl esta corre el punto de lectura del
%archivo entonces se opt? por la l?nea descomentada pero no por el uso de
%fgetl. Se escribe esta funci?n en caso de que se tenga que corregir alg?n
%fallo relacionado con que se quede leyendo un archivo. Por ahora funciona
%bien.

%     tline = fgetl(fid);
%     if ~ischar(tline);
%         disp('wtf');
%     end
%     y=~ischar(tline);
    y=feof(fid);
end