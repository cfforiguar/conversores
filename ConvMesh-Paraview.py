#! /usr/bin/env python3
# -*- coding: utf8 -*-
#Script que me evita la parte cansona de renombrar y copiar todo para ver la malla. Cumple los pasos listados. Nota: Es mi primer script en python
import shutil 
import subprocess
import os

ParaviewSrc=r'/home/carlos/archivos/Materias/Tesis/Cacharreo_cantera/Pruebas_compilación_KIVA-Cantera/1_Cinetica_detallada_directa/ParaView-4.1.0-Linux-64bit/bin'
dst=os.getcwd()

#	6. Ejecutar el converter a paraview
#Toca copiar la versión del mallador más reciente a la carpeta de KIVA
ScrName='MGMV2Tecplot2.m'
SrcMatlabFn=r'/home/carlos/archivos/Mallador/Repositorios/conversores/Enlaces'
shutil.copy(''.join([SrcMatlabFn,'/',ScrName]), dst)
# Comando para convocar a matlab desde la consola sin que abra la GUI: matlab -nojvm -nodesktop -r "run <the/path>/<the-script>.m" vía http://ubuntuforums.org/showthread.php?t=825042
subprocess.call(["matlab","-nojvm","-nodesktop","-r","".join(["run  '",dst,"/",ScrName,"' ;exit;"]),])#All sale de matlab con ' ;exit;'
#elimina los NaN
#subprocess.call(['sed','-i','s/NaN//g','GMV2TECPLOT.tec'])
#	7. Abrirlo todo en Paraview
subprocess.call(["".join([ParaviewSrc,"/paraview"]),"".join([dst,"/","MGMV2TECPLOT.tec"])])
#from paraview.simple import *
#reader = OpenDataFile("/home/carlos/Trabajo/Cod_Kiva/GMV2TECPLOT.tec")
#Show(reader)
#Render()
