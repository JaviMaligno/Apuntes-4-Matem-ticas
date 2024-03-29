###########################################
#ANALISIS DE DATOS MULTIVARIANTES.        #  
#GRADO EN MATEM�TICAS.                    #
#DOBLE GRADO EN MATEM�TICAS Y ESTAD�STICA #
#AN�LISIS DE CORRESPONDENCIAS             #
###########################################

##############################
#Ejemplo 1: Diario preferido y 
#partido pol�tico votado
##############################
tabla<- matrix(c(100,20,5,10, 
                 90, 80, 30, 10, 
                 10, 110, 100, 12), 
                 ncol=4, byrow=T)

rownames(tabla)<- c("D1", "D2", "D3")
colnames(tabla)<- c("P1", "P2", "P3","P4")
tabla

# FRECUENCIAS RELATIVAS Y/O PORCENTAJES CONJUNTOS
prop.table(tabla) # frecuencias relativas conjuntas
100*prop.table(tabla) # Porcentajes conjuntos

# Distribuciones marginales
(Ntotal=margin.table(tabla))  # n�mero de casos observados
margin.table(tabla,1)         # marginal de la variable fila (frecuencias absolutas)
margin.table(tabla,1)/Ntotal  # marginal de la variable fila (frecuencias relativas)

margin.table(tabla,2)        # marginal de la variable columna (frecuencias absolutas)
margin.table(tabla,2)/Ntotal # marginal de la variable columna (frecuencias relativas)

# Distribuciones porcentuales por filas y columnas o distribuciones condicionadas

# Distribuciones de Partido condicionadas a Diario
print("Distribuci�n Partido/Diario")
prop.table(tabla,1) 
100*prop.table(tabla,1)

# Distribuciones de Diario condicionadas a Partido
print("Distribuci�n Diario/Partido")
prop.table(tabla,2)
100*prop.table(tabla,2)

# Gr�fico "mosaico" de las distribuciones condicionadas
mosaicplot(tabla, main="Plot de las distribuciones de Partido condicionadas a Diario")
mosaicplot(t(tabla), main="Plot de las distribuciones de Diario  condicionadas a Partido")

# Test chi-cuadrado de independencia
resul<- chisq.test(tabla)
resul              # Significativo: se rechaza la independencia

names(resul)
resul$statistic    # Estad�stico chi-cuadrado
resul$parameter    # Grados de libertad de la distribuci�n ji-cuadrado
resul$p.value      # p-valor del contraste de hip�tesis

resul$observed     # Tabla de frecuencias absolutas observadas
resul$expected     # Tabla de frecuencias absolutas esperadas bajo hip�tesis de independencia
resul$residuals    # Residuos de Pearson: (observed - expected) / sqrt(expected)
sum(resul$residuals^2) # Coincide con el estad�stico chi-cuadrado

sum(resul$residuals^2)/sum(tabla)  #Inercia=chicuadrado/n


# Dibujo de los residuos a trav�s de un plot de asociaci�n
#_______________________________________________________________________________________ 
# Orden: 
#          assocplot(x, col = c("black", "red"), space = 0.3,
#                    main = NULL, xlab = NULL, ylab = NULL)
#
# Produce un plot de asociaci�n de Cohen-Friendly indicando las desviaciones de
# la independencia de filas y columnas en una tabla de contingencia
# 
# Argumentos:
#  
# x        : tabla de contingencia bidimensional
# col      : vector de caracteres de longitud dos que indica los colores utilizados para
#           residuos de Pearson positivos y negativos, respectivamente.
# main     : T�tulo
# xlab, ylab : etiquetas de los ejes
#_______________________________________________________________________________________ 

assocplot(tabla,col=c("blue","red"),
          main="Azul: Obs>Esp, Rojo: Obs<Esp")



#An�lisis de Correspondencias con la  librer�a ca
#_______________________________________________________________________________________ 

#install.packages("ca")
library(ca)

