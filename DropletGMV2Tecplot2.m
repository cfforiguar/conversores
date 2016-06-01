function [y]=DropletGMV2Tecplot2()
keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl' 'totmass' 'tracers' 'u_vel' 'v_vel' 'w_vel' 'temp' 'radius' 'spwall'};
tipos=zeros(size(keywords));
tipos([1 3])=1;%Para que lea los nodos y velocidades como node-centered
tipos(size(keywords,2)-6:size(keywords,2))=[1 0 0 0 0 0 0];
%Incluir la funci�n para que encuentre todos los archivos
MaximoSize=ScanMaxFile();
Maximo=MaximoSize(1);
Tamano=MaximoSize(2);
archivo=['plotgmv' char([0 0]+48)];
%archivo='plotgmv09';
y=ScanArchivo(keywords,archivo,tipos);
    Nombrearchivo='DropletGMV2TECPLOT-P.tec';
    fid=fopen(Nombrearchivo,'wt+');
    fprintf(fid, '   TITLE = "Convertido de GMV a Tecplot y paraview DropletGMV2TECPLOT 2.2"\n');
    Variables=[];
    %%%%%%%%%%
    temperFlag=0;
    for i=1:size(keywords,2)
        if strcmp(keywords{i},'velocity')||strcmp(keywords{i},'tracers')%Para la velocidad ó tracers ó similares
            Variables=[Variables '"' char(keywords(i)) 'X"' ',"' char(keywords(i)) 'Y"' ',"' char(keywords(i)) 'Z",'];
        elseif strcmp(keywords{i},'nodes')
            Variables=[Variables '"x"' ',"y"' ',"z",'];
        elseif strcmp(keywords{i},'temp')%Para que no haya 2 variables "temp" en la lista de variables
          temperFlag=temperFlag+1;
          if temperFlag==2
            Variables=[Variables '"tempDrop",'];3
          end
        else
            Variables=[Variables '"' char(keywords(i)) '",'];
        end
    end
    fprintf(fid, ['    VARIABLES =' Variables '\n']);
    fclose(fid);
    %%%%%%%%%%
%if ~isempty(y) %En caso de no encontrar archivo
    %%%%%%%%%%%%%%%      maquillaje(y,)
    for i=0:Maximo
        i
        %Cambia el nombre de archivo para que lo escanee
        archivo=['plotgmv' char([floor(i/10) mod(i,10)]+48)];
        y=ScanArchivo(keywords,archivo,tipos);
        if isempty(y);continue;end %En caso de no encontrar archivo
        maquillaje(y,i,Nombrearchivo)
        if i==7
            disp('test')
        end
    end
%end %En caso de no encontrar archivo
end
function MaximoSize=ScanMaxFile()
    y=dir;
    Maximo=0;
    for i=3:size(y,1)
      if size(y(i).name,2)>7
        if strcmp(y(i).name(1:7),'plotgmv')
          if ~strcmp(y(i).name,'plotgmv_mesh')
              Maximo=max(Maximo,...
                          dot([10,1],...
                           [double(y(i).name(8)) double(y(i).name(9))]-48));
          end
         end
      end
    end
    MaximoSize=[Maximo 2];
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
        while isempty(test{1,1})
            if TestEOF(fid)
                y=[];
                if i<size(keywords,2)
                    disp(['keywords{} No ' num2str(i) ' no encontrado. Lectura de archivo omitida'])
                end 
                return;%Salgase en caso de EOF
            end 
            test=SacaParam(fid,keywords{1,i},1);
            %i=i+1
        end
        ConvSpec='%f %f %f %f %f %f %f %f %f %f';%Cambiar en la migraci�n para cell
        if strcmp(keywords{1,i},'cells')
            ConvSpec='hex %*f %f %f %f %f %f %f %f %f';
        end
        %Ac� aplicar funci�n CambioFormato para las salidas
        TmpMtx=SacaNum(fid,ConvSpec,0);
        if tipos(i)==1||tipos(i)==3
            if strcmp(keywords{i},'velocity')
                salida(cont:cont+2)=CambioFormato(keywords{i},tipos(i),TmpMtx,salida(1).Param);
            else
                salida(cont:cont+2)=CambioFormato(keywords{i},tipos(i),TmpMtx,test{1,2}{1});
            end
            cont=cont+3;
        else
            salida(cont).Keyword={keywords{i}};
            salida(cont).Mtx=TmpMtx;            
            salida(cont).Param=test{1,2}{1};
            salida(cont).Tipo=tipos(i);
            cont=cont+1;
        end
    end
    y=salida;
