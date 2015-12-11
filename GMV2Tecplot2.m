%Ojo al "bug" de las zonas a la hora de fusionar con la malla
    %Toca hacer que las zonas sin gotas queden vac�as para tenerlas en
    %cuenta
%Toca corregir el c�digo para que queden tracersX, tracersY, tracersZ a
%pesar de que no haya gotas para plotear.
function [y]=GMV2Tecplot2()
%Stock
%keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl' 'totmass'};
%Workaround
keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl'};
%Tutorial
%keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl' 'totmass' 'IC8H18' 'O2' 'N2' 'CO2' 'H2O' 'H' 'H2' 'O' 'N' 'OH' 'CO' 'NO' 'CH4' 'CH3O' 'CH2O' 'HCO' 'CH3' 'C2H3' 'C2H4' 'C2H5' 'C3H4' 'C3H5' 'C3H6' 'C3H7' 'C7H16' 'C7H15' 'C7H15O2' 'C7H14OOH' 'O2C7H14OOH' 'C7KET' 'C5H11CO' 'C7H14' 'C8H17' 'C8H17O2' 'C8H16OOH' 'O2C8H16OOH' 'C8KET' 'C6H13CO' 'C8H16' 'H2O2' 'N2O' 'HO2' 'NO2' 'CH2OH' 'CH3OH' 'C2H2' 'CH2CO' 'HCCO'};
%Mech nuevo de Xi c8h18
%keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl' 'totmass' 'C8H18' 'O2' 'N2' 'CO2' 'H2O' 'H' ' H2' 'O' 'N' 'OH' 'CO' 'NO' 'HCO' 'H2O2' 'HO2' 'CH4' 'CH3O' 'CH2' 'CH3' 'C2H3' 'C2H4' 'C2H5' 'C3H4' 'C3H5' 'C3H6' 'CH2O' 'C3H7' 'C4H8' 'C8H17' 'C8H16' 'C8H17OO' 'C8H16OOH' 'OC8H15OOH' 'OOC8H16OOH' 'OC8H15O' 'N2O' 'NO2' 'AR'};
%Mech ic8h18:
%keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl' 'totmass'  'IC8H18' 'O2' 'N2' 'CO2' 'H2O' 'H' 'H2' 'O' 'N' 'OH' 'CO' 'NO' 'CH4' 'CH3O' 'CH2O' 'HCO' 'CH3' 'C2H3' 'C2H4' 'C2H5' 'C3H4' 'C3H5' 'C3H6' 'C3H7' 'C7H16' 'C7H15' 'C7H15O2' 'C7H14OOH' 'O2C7H14OOH' 'C7KET' 'C5H11CO' 'C7H14' 'C8H17' 'C8H17O2' 'C8H16OOH' 'O2C8H16OOH' 'C8KET' 'C6H13CO' 'C8H16' 'H2O2' 'N2O' 'HO2' 'NO2' 'CH2OH' 'CH3OH' 'C2H2' 'CH2CO' 'HCCO'};
%MechPatel:
%keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl' 'totmass' 'nc7h16' 'o2' 'n2' 'co2' 'h2o' 'h' 'h2' 'o' 'n' 'oh' 'co' 'no' 'h2o2' 'ho2' 'ch3o' 'ch2o' 'hco' 'ch2' 'ch3' 'ch4' 'c2h3' 'c2h4' 'c2h5' 'c3h4' 'c3h5' 'c3h6' 'c3h7' 'c7h15-2' 'c7h15o2' 'c7ket12' 'c5h11co'};
%keywords={'nodes' 'cells' 'velocity' 'pressure' 'temp' 'density' 'tke' 'scl' 'totmass' 'ch2o'};% 'hco' 'ch2' 'ch3' 'ch4' 'c2h3' 'c2h4' 'c2h5' 'c3h4' 'c3h5' 'c3h6' 'c3h7' 'c7h15-2' 'c7h15o2' 'c7ket12' 'c5h11co'};
tipos=[1 2 1 0 0 0 0 0 0 0 zeros(1,80)];
%Incluir la funci�n para que encuentre todos los archivos
MaximoSize=ScanMaxFile();
Maximo=MaximoSize(1);
Tamano=MaximoSize(2);
archivo=['plotgmv' char([0 0]+48)];
%archivo='plotgmv09';
y=ScanArchivo(keywords,archivo,tipos);
    Nombrearchivo='GMV2TECPLOT-P.tec';
    fid=fopen(Nombrearchivo,'wt+');
    fprintf(fid, '   TITLE = "Convertido de GMV a Tecplot y paraview GMV2TECPLOT 2.1"\n');
    Variables=[];
    %%%%%%%%%%
    for i=1:size(keywords,2)
        if tipos(i)==0
            Variables=[Variables '"' char(keywords(i)) '",'];
        end
        if tipos(i)==1&&i>2
            Variables=[Variables '"' char(keywords(i)) 'X"' ',"' char(keywords(i)) 'Y"' ',"' char(keywords(i)) 'Z",'];
        end
        if tipos(i)==1&&i==1
            Variables=[Variables '"x"' ',"y"' ',"z",'];
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
        if isempty(y);continue; end %En caso de no encontrar archivo
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
        isempty(test{1,1});
        while isempty(test{1,1})
            if TestEOF(fid)
                y=salida;
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
            if ~strcmp(keywords{i},'nodes')
                salida(cont:cont+2)=CambioFormato(keywords{i},tipos(i),TmpMtx,salida(1).Param);
            else
                salida(cont:cont+2)=CambioFormato(keywords{i},tipos(i),TmpMtx,test{1,2}{1});
            end
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
function maquillaje(StruData,Paso,Nombrearchivo)
    %Asegurarse de limpiar los NAN
    fid=fopen(Nombrearchivo,'a');
    
    CellCenter=[', VARLOCATION=([' num2str(find([StruData.Tipo]==0)-1,'%u ') ']=CELLCENTERED) ']; % El -1 es un quickn'Dirty por que el cell =2 genera un bug
    fprintf(fid, ['ZONE T= "PASO      ' num2str(Paso) '"   N=' num2str(StruData(1).Param) ',   E=' num2str(StruData(4).Param) ',   F=FEBLOCK,  ET=BRICK' CellCenter '\n']);

    
    %fprintf(fid,['ZONE T= "PASO      ' num2str(Paso) '" DATAPACKING=BLOCK
    %I=' num2str(StruData(1).Param) '\n']);
    for i=[1:3 5:size(StruData,2) 4] %[1:3 5:size(StruData,2) 4]
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