# Funci�n ca() 
#
# Orden:
#  ca(obj, nd = NA, suprow = NA, supcol = NA, 
#             subsetrow = NA, subsetcol = NA, ...)
# 
# Argumentos:
# obj     : tabla de frecuencias bidimensional (admite otras opciones)
# suprow  : �ndice de filas suplementarias
# supcol  : �ndice de columnas suplementarias
# ... otras opciones
#
#_______________________________________________________________________________________ 



anacor<- ca(tabla)
summary(anacor) 
# El summary proporciona:
#------------------------
# 1.- Principal inertias (eigenvalues)
# Autovalores o inercias principales (contribuciones de cada eje)
# Porcentaje explicado por cada eje
# 
#------------------------
# 2.- Rows: (diversos c�lculos por filas)
# mass     : distribuci�n marginal de la variable fila *1000
# inr      : inercia de las filas en "puntos por mil"
# k=1,k=2  : coordenadas principales *1000 en el primer y segundo eje, respect.
# cor      : cuadrado de la correlaci�n (*1000) entre cada categor�a y el eje.
#            Mide la calidad de la representaci�n de cada categor�a sobre cada eje.
# ctr      : contribuci�n de cada fila a la inercia del eje k; (las ctr de todas
#            las filas suman 1000). Permite identificar las categor�as que influyen
#            m�s en la definici�n de un eje. 
# qlt      : suma de sus correlaciones al cuadrado (cor) en las dos primeras
#            componentes. Mide la calidad de la representaci�n de cada fila 
#            sobre esos dos ejes.
#
#------------------------
# 3.- Columns: (diversos c�lculos por columnas)
# mass     : distribuci�n marginal de la variable columna *1000
# inr      : inercia de las columnas en "puntos por mil"
# k=1,k=2  : coordenadas principales *1000 en el primer y segundo eje, respect.
# cor      : cuadrado de la correlaci�n entre cada categor�a y el eje correspondiente.
#            Mide la calidad de la representaci�n de cada categor�a sobre cada eje.
# ctr      : contribuci�n de cada columna a la inercia del eje k; (las ctr de todas
#            las columnas suman 1000). Permite identificar las categor�as que influyen
#            m�s en la definici�n de un eje. 
# qlt      : suma de sus correlaciones al cuadrado (cor) en las dos primeras
#            componentes. Mide la calidad de la representaci�n de cada columna 
#            sobre esos dos ejes.
#
#------------------------


names(anacor)
anacor$sv    # Valores singulares                     
anacor$sv^2  # Autovalores

anacor$rowinertia      # Inercia de las filas
sum(anacor$rowinertia) # La suma de inercias de las filas = inercia de la tabla

anacor$rowmass    # centro o media ponderada de filas (coincide con la dist. marginal)
anacor$rowdist    # distancias chi-cuadrado al centro o media ponderada

anacor$rowcoord  # Coordenadas estandarizadas de las filas. Son las coord. principales
                 # divididas por los sv. 

anacor$rowcoord%*%diag(anacor$sv) # Coordenadas principales de las filas

summary(anacor)$rows$" k=1"       # Coordenadas principales, *1000, son
summary(anacor)$rows$" k=2"       # las que aparecen en el summary


# La suma de cuadrados ponderada de las coordenadas principales  
# en la dimensi�n k es el k-�simo autovalor 
# (inercia del factor k)
# Para las estandarizadas, esa suma es 1
# Una propiedad similar se verifica para las columnas
# Comprobaci�n para las filas
Dn=margin.table(tabla,1)/Ntotal
(Cfilestand=anacor$rowcoord)
(Cfilprin= Cfilestand%*%diag(anacor$sv))

Dn%*%Cfilestand^2   #Da 1 para cada dimensi�n
Dn%*%Cfilprin^2     #Coinciden con los autovalores
anacor$sv^2         # Autovalores

anacor$colinertia      # Inercia de las columnas
sum(anacor$colinertia) # La suma de inercias de las columnas = inercia de la tabla


anacor$colmass    # centro o media ponderada de columnas (coincide con la dist. marginal)
anacor$coldist    # distancias chi-cuadado al centro o media ponderada
anacor$colcoord   # Coordenadas estandarizadas de las columnas

anacor$N          # Tabla de frecuencias

