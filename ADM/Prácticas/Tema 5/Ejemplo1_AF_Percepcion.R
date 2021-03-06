###########################################
#ANALISIS DE DATOS MULTIVARIANTES.        #  
#GRADO EN MATEM�TICAS.                    #
#DOBLE GRADO EN MATEM�TICAS Y ESTAD�STICA #
#AN�LISIS FACTORIAL: EJEMPLO PERCEPCI�N   #
###########################################
#El fichero "Percepcion.txt" contiene las
#puntuaciones que una ni�a de 12 a�os 
#asign� a siete personas de su entorno
#inmediato en cinco caracter�sticas,
#cada una medida en una escala de 1 a 9
#(CA1 a CA3: Compa�eras de clase,
#CO: Compa�ero de clase)
#1. Leer el conjunto de datos. Obtener un resumen
#   num�rico y gr�fico
#2. Calcular y analizar la matriz de correlaciones
#3. Estimar el modelo AF mediante mediante el m�todo 
#   de Componentes Principales (variables tipificadas)
#4. Aplicar el m�todo de rotaci�n varimax
#5. Comprobar que el m�todo de Factores Principales
#   falla tras la primera iteraci�n

#1. Leer el conjunto de datos
#############################
X= read.table("Percepcion.txt",header=TRUE,
                   row.names=1)
X
summary(X)
boxplot(X)   

#2. Calcular y analizar la matriz de correlaciones
##################################################
(R=cor(X))    #Posibles grupos:{1,3,4} y {2,5}
#install.packages("corrplot")
library(corrplot)
corrplot(R,method="ellipse")

det(R)
#R es singular, por lo que no se puede calcular 
#ni KMO ni el test de Barlett
#Adem�s tampoco se puede aplicar el m�todo AF
#de m�xima verosimilitud                                 

#3. Estimar el modelo A.F. mediante el 
#   m�todo de Componentes Principales
#######################################
#3.1. Determinar el n�mero adecuado de factores, 
#obtener las cargas factoriales, varianzas espec�ficas, 
#comunalidades y las contribuciones de cada factor. 

#cor=TRUE: datos tipificados
plot(princomp(X,cor=TRUE))   #Sugiere dos factores

(autoval= eigen(R)$values)   #autovalores y autovectores
round(autoval,2)
(autovec= eigen(R)$vectors)
m= 2  #n�mero de factores

L=autovec[,1:m]%*%diag(sqrt(autoval[1:m]))  
#Cargas factoriales

rownames(L)= colnames(X)            

#Coinciden con las correlaciones entre 
#variables y factores (R)
colnames(L)= paste("Factor",1:m)  
L
(h= apply(L^2,1,sum))   #comunalidades
(psi= diag(R)-h)        #varianzas espec�ficas
cbind(L,h,psi)          #Parece ser necesario aplicar alguna rotaci�n

#Contribuciones de los factores
contrib=   apply(L^2,2,sum)
contrib   #conciden con autoval[1:2]
autoval[1:m]
resumen= matrix(NA,nrow=m,ncol=3)
resumen[,1]=  contrib[1:m]
resumen[,2]= 100*resumen[,1]/sum(autoval)
resumen[,3]= cumsum(resumen[,2])
colnames(resumen)= c("Varianza","Porcentaje",
                     "Porcentaje acumulado")
resumen

#3.2. Representar gr�ficamente las cargas 
#factoriales 
plot(L,xlim=c(-0.2,1.4),ylim=c(-0.8,0.8),
     type="n",main="Cargas factoriales", 
 xlab="Factor 1",ylab="Factor 2",asp=1)  
#asp=1 Para que coincidan las escalas x e y 
text(L,labels=rownames(L),cex=0.8)
grid()
abline(h=0,v=0,lty=2)

#4. Aplicar el m�todo de rotaci�n varimax 
#########################################
#4.1. Obtener la matriz de rotaci�n y su 
#representaci�n gr�fica 
(rotvarimax= varimax(L))
phi= asin(rotvarimax$rotmat[2,1])    
phi             #�ngulo de rotaci�n en radianes
phi*360/(2*pi)  #�ngulo de rotaci�n en grados
T=rotvarimax$rotmat #matriz de rotaci�n
T%*%t(T)  #Es ortogonal
arrows(0,0,T[1,1],T[2,1],lty=2,lwd=2,col="red")
arrows(0,0,T[1,2],T[2,2],lty=2,lwd=2,col="red")

