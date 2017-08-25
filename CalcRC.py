#! /usr/bin/env python
# encoding: utf-8
#Calcula la relación de compresión a partir de lo impreso en el otape11 y el otape12
# No es el código más inteligente, pero hace el trabajo :P
import os
import re
import sys
 
 
try:
  #Lea otape11
  with open('otape11','r') as f:
      lines = f.readlines()
      
  #https://stackoverflow.com/questions/18152597/extract-scientific-number-from-string
  match_number = re.compile('-?\d+.?\d*(?:[Ee][-+]\d+)?')
  for i in range(0,len(lines)):
  # total volume of region   1 =  1.52298E+03
    if re.match(" total volume of region   1 =",lines[i]):
      m = match_number.findall(lines[i])
      Re1Vol=float(m[1])
      break
except OSError as e:
  f1=open('RC.dat','w')
  err="ERROR: otape11 no encontrado"
  f1.write(err)
  sys.exit(err)


try:
  #Lea otape12
  with open('otape12','r') as f:
      lines = f.readlines()
      
  for i in range(0,len(lines)):
  # cup vols:  lower= 1.15467E+02 upper= 0.00000E+00 sum= 1.15467E+02
    if re.match(" cup vols:  ",lines[i]):#Detectar bloque de especies
      m = match_number.findall(lines[i])
      sumCupsVol=float(m[2])
      break
except OSError as e:
  f1=open('RC.dat','w')
  err="ERROR: otape12 no encontrado"
  f1.write(err)
  sys.exit(err)


minVol=sys.float_info.max
for i in range(0,len(lines)):
#           region 1 volume= 1.439114358070E+03 region 1 mass= 3.116973765639E+00
  if re.match("           region 1 volume=",lines[i]):#Detectar bloque de especies
    m = match_number.findall(lines[i])
    tmp=float(m[1])
    if tmp<minVol:
      minVol=tmp
      
#Arroje el cálculo


out=("Cálculo de la relación de compresión a partir de lo impreso en el otape11 y el otape12\n"
      ,"*****************************************"
      ,"Advertencia!!"
      ,"Verifique que tabla de ncaspec esté incluído CAD=0.0 para que el cálculo sea válido."
      ,"*****************************************\n"
      ,"Volumen máximo (según otape11) [cm3]:        "+str(Re1Vol)
      ,"Volumen de los cuencos (según otape12)[cm3]: "+str(sumCupsVol)
      ,"Volumen mínimo [cm3]:                        "+str(minVol)
      ,"Relación de Compresión:                      "+str(Re1Vol/minVol))

f1=open('RC.dat','w')

for i in out:
  f1.write(i+"\n")
  print(i)
  
f1.close()
