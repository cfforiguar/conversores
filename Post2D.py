#! /home/carlos/opt/anaconda3/bin/python3

#One click postproc para el caso 2D
import imp, sys, os
modl = imp.load_source('LectorCFR', '/home/carlos/archivos/Mallador/Repositorios/conversores/LectorCFR.py')

Dir=sys.argv[1]

Carpetas=[]
nDirs=0

for curDir in os.scandir(Dir):
  if curDir.is_dir():
    ParDir=os.path.abspath(os.path.join(curDir.name, os.pardir))
    for curFile in os.scandir(ParDir+"/"+curDir.name):
      if (curFile.is_file() and curFile.name=="dat.thermo"):
        nDirs=nDirs+1
        Carpetas=Carpetas+[(ParDir,curDir.name,1)]

#Si no hay subdirectorios, grafique solamente con la ruta actual
if nDirs==0:
  for curFile in os.scandir(Dir):
    if (curFile.is_file() and curFile.name=="dat.thermo"):
      ParDir=os.path.abspath(os.path.join(Dir, os.pardir))
      
      Carpetas=Carpetas+[(ParDir,Dir[len(ParDir)+1:],1)]

DatosCarpeta=Carpetas
#print(DatosCarpeta)
modl.pltPress(DatosCarpeta,'',)

#Liste los directorios
#Busque en c/u los archivos de postproc
#Guarde la ruta de los directorios con archivos válidosos.walk(directory)
