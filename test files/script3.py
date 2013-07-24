#! /usr/bin/env python
# -*- coding: utf8 -*-
#Script que me evita la parte cansona de renombrar y copiar todo para ver la malla. Cumple los pasos listados. Nota: Es mi primer script en python
import shutil 
import subprocess
import os

src=r'/home/carlos/Trabajo/Tesis de grado/Codigo/Malladores cilindro/iprep'#Origen del archivo, dejar la r del inicio para que no de problemas con los espacios en el directorio
dst=r'/home/carlos/Trabajo/Cod_Kiva'#Carpeta de destino, véase def. de src
#	3. Ejecutar k3prep
os.chdir(dst)#cd en el S.O. huésped
subprocess.call( ''.join([dst,'/k3prep']))
#	4. Renombrar otape17 a itape17
os.rename(''.join([dst,'/otape17']),''.join([dst,'/itape17']))
#	5. Ejectuar converter
subprocess.call( ''.join([dst,'/converter']))


#	6. Ejecutar el converter a paraview
#Toca copiar la versión del mallador más reciente a la carpeta de KIVA
ScrName='GMV2TECPLOT.m'
#SrcMatlabFn=r'/home/carlos/Trabajo/Tesis de grado/Codigo/Mejora Cod anterior'
#shutil.copy(''.join([SrcMatlabFn,'/',ScrName]), dst)

# Comando para convocar a matlab desde la consola sin que abra la GUI: matlab -nojvm -nodesktop -r "run <the/path>/<the-script>.m" vía http://ubuntuforums.org/showthread.php?t=825042
subprocess.call(["matlab","-nojvm","-nodesktop","-r","".join(['run ',dst,'/',ScrName,' ;exit;']),])#Al final sale de matlab con ' ;exit;'
#elimina los NaN
subprocess.call(['sed','-i','s/NaN//g','GMV2TECPLOT.dat'])
#	7. Abrirlo todo en Paraview
#subprocess.call(["paraview","".join([dst,"/","GMV2TECPLOT-P.tec"])])


#from paraview.simple import *
#reader = OpenDataFile("/home/carlos/Trabajo/Cod_Kiva/GMV2TECPLOT.tec")
#Show(reader)
#Render()
