#########################
#Lee los archivos 2D de Kiva y Converge para sacar la mayoría de las gráficas
#LectorCFR.py: Lee los archivos 2D de Kiva y Converge para sacar la mayoría de las gráficas. Pretende ser un conjunto de funciones que se llaman desde un script externo.

#Se usa descomentando las líneas que siguen y ejecutándolas en una consola de python:

#import imp
#modl = imp.load_source('LectorCFR', '/home/carlos/archivos/Mallador/Repositorios/conversores/LectorCFR.py')

#DatosCarpeta=([('/home/carlos/archivos/Materias/Tesis/Cacharreo_cantera/Pruebas_compilacion_KIVA-Cantera/1_Cinetica_detallada_directa/7_CFR/Pruebas_Paper/CFR-Spark/9_10J-NewMesh','6mm-4725-Vols', 1),
#        ('/home/carlos/archivos/Materias/Tesis/Cacharreo_cantera/Pruebas_compilacion_KIVA-Cantera/1_Cinetica_detallada_directa/7_CFR/Datos Daniel y Exp -15 atdc a -7 atdc/PruebasSage- Agosto03-2016','6mm_10J_500', 2)])

#modl.PloteeAlgo(DatosCarpeta)
#########################



#-¿Se puede automatizar el sondeo de las velocidades en las mallas?
#  -script que me diga cuál plotgmv hay que tomar los datos

#  -Sacar datos para graficar: ... 13,335 es la altura del cilindro
#*    -|V| en -10 y 30 atdc en el pto (0 0 -0.01) = (0 0 12.335)
#*    -|V| en -10 y 30 atdc en el pto (0.022 0 -0.01) = (2.2 0 12.335)
#    -KIVA vs KIVA y KIVA vs Converge:
#*      - P-CAD para las mallas (KIVA vs KIVA y KIVA vs Converge)
#*      - T-CAD para las mallas (KIVA vs KIVA y KIVA vs Converge)
#*      -Mfrac en 85 ATC (CO,H2O,CO2,OH) presentes en toda la cámara
#*      -HRR ¿J/s o T/CAD?

###Introducir nombres de carpetas deseadas [Ruta carpeta tipo]
###Cambiar el índice en el lector de cosas
###Hacer prueba inicial del coso con 2 carpetas reales
###Nombrar ejes
###Poner leyendas
###Guardar el gráfico en CWD
###Mod standalone y el de llamar el coso
###Crear funciones en python (con argumentos)
#-#Mod para P
#-#Mod para HHR
#-#Rutina de interpolación de mfrac





def PloteeAlgo(DatosCarpeta):
  from matplotlib import pyplot as plt
  import numpy as np
  import os
  cwd = os.getcwd()
  leyenda=list()#inicializa la lista
  for cont in range(0, len(DatosCarpeta)):
    os.chdir(DatosCarpeta[cont][0]+'/'+DatosCarpeta[cont][1])
    if (DatosCarpeta[cont][2]==1):
#      'dat.thermo'
      Datos = np.genfromtxt('dat.thermo', skip_header=DatosCarpeta[cont][2], names=True) 
#      'Crank','Temp'
      plt.plot(Datos['Crank'],Datos['Temp'],)
      leyenda.append('KV-'+DatosCarpeta[cont][1])
   #Acumular cadena para la leyenda
    else:
#      'thermo.out'
      Datos = np.genfromtxt('thermo.out', skip_header=DatosCarpeta[cont][2], names=True) 
#      'crank','Mean_Temp'
      plt.plot(Datos['crank'],Datos['Mean_Temp'])
      leyenda.append('CVG-'+DatosCarpeta[cont][1])
    #Acumular cadena para la leyenda
  #Poner los ejes con unidades

  os.chdir(cwd)
#  plotProps([16,'CAD','Temperature [K]','Temp.jpg'])
  plt.xlabel('CAD',fontsize=16)
  plt.ylabel('Temperature [K]',fontsize=16)
  plt.legend(leyenda)
  plt.savefig('Temp.jpg', bbox_inches='tight')
  plt.show()#Muestra el gráfico

#FIN?

