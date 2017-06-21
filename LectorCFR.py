#########################
#Lee los archivos 2D de Kiva y Converge para sacar la mayoría de las gráficas
#LectorCFR.py: Lee los archivos 2D de Kiva y Converge para sacar la mayoría de las gráficas. Pretende ser un conjunto de funciones que se llaman desde un script externo.

#Se usa descomentando las líneas que siguen y ejecutándolas en una consola de python:

#import imp
#modl = imp.load_source('LectorCFR', '/home/carlos/archivos/Mallador/Repositorios/conversores/LectorCFR.py')

#DatosCarpeta=([('/home/carlos/archivos/Materias/Tesis/Cacharreo_cantera/Pruebas_compilacion_KIVA-Cantera/1_Cinetica_detallada_directa/7_CFR/Pruebas_Paper/CFR-Spark/9_10J-NewMesh','6mm-4725-Vols', 1),
#        ('/home/carlos/archivos/Materias/Tesis/Cacharreo_cantera/Pruebas_compilacion_KIVA-Cantera/1_Cinetica_detallada_directa/7_CFR/Datos Daniel y Exp -15 atdc a -7 atdc/PruebasSage- Agosto03-2016','6mm_10J_500', 2)])

#modl.pltTemp(DatosCarpeta)
#########################



#-¿Se puede automatizar el sondeo de las velocidades en las mallas?
#  -script que me diga cuál plotgmv hay que tomar los datos

#  -Sacar datos para graficar: ... 13,335 es la altura del cilindro
#*    -|V| en -10 y 30 atdc en el pto (0 0 -0.01) = (0 0 12.335)
#*    -|V| en -10 y 30 atdc en el pto (0.022 0 -0.01) = (2.2 0 12.335)
#    -KIVA vs KIVA y KIVA vs Converge:
#*      - P-CAD para las mallas (KIVA vs KIVA y KIVA vs Converge)
#*      - T-CAD para las mallas (KIVA vs KIVA y KIVA vs Converge)
#*      -HRR ¿J/s o T/CAD?
#*      -Mfrac en 85 ATC (CO,H2O,CO2,OH) presentes en toda la cámara

###Introducir nombres de carpetas deseadas [Ruta carpeta tipo]
###Cambiar el índice en el lector de cosas
###Hacer prueba inicial del coso con 2 carpetas reales
###Nombrar ejes
###Poner leyendas
###Guardar el gráfico en CWD
###Mod standalone y el de llamar el coso
###Crear funciones en python (con argumentos)
###Mod para P
### -Cuadrar las unidades
###Mod para HRR
### -Cuadrar las unidades
#-Mfrac en 85 ATC (CO,H2O,CO2,OH) presentes en toda la cámara
###  -Graficar puntos
###  -Gráfico semilogarítmico
###  -Encontrar ptos de 85 atdc
###  -interpolación
#  -graficar los puntos como se muestra en el correo
#    -cómo demonios se hace eso?

"""
python3
import imp
modl = imp.load_source('LectorCFR', '/home/carlos/archivos/Mallador/Repositorios/conversores/LectorCFR.py')

DatosCarpeta=([('/home/carlos/archivos/Materias/Tesis/Cacharreo_cantera/Pruebas_compilacion_KIVA-Cantera/1_Cinetica_detallada_directa/7_CFR/Pruebas_Paper/CFR-Spark/9_10J-NewMesh','6mm-4725-Vols', 1),
        ('/home/carlos/archivos/Materias/Tesis/Cacharreo_cantera/Pruebas_compilacion_KIVA-Cantera/1_Cinetica_detallada_directa/7_CFR/Datos Daniel y Exp -15 atdc a -7 atdc/PruebasSage- Agosto03-2016','6mm_10J_500', 2)])

modl.pltTemp(DatosCarpeta)
modl.pltPress(DatosCarpeta)
modl.pltHRR(DatosCarpeta)

python3
import imp
modl = imp.load_source('LectorCFR', '/home/carlos/archivos/Mallador/Repositorios/conversores/LectorCFR.py')

DatosCarpeta=([('/home/carlos/archivos/Materias/Tesis/Cacharreo_cantera/Pruebas_compilacion_KIVA-Cantera/1_Cinetica_detallada_directa/7_CFR/Pruebas_Paper/CFR-Spark/9_10J-NewMesh','6mm-4725-Vols', 1),
      ('/home/carlos/archivos/Materias/Tesis/Cacharreo_cantera/Pruebas_compilacion_KIVA-Cantera/1_Cinetica_detallada_directa/7_CFR/Pruebas_Paper/CFR-Spark/9_10J-NewMesh','4mm-14112-Vols', 1),
      ('/home/carlos/archivos/Materias/Tesis/Cacharreo_cantera/Pruebas_compilacion_KIVA-Cantera/1_Cinetica_detallada_directa/7_CFR/Datos Daniel y Exp -15 atdc a -7 atdc/PruebasSage- Agosto03-2016','6mm_10J_500', 2)
])

Especies=([('co','CO'),('h2o','H2O'),('oh','OH')])
Espacios=[0.2,0.6]
modl.pltSpecies(DatosCarpeta,25.0,Especies,Espacios)
"""