end
function maquillaje(StruData,Paso,Nombrearchivo)
    fid=fopen(Nombrearchivo,'a');
    fprintf(fid,['ZONE T= "PASO      ' num2str(Paso) '" ' '\n']);
    fprintf(fid,[' STRANDID=2, SOLUTIONTIME=' num2str(Paso) '\n']);
    fprintf(fid,[' DATAPACKING=BLOCK  I=' num2str(StruData(size(StruData,2)-8).Param) ', J=1, K=1 \n']);
    %Se declaran como pasivas todas las variables excepto x,y,z y 'u_vel' 'v_vel' 'w_vel' 'temp' 'radius' 'spwall'
    %tracersX, tracersY y tracersZ son asignadas como pasivas y sus valores
    %serán asignados a x,y,z
    fprintf(fid,[' PASSIVEVARLIST=[' num2str(4) '-' num2str(size(StruData,2)-6) '] \n']);
    
    %Los valores de  tracersX, tracersY y tracersZ son asignados a x,y,z
    %Las variables restantes se escriben igual
    for i=[size(StruData,2)-8:size(StruData,2)]
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Cadena=['\n'];
        if StruData(i).Tipo==2
            Formato=' %u';
        else
            Formato=' %+12.4E';
        end
        for j=1:size(StruData(i).Mtx,2)
            Cadena=[Formato Cadena];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf(fid,Cadena,StruData(i).Mtx(1:end-1,:)');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Cadena=['\n'];
        for j=1:find(~isnan(StruData(i).Mtx(end,:)), 1, 'last' )
            Cadena=[Formato Cadena];
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
    if tipo==2 %Cell centered �se necesita?
        Numdata=ceil(Param/size(TmpMtx,2));
        for i=1:1:3
            y(i).Keyword=[keyword];
            y(i).Mtx=TmpMtx(Numdata*(i-1)+1:1:i*Numdata,:);
            y(i).Param=Param;
            y(i).Tipo=tipo;
        end
    end
    if tipo==3 %Conectividades
        
    end
end
function Mtx=SacaNum(fid,ConvSpec,HeaderLines)
%'HeaderLines' n�mero de l�neas a saltar
%textscan(fopen('plotgmv09'),'%f %f %f %f %f %f %f %f %f %f','HeaderLines',2)
%textscan(fopen('plotgmv09'),'nodes %f','HeaderLines',1)
%Evaluar la conveniencia de usar la opci�n CollectOutput de textscan
    Mtx=cell2mat(textscan(fid,ConvSpec,'HeaderLines',HeaderLines,'CollectOutput',1));
end
function Celda=SacaParam(fid,keyword,HeaderLines)
%Busque y capture algo que se parezca al keyword de entrada
    TmpCell=textscan(fid,[ keyword '%f\n'],'HeaderLines',HeaderLines);
    if isempty(TmpCell{1,1})%Mire si el par�metro es coincidente
        Celda=cell(1,2);%Si no es coincidente devuelva una cell vac�a
    else
    %textscan('  qwerta 134','%*s %f')
    Celda={{keyword} TmpCell};
    end
end
function y=TestEOF(fid)
%aunque matlab recomienda usar fgetl esta corre el punto de lectura del
%archivo entonces se opt� por la l�nea descomentada pero no por el uso de
%fgetl. Se escribe esta funci�n en caso de que se tenga que corregir alg�n
%fallo relacionado con que se quede leyendo un archivo. Por ahora funciona
%bien.

%     tline = fgetl(fid);
%     if ~ischar(tline);
%         disp('wtf');
%     end
%     y=~ischar(tline);
    y=feof(fid);
end