# Representaci�n gr�fica del an�lisis de correspondencia
# Se utilizan las coordenadas principales
plot(anacor,main="Diario y partido preferido")
anacor$rowcoord%*%diag(anacor$sv) # Coordenadas principales de las filas

plot(anacor,main="Diario y partido preferido", mass=TRUE)




# El residuo para la fila i y la columna j, i.e., 
# la ra�z cuadrada de la contribuci�n al estad�stico chi-cuadrado,
# es proporcional a 
#                    L1*Ri1*Cj1 +...+ Lm*Rim*Cjm
# donde 
#      Li  son los autovalores, 
#      Ris las coordenadas principales de la fila i
#      Cjs las coordenadas principales de la columna j
#      s=1,2,...,m
# Esta expresi�n puede ser aproximada por el primer sumando si 
#                  L1>> L2 > ... > Lm
#
# - Cuando ambas coordenadas sean del mismo signo revelar� cierta asociaci�n 
# positiva entre la fila y la columna
# - Si las coordenadas tienen distinto signo ser� evidencia de asociaci�n negativa
# - Cuanto m�s lejos est�n del origen, mayor ser� la asociaci�n.

#__________________________________________________________________________________
#

############################################
# Ejemplo 2. Autores.txt contiene el total 
# de veces que aparece cada letra
# en 3 muestras de varios autores
###########################################
#    CD: Charles Darwin
#    RD: Ren� Descartes
#    TH: Thomas Hobbes
#    MS: Mary Shelley
#    MT: Mark Twain
#   DES: Desconocido
#
# Objetivo: identificar qu� autor es el m�s
# cercano al desconocido
###########################################

# Leer la tabla

tabla=as.matrix(read.table("Autores.txt",
                row.names=1,header=TRUE))
tabla


# Calcular distancias chi-cuadrado entre filas

F<- prop.table(tabla); F   # Tabla de frecuencias relativas

fpi<- apply(F,2,sum)   ; fpi    #f.i Frecuencias relativas marginales por columnas

Dp<- diag(fpi)     # Matriz Dp diagonal

colnames(Dp)<- names(fpi)
Dp 

Mr<- prop.table(tabla,1)  # Matriz Mr de distribuciones de la variable columna 
                          # condicionada a cada fila (perfiles fila)
Mr  #Perfiles fila

apply(Mr,1,sum)

# Funci�n para obtener la distancia chi-cuadrado 
#entre perfiles fila i y j

distchicufilas<- function(perfilesfila,i,j,Dp)
{
  rbind(perfilesfila[i,]-perfilesfila[j,])%*%
    solve(Dp)%*%cbind(perfilesfila[i,]-perfilesfila[j,])
}

nx=nrow(tabla)

# Procedimiento para obtener la matriz de distancias chi-cuadrado entre perfiles fila
Dfilas<- matrix(0,nx,nx)
for (i in 1 : (nx-1))
  for (j in (i+1) : nx)
  { Dfilas[i,j]<- distchicufilas(Mr,i,j,Dp)
  Dfilas[j,i]<- Dfilas[i,j]
  }
rownames(Dfilas)<- rownames(Mr)
colnames(Dfilas)<- rownames(Dfilas)
Dfilas  #DES: el autor m�s cercano a DES es MT
Dfilas[6,]

#An�logamente se calcular�an las distancias chi-cuadrado
#entre columnas

#__________________________________________________________________________
# Aplicaci�n del An�lisis de Correspondencia considerando DES como una fila
# suplementaria 
#__________________________________________________________________________
#Podemos realizar un AC definiendo el DES
#como fila suplementaria, para ver c�mo
#quedar�a representado sobre el resto de autores
anacor<- ca(tabla,suprow=c(6))

anacor$rowcoord      # Coordenadas estandarizadas de las filas
summary(anacor)$rows # Coordenadas principales*1000
plot(anacor)             #( k=1 y k=2)                              



##############################
#Ejemplo 3: Tareas 
##############################
tareas=read.table("housetasks.txt",header=TRUE)
tareas
str(tareas)
tabla=as.matrix(tareas[,2:5])
rownames(tabla)=tareas[,1]
tabla
str(tabla)