#dat.species degrees co  [g]

def pltHRR(DatosCarpeta):
  #netHRR [erg/CAD]
  KvProps=(['dat.thermo','Crank','netHRR',1.0e-7])
  #Integrated_HR [J] HR_Rate [J/time]
  CVGProps=(['thermo.out','crank','HR_Rate'])
  plotProps=([16,'CAD','HRR [J/CAD]','HRR.jpg'])
  PloteeAlgo(DatosCarpeta,KvProps,plotProps,CVGProps)

def pltPress(DatosCarpeta):
  KvProps=(['dat.thermo','Crank','Press',1.0e-7])
  CVGProps=(['thermo.out','crank','Pressure'])
  plotProps=([16,'CAD','Pressure [MPa]','Press.jpg'])
  PloteeAlgo(DatosCarpeta,KvProps,plotProps,CVGProps)

def pltTemp(DatosCarpeta):
  KvProps=(['dat.thermo','Crank','Temp',1.0])
  CVGProps=(['thermo.out','crank','Mean_Temp'])
  plotProps=([16,'CAD','Temperature [K]','Temp.jpg'])
  PloteeAlgo(DatosCarpeta,KvProps,plotProps,CVGProps)

def PloteeAlgo(DatosCarpeta,KvProps,plotProps,CVGProps):
  from matplotlib import pyplot as plt
  import numpy as np
  import os
  cwd = os.getcwd()
  leyenda=list()#inicializa la lista
  for cont in range(0, len(DatosCarpeta)):
    os.chdir(DatosCarpeta[cont][0]+'/'+DatosCarpeta[cont][1])
    if (DatosCarpeta[cont][2]==1):
      Datos = np.genfromtxt(KvProps[0], skip_header=DatosCarpeta[cont][2], names=True) 
      plt.plot(Datos[KvProps[1]],Datos[KvProps[2]]*KvProps[3])
      leyenda.append('KV-'+DatosCarpeta[cont][1])
    else:
      Datos = np.genfromtxt(CVGProps[0], skip_header=DatosCarpeta[cont][2], names=True) 
      plt.plot(Datos[CVGProps[1]],Datos[CVGProps[2]])
      leyenda.append('CVG-'+DatosCarpeta[cont][1])
  #Poner los ejes con unidades
  os.chdir(cwd)
  plt.xlabel(plotProps[1],fontsize=plotProps[0])
  plt.ylabel(plotProps[2],fontsize=plotProps[0])
  plt.legend(leyenda,loc='best')
  plt.legend
  plt.savefig(plotProps[3], bbox_inches='tight')
  plt.show()#Muestra el gráfico

#FIN?

#Sacar las propiedades del distanciamiento al usuario