#4.2. Obtener la matriz de cargas rotada 
#y su interpretaci�n. 
#se aplica unclass para que ya no sea de
#la clase "loadings" que no visuliza valores
#inferiores a 0.1 (en valor absoluto)
Lrot=unclass(rotvarimax$loadings)
#(Lrot= L%*%T)  #es lo mismo        
colnames(Lrot)= c("F1 rot.","F2 rot.2")
Lrot
#F1rot y F2rot son m�s f�ciles de interpretar
#{1,3,4} y {2,5}

#4.3. Calcular las comunalidades, varianzas 
#espec�ficas y contribuciones de los factores 
#(coinciden con la soluci�n no rotada).
(hrot= apply(Lrot^2,1,sum))   #comunalidades
(psirot= diag(R)-hrot)        #varianzas espec�ficas
cbind(L,h,psi,Lrot,hrot,psirot)
contribrot=   apply(Lrot^2,2,sum)
rbind(cbind(contrib,contribrot),
      Total=c(sum(contrib),sum(contribrot)))
resumenrot= matrix(NA,nrow=m,ncol=3)
resumenrot[,1]=  contribrot[1:m]
resumenrot[,2]= 100*resumenrot[,1]/sum(autoval)
resumenrot[,3]= cumsum(resumenrot[,2])
colnames(resumenrot)= c("Varianza","Porcentaje",
                        "Porcentaje acumulado")
resumenrot
resumen      #resumen para la soluci�n original


#4.4. Obtener las puntuaciones factoriales asociadas 
#a trav�s de m�nimos cuadrados ordinarios y 
#representarlas gr�ficamente. 
#Puntuaciones factoriales para la rotaci�n varimax:
#Para la soluci�n de componentes principales
#se suele usar m�nimos cuadrados ordinarios
#Como estamos trabajando con R, 
#necesitamos las variables  tipificadas:
Z= scale(X,center=TRUE,scale=TRUE)  
apply(Z,2,mean)
apply(Z,2,sd)

#Para aplicar la f�rmula de transparencias   ### Aclaro: Si trabajas con R, todo TRUE
#las variables deben centrarse               ### Si trabajas con Sigma, solo center.
#aqu� no hace falta
Xcent=scale(Z,center=TRUE,scale=FALSE)              
summary(Xcent)
Frot= t(solve(t(Lrot)%*%Lrot)%*%t(Lrot)%*%t(Xcent))  ## Si es con L cambian las 
rownames(Frot)= rownames(X)                          ## puntuaciones
Frot                                                

#Comprobar que tienen media 0
#y matriz de cov=I
colMeans(Frot)
cov(Frot)

#Nube de puntos de las puntuaciones factoriales
plot(Frot,type="n",
     main="Puntuaciones factoriales mediante m�nimos cuadrados \nRotaci�n varimax")
text(Frot,labels=rownames(Frot),cex=0.7,col="red")
abline(h=0,v=0,lty=2,col="blue")

#Aproximaci�n a R
R2=Lrot%*%t(Lrot) + diag(psirot)
R2
R
Rresid= R-R2
round(Rresid,3)
sum(Rresid^2)
sum(autoval[-c(1:m)]^2)  #(Proposici�n 2)

#5. Comprobar que el m�todo de Factores Principales
#   falla tras la primera iteraci�n
####################################################
#Comenzamos con una estimaci�n inicial 
#de las comunalidades
solve(R)   #1/rii no se pueden calcular
#Una alternativa:
hini=apply((R-diag(ncol(R)))^2,1,max)  

R0= R
diag(R0)=hini   ; R0

(autoval0= eigen(R0)$values)       
(autovec0= eigen(R0)$vectors)
plot(autoval0,type="h")     #Sugiere m=2

m= 2  #n�mero de factores
Lf=autovec0[,1:m]%*%diag(sqrt(autoval0[1:m]))  #Cargas factoriales
rownames(Lf)= colnames(X)  #Coinciden con las correlaciones
colnames(Lf)= paste("Factor",1:m)  #entre variables y factores (R)
Lf      #De nuevo sugiere rotaci�n
L       #Soluci�n C.P.
resumenf= matrix(NA,nrow=m,ncol=3)
resumenf[,1]=  autoval0[1:m]
resumenf[,2]= 100*resumenf[,1]/sum(autoval0)
resumenf[,3]= cumsum(resumenf[,2])
colnames(resumenf)= c("Varianza","Porcentaje","Porcentaje acumulado")
resumenf
apply(Lf^2,2,sum)

#en este ejemplo no podr�a continuar la iteraci�n, 
#de hecho al calcular nuevas estimaciones de las 
#comunalidades,algunas son >1 (Caso de Heywood)
#y la correspondiente especificidad es <0
(h1= apply(Lf^2,1,sum))   #comunalidades
(psi1= diag(R)-h1)        #varianzas espec�ficas