# Perfiles fila: Distribuciones de la variable columna  
# condicionada a cada fila
round(100*prop.table(tabla,1),1)  

# Perfiles columna: Distribuciones de la variable fila  
# condicionada a cada columna
round(100*prop.table(tabla,2),1)

# Gr�fico "mosaico" de las distribuciones condicionadas
mosaicplot(tabla,main="Perfiles fila (Encargado de tarea condicionado a Tarea) ")
mosaicplot(t(tabla),main="Perfiles columna (Tarea condicionado a Encargado de Tarea) ")


# Contraste chi-cuadrado de independencia
resul<- chisq.test(tabla)
resul              # Significativo: se rechaza la independencia

names(resul)
resul$statistic    # Estad�stico chi-cuadrado
resul$parameter    # Grados de libertad de la distribuci�n ji-cuadrado
resul$p.value      # p-valor del contraste de hip�tesis

resul$observed     # Tabla de frecuencias absolutas observadas
resul$expected     # Tabla de frecuencias absolutas esperadas bajo hip�tesis de independencia
resul$residuals    # Residuos de Pearson: (observed - expected) / sqrt(expected)
sum(resul$residuals^2) # Coincide con el estad�stico chi-cuadrado

sum(resul$residuals^2)/sum(tabla)  #Inercia=chicuadrado/n

# Dibujo de los residuos a trav�s de un plot de asociaci�n
#_______________________________________________________________________________________ 

assocplot(tabla,col=c("blue","red"),
          main="Azul: Obs>Esp, Rojo: Obs<Esp")

# An�lisis de correspondencia                     ### Preguntar interpretacion
library(ca)
anacor<- ca(tabla)
summary(anacor)   
plot(anacor,
    main="An�lisis de correspondencias de las tareas")

###################################################
#Ejemplo 4: An�lisis de Correspondencias M�ltiple
###################################################

datos<-matrix(
  c( rep(c("[18,25)","Hombre","A"),7),
   rep(c("[18,25)","Hombre","B"),5),
   rep(c("[18,25)","Hombre","C"),2),
   rep(c("[18,25)","Hombre","D"),36),
   rep(c("[18,25)","Mujer","A"),3),
   rep(c("[18,25)","Mujer","B"),10),
   rep(c("[18,25)","Mujer","C"),3),
   rep(c("[18,25)","Mujer","D"),34),

   rep(c("[25,55)","Hombre","A"),58),
   rep(c("[25,55)","Hombre","B"),20),
   rep(c("[25,55)","Hombre","C"),20),
   rep(c("[25,55)","Hombre","D"),42),
   rep(c("[25,55)","Mujer","A"),32),
   rep(c("[25,55)","Mujer","B"),50),
   rep(c("[25,55)","Mujer","C"),40),
   rep(c("[25,55)","Mujer","D"),38),

   rep(c("[55,65)","Hombre","A"),26),
   rep(c("[55,65)","Hombre","B"),5),
   rep(c("[55,65)","Hombre","C"),4),
   rep(c("[55,65)","Hombre","D"),5),
   rep(c("[55,65)","Mujer","A"),34),
   rep(c("[55,65)","Mujer","B"),15),
   rep(c("[55,65)","Mujer","C"),6),
   rep(c("[55,65)","Mujer","D"),5)
),  ncol=3,byrow=T)

colnames(datos)<- c("Edad","Sexo","Marca")
datos<- data.frame(datos)
datos
ftable(table(datos[,1],datos[,2],datos[,3]))

library(ca)

anacormul<- mjca(datos,lambda="Burt")
Burt<-anacormul$Burt   #Matriz de Burt a la que se le aplica A.C.
rownames(Burt)<- colnames(Burt)<- anacormul$levelnames
Burt

#La matriz de Burt es la tabla de contingencia de la matriz de indicadores
library(nnet)  #Para usar class.ind, veamos las 10 primeras filas
cbind(class.ind(datos[,1]),class.ind(datos[,2]),class.ind(datos[,3]))[1:10,]
class.ind(datos[,1])[1:15,]

summary(anacormul)
plot(anacormul)  