def pltSpecies(DatosCarpeta,CA,Especies,Espacios):#,KvProps,plotProps,CVGProps):
# CA=85.0
# Especies=([('co','CO'),('h2o','H2O'),('oh','OH')])
  from matplotlib import pyplot as plt
  import numpy as np
  import os
  cwd = os.getcwd()
  leyenda=list()#inicializa la lista
  xLabels=list()#inicializa la lista
  x=np.arange(len(DatosCarpeta))+1.0
  yinterp=np.empty(len(DatosCarpeta))
  #Acumular un vector Y con los valores del elemento químico por cada carpeta
  KvProps=(['dat.species',CA,'degrees','co',1.0])
  CVGProps=(['species.out',CA,'crank','CO',1.0e-3])
  
  #http://stackoverflow.com/questions/4800811/accessing-a-value-in-a-tuple-that-is-in-a-list
  #http://stackoverflow.com/questions/12453580/concatenate-item-in-list-to-strings
  NombreArchivo='Especies_'+'_'.join([x[1] for x in Especies])+'.jpg'
  plotProps=([16,'Cases','Species mass fraction @ '+str(CA)+' ATDC',NombreArchivo])
  
  for contA in range(0, len(Especies)):
    for cont in range(0, len(DatosCarpeta)):
      if (DatosCarpeta[cont][2]==1):
        KvProps[3]=Especies[contA][0]
        os.chdir(DatosCarpeta[cont][0]+'/'+DatosCarpeta[cont][1])  
        Datos = np.genfromtxt(KvProps[0], skip_header=DatosCarpeta[cont][2], names=True)
        #https://docs.scipy.org/doc/numpy/reference/generated/numpy.interp.html
        SInterp = np.interp(KvProps[1], Datos[KvProps[2]], Datos[KvProps[3]]*KvProps[4])
        xLabels.append('KV-'+DatosCarpeta[cont][1])#Labels en x (xticks)
        #http://stackoverflow.com/questions/5957380/convert-structured-array-to-regular-numpy-array
        #https://docs.scipy.org/doc/numpy/user/basics.rec.html#accessing-multiple-fields-at-once
        #Hacer esta línea me llevó más de 20 horas. Consejos:
        #    1. No la toque
        #    2. Las matrices estructuradas de numpy apestan
        totMass=np.sum(Datos.view(np.float64).reshape(Datos.shape + (-1,))[:,1:],axis=1)
        totMassInterp= np.interp(KvProps[1], Datos[KvProps[2]], totMass*KvProps[4])
        yinterp[cont]=SInterp/totMassInterp #Interpolated mass fraction of species 
      else:
        CVGProps[3]=Especies[contA][1]
        os.chdir(DatosCarpeta[cont][0]+'/'+DatosCarpeta[cont][1])  
        Datos = np.genfromtxt(CVGProps[0], skip_header=DatosCarpeta[cont][2], names=True)
        #https://docs.scipy.org/doc/numpy/reference/generated/numpy.interp.html
        SInterp = np.interp(CVGProps[1], Datos[CVGProps[2]], Datos[CVGProps[3]]*CVGProps[4])
        xLabels.append('CVG-'+DatosCarpeta[cont][1])#Labels en x (xticks)
        #http://stackoverflow.com/questions/5957380/convert-structured-array-to-regular-numpy-array
        #https://docs.scipy.org/doc/numpy/user/basics.rec.html#accessing-multiple-fields-at-once
        #Hacer esta línea me llevó más de 20 horas. Consejos:
        #    1. No la toque
        #    2. Las matrices estructuradas de numpy apestan
        totMass=np.sum(Datos.view(np.float64).reshape(Datos.shape + (-1,))[:,1:],axis=1)
        totMassInterp= np.interp(CVGProps[1], Datos[CVGProps[2]], totMass*CVGProps[4])
        yinterp[cont]=SInterp/totMassInterp #Interpolated mass fraction of species 
    leyenda.append(CVGProps[3]) 
    plt.xticks(x, xLabels,rotation=45)
    #Plotear
    plt.yscale('log')
    plt.plot(x, yinterp, 'o')
  plt.legend(leyenda, loc='upper center',ncol=4, bbox_to_anchor=(0, 1.0, 1, 0.1),
                       mode="expand", borderaxespad=0.)#, bbox_to_anchor=(1.0, 1.0))
  print(Especies[0][0:])
  plt.xlabel(plotProps[1],fontsize=plotProps[0])
  plt.ylabel(plotProps[2],fontsize=plotProps[0])
##¿Sacar esto como propiedad individual?
  plt.xlim([x[0]-Espacios[0],x[-1]+Espacios[1]]) #Ajusta el espaciamiento antes y después de cada xtick para que el primer dato no quede sobre el eje y para que quepa la leyenda
  #Ajusta el espezor delos bordes
  #  http://matplotlib.org/users/tight_layout_guide.html
  #  http://matplotlib.org/faq/howto_faq.html#howto-subplots-adjust
  plt.tight_layout()
  os.chdir(cwd)
  plt.savefig(plotProps[3], bbox_inches='tight')
  plt.show()
