#! /bin/bash
############################################################################################################
#																						                   #
#	               Algoritmo SRPT con Particiones Fijas e Iguales               	                       #
#																						                   #
#          Autores: Carlos González Calatrava y Francisco Javier Yagüe Izquierdo		                   #
#		   Revision: Ricardo Angel Encinar de Frutos									                   #
#																						                   #
#		   Control de cambios:															                   #
#		   Version incial 1.0: Julio 2016 (Carlos González Calatrava y Francisco Javier Yagüe Izquierdo)   #
#		   Revision 1.1: Mayo 2017   Ricardo Angel Encinar de Frutos					                   #
#																						                   #
############################################################################################################



clear

#########################################################################################
#																						#
#	Función que muestra la licencia de uso bajo la que está el algoritmo.         	    #
#																						#
#########################################################################################
function licencia() {
	echo ""
	echo "############################################################" 
	echo "#                     Creative Commons                     #" 
	echo "#                                                          #" 
	echo "#                   BY - Atribución (BY)                   #" 
	echo "#                 NC - No uso Comercial (NC)               #" 
	echo "#                SA - Compartir Igual (SA)                 #" 
	echo "############################################################" 
	echo ""
	echo ""
}
#########################################################################################
#																						#
#	Función que muestra los autores del algoritmo .                       	            #
#																						#
#########################################################################################
function algoritmo(){
echo -e "\e[0;33m#################################################################################################\e[0m"
echo -e "\e[0;33m#												#\e[0m"
echo -e "\e[0;33m#		\e[1;36mAlgoritmo SRPT con Particiones Fijas e Iguales \e[0m					\e[0;33m#"			
echo -e "\e[0;33m#		\e[1;36mCarlos González Calatrava y Francisco Javier Yagüe Izquierdo		\e[0m	\e[0;33m#"
echo -e "\e[0;33m#		\e[1;36mRevision: Ricardo Angel Encinar de Frutos    	                	\e[0m	\e[0;33m#"
echo -e "\e[0;33m#		\e[1;36mVersión Mayo 2017 \e[0m								\e[0;33m#"
echo -e "\e[0;33m#												#\e[0m"
echo -e "\e[0;33m#################################################################################################\e[0m"
}


#########################################################################################
#																						#
#	Función que muestra los autores del algoritmo                                   	#
#																						#
#########################################################################################
function autoria(){
	echo "#################################################################################################" 
	echo "#																								#" 
	echo "#				Algoritmo SRPT con Particiones Fijas e Iguales									#" 
	echo "#				Carlos González Calatrava y Francisco Javier Yagüe Izquierdo 					#"
	echo "#				Revision: Ricardo Angel Encinar de Frutos 					#" 
	echo "#				Versión Mayo 2017																#" 
	echo "#																								#" 
	echo "#################################################################################################"
	echo ""
}


#########################################################################################
#																						#
#	En esta función inicializamos las variables que vamos a usar a lo largo del script.	#
#																						#
#########################################################################################
function inicializaVariables(){
	var='si';
	p=0;
	proceso=();
	#
	procesosTimeLine=();
	llegada=();
	tiempo=();
	proceso1=();
	llegada1=();
	tiempo1=();
	tSistema=0;
	max=0;
	#vectores despues de procesar
	memoria=();
	memoria1=();
	proceso2=();
	llegada2=();
	tiempo2=();
	memoria2=();
	es_numero='^[0-9]+$'
	haFinalizado=0
	proMem=();
	lleMem=();
	tieMem=();
	tamMem=();
	resMem=();
	tMRetorno=();
	tMEspera=();
	entraEnMemoria="true"
	hayProcesoEnMemoria=();
	procesoEspera=();
	llegadaEspera=();
	tiempoEspera=();
	memoriaEspera=();
	restanteEspera=();
	procesoEsperaAux=();
	llegadaEsperaAux=();
	tiempoEsperaAux=();
	memoriaEsperaAux=();
	restanteEsperaAux=();
	procesosTerminados=();
        #RAE
        imprimoSalida=0
        anteriorEnCPU='vacio';
}

#########################################################################################
#																						#
#	Funcion que comprueba que el nombre del proceso sea correcto y que                  #
#   no tenga espacios                                                       			#
#																						#
#########################################################################################
function Comprobarn() {
	palabra=$# 
	if [ $palabra -ne 1 ]  #si es distinto pido otro nombre para el proceso
	  then 
	     echo "Nombre De Proceso No Valido"
	     echo "Introduce un nombre para el proceso sin espacios"
	     valido=1;
	  else
	     valido=0;
        fi
}

#########################################################################################
#																						#
#	Esta función comprueba que el nombre del proceso no exista ya en el simulador       #
#   impidiendo que haya nombres de proceso duplicados en la lista proceso               #
#																						#
#########################################################################################
function CompruebaNombre() {
	correcto=0;
	for(( i=0 ; i <= ${#proceso[@]} ; i++ )){
		contador=0;
		valor=${proceso[$i]};
		for(( j=0 ; j<= ${#proceso[@]} ; j++ )){
			valor2=${proceso[$j]};
			#si los valores del array coinciden es que he encontrado 
			#el proceso en la lista. Como estamos recorriendo el mismo array
			#todo proceso tendra que estar una vez.
			#En el caso de encontrarse mas de una vez si que tendremos el proceso
			# duplicado en el sistema y devolveremos incorrecto.
			if [ "$valor" == "$valor2" ] 
				then
					contador=`expr $contador + 1`;
			fi
			if [ $contador -gt 1 ] #si el contador es mayor que uno
				then
					echo "Nombres para procesos no válidos"
					echo "Introduzca nombres distintos a los procesos"
					echo " "
					correcto=1; #Valor de la variable a 1 para un valor mal introducido					
				else
					correcto=0; #Valor de la variable a 0 para un valor introducido
			fi
		}
	}
	return $correcto
}

#########################################################################################
#																						#
#	Funcion que comprueba que el valor pasado como parámetro es un número entero 	    #
#	y positivo.                                                                         #
#																						#
#########################################################################################
function CompruebaNumero(){
	numValido=0
	if [[ $1 =~ $es_numero ]]
		then
		numValido=1
	fi
}

#########################################################################################
#																						#
#	En esta función comprobamos que el tamaño asignado a un proceso pasado por 			#
#	parámetro es menor o igual que el tamaño de las particiones.						#
#																						#
#########################################################################################
function CompruebaTamaño(){
	cabeProceso="false"
	if [[ $1 -le $MEM ]]
		then
		cabeProceso="true"
	fi
}

#########################################################################################
#																						#
#	En esta función lo que hacemos es inicializar los ficheros para la creación del		#
#	de la ejecución del script.															#
#																						#
#########################################################################################
function creaInforme(){
	echo "" > srpt.temp
	echo "| 	Proceso		|	T. Llegada	 |	 T.Ejecución	 |	 Memoria	|" >> srpt.temp
	echo "_____________________________________________________________________" >> srpt.temp
}

#########################################################################################
#																						#
#    Funcion que se encarga de ordenar los procesos que están cargados en la lista de   #
#    procesos del simulador en funcion de su tiempo de llegada.                         #	
#
#########################################################################################
#funciona sin problemas
function ordenaProcesosEntrada(){
	entraPrimero=();
	#copia toda la lista de procesos en el array entraPrimero
	for ((i=0;i<${#proceso[@]};i++))
	do
		entraPrimero[$i]=$i 
	done
	#compararemos los tiempos de llegada de cada uno de los procesos utilizando sus posiciones
	# en el caso de que el tiempo de llegada del proceso que estamos comparando sea mayor
	# pondremos en entraPrimero el menor 
	for ((i=0;i<${#proceso[@]};i++)){
		for ((j=i;j<${#proceso[@]};j++)){

			a=${llegada[$i]};
			b=${llegada[$j]};    #asigno a unas variables 

			if [[ $a -eq $b ]]
				then
				if [[ ${entraPrimero[$j]} -lt ${entraPrimero[$i]} ]]
					then
					aux2=${proceso[$i]};
	        	    proceso[$i]=${proceso[$j]};
	        	    proceso[$j]=$aux2;

					aux3=${memoria[$i]};
	        	    memoria[$i]=${memoria[$j]};
	        	    memoria[$j]=$aux3;

					aux=${tiempo[$i]};
	        	    tiempo[$i]=${tiempo[$j]};   
	        	    tiempo[$j]=$aux;

	        	    aux1=${llegada[$i]};
	        	    llegada[$i]=${llegada[$j]};
	        	    llegada[$j]=$aux1;

	        	    aux4=${entraPrimero[$i]}
	        	    entraPrimero[$i]=${entraPrimero[$j]}
	        	    entraPrimero[$j]=$aux4
	        	fi
			elif [[ $a -gt $b ]];
				then
				aux2=${proceso[$i]};
        	    proceso[$i]=${proceso[$j]};
        	    proceso[$j]=$aux2;

				aux3=${memoria[$i]};
        	    memoria[$i]=${memoria[$j]};
        	    memoria[$j]=$aux3;

				aux=${tiempo[$i]};
        	    tiempo[$i]=${tiempo[$j]};   
        	    tiempo[$j]=$aux;

        	    aux1=${llegada[$i]};
        	    llegada[$i]=${llegada[$j]};
        	    llegada[$j]=$aux1;

        	    aux4=${entraPrimero[$i]}
        	    entraPrimero[$i]=${entraPrimero[$j]}
        	    entraPrimero[$j]=$aux4	
			fi
		}
	}
}

#########################################################################################
#																						#
#	Esta función es usada para pasar los datos que vamos introduciendo a un fichero 	#
#	por si queremos reutilizar los mismos datos para una nueva ejecución en el 			#
#	script.
#																						#
#########################################################################################
function datosAFichero(){
	echo "proce ${proceso[$p]} llegada ${llegada[$p]} ejecucion ${tiempo[$p]} tamaño ${memoria[$p]}" >> entradaSRPT.txt
}

#########################################################################################
#																						#
#	Funcion que se encarga de cargar los datos que va a manejar el simulador desde  el  #
#   fichero entradaSRPT.txt                                                             #
#	        																	        #
#																						#
#########################################################################################
function obtieneDeFichero(){
	# cuento el numero de lineas totales del fichero para poder ir recorriendolo linea a 
	# linea e ir obteniendo la informacion.
	
	#compruebo que el fichero existe en el directorio del script
	#sino doy error
	
	if [ -f ./entradaSRPT.txt ];then
		nLineas=(`cat entradaSRPT.txt | wc -l`)
		for (( l=1 ; l<=nLineas ; l++ ))
		do
			#Si estamos en la primera linea del fichero obtendremos el numero de particiones
			if [[ $l -eq 1 ]]
				then
				nPart=(`cat entradaSRPT.txt | cut -f 4 -d" " | head -n $l`)
			#Si estamos en la segunda linea del fichero obtendremos el tamaño de la memoria
			elif [[ $l -eq 2 ]]
				then
				MEM=(`cat entradaSRPT.txt | cut -f 4 -d" " | head -n $l | tail -n 1`)
			#En el resto de lineas nos encontrarnos con los datos relativos a procesos
			else
				procFich=(`cat entradaSRPT.txt | cut -f 2 -d" " | head -n $l | tail -n 1`)
				llegFich=(`cat entradaSRPT.txt | cut -f 4 -d" " | head -n $l | tail -n 1`)
				tiemFich=(`cat entradaSRPT.txt | cut -f 6 -d" " | head -n $l | tail -n 1`)
				memoFich=(`cat entradaSRPT.txt | cut -f 8 -d" " | head -n $l | tail -n 1`)
				proceso2[${#proceso2[@]}]=$procFich
				llegada2[${#llegada2[@]}]=$llegFich
				tiempo2[${#tiempo2[@]}]=$tiemFich
				memoria2[${#memoria2[@]}]=$memoFich
			fi
		done
	else
		echo "Falta el fichero entradaSRPT.txt, necesario para la carga automática de datos" 
		echo "por favor, completelo y vuelva a lanzar el programa"
		exit 1
	fi
}

#########################################################################################
#																						#
#	Función que vuelca la grafica de los datos introducidos a un fichero                #
#																						#
#########################################################################################

function graficaPideDatosInforme(){
	echo ""
	echo "| 	Proceso		|	T. Llegada	 |	 T.Ejecución	 |	 Memoria	|" > srpt.temp
	echo "_____________________________________________________________________" >> srpt.temp
	echo "| 	Proceso		|	T. Llegada	 |	 T.Ejecución	 |	 Memoria	|" > muestra
	echo "_________________________________________________________________________________________________" >> muestra
	for (( i=0 ; i<${#proceso[@]} ; i++ ))
	do
		echo "| 		${proceso[i]}		|		${llegada[i]}		 |		${tiempo[i]}			 |	 	${memoria[i]}		|" >> srpt.temp
		echo "_____________________________________________________________________" >> srpt.temp
		echo "| 	${proceso[i]}		|	${llegada[i]}		 |	${tiempo[i]}		|	 ${memoria[i]}		|" >> muestra
		echo "_________________________________________________________________________________________________" >> muestra
	done
	echo ""
}

#########################################################################################
#																						#
#	Función que va mostrando los datos de los procesos que introducimos en el           #
#   simulador por pantalla                                                              #
#																						#
#########################################################################################
function graficaPideDatosPantalla(){
	echo "_________________________________________________________________________________________________"
	echo "| 	Proceso		|	T. Llegada	 |	 T.Ejecución	 |	 Memoria	|"
	echo "_________________________________________________________________________________________________"
	for (( i=0 ; i<${#proceso[@]} ; i++ ))
	do
		echo "| 	${proceso[$i]}		|	${llegada[$i]}		 |	${tiempo[$i]}		|	 ${memoria[$i]}		|"
		echo "_________________________________________________________________________________________________"
	done
	echo "|		Número de Particiones		 |		Tamaño de particiones		|"
	echo "_________________________________________________________________________________________________"
	echo "|			$nPart			 |			$MEM			|"
	echo "_________________________________________________________________________________________________"

	echo ""
} 

#########################################################################################
#																						#
#	Función que hace de menu para el usuario. Pregunta si el usuario quiere             #
#   introducir los datos de manera manual o automática. En el caso de elegirse          #
#   la opción manual, ira pidiendo los datos al usuario de manera interactiva           #
#   hasta que el usuario decida finalizar su introducción. Si se elige el modo          #
#   automatico cargara los datos desde el fichero entradaSRPT.txt                       #
#																						#
#########################################################################################
function pideDatos(){
	
	echo "| 	Proceso		|	T. Llegada	 |	 T.Ejecución	 |	 Memoria	|" > muestra
	echo "_________________________________________________________________________________________________" >> muestra
	

	if [[ $p = 0 ]]
		then
		echo "¿Desea introducir los datos por teclado? (s/n):"
      	read op
		
		while [ $op != "n" -a $op != "s" ];
   		do
 			echo "opcion incorrecta"
			echo "¿Desea introducir los datos por teclado? (s/n):"
			read op
		done
	fi
	# Si el usuario ha indicado que no quiere introducir los datos por teclado
	if [[ $op = "n" ]]
		then
		#lee los datos del fichero
		obtieneDeFichero
		#Introducimos los datos de los procesos en las variables correspondientes
		for (( i=0 ; i<${#proceso2[@]} ; i++ ))
		do
			proceso[${#proceso[@]}]=${proceso2[$i]}
			llegada[${#llegada[@]}]=${llegada2[$i]}
			tiempo[${#tiempo[@]}]=${tiempo2[$i]}
			memoria[${#memoria[@]}]=${memoria2[$i]}
		done

		#Ordenamos los procesos introducidos en el sistema
		if [[ ${#proceso[@]} -gt 1 ]]
			then
			ordenaProcesosEntrada
		fi

		#Montamos los datos de los procesos en una tabla para los informes y para la parte 
		#grafica
		for (( i=0 ; i<${#proceso[@]} ; i++ ))
		do
			echo "| 		${proceso[i]}		|		${llegada[i]}		 |		${tiempo[i]}			 |	 	${memoria[i]}		|" >> srpt.temp
			echo "_____________________________________________________________________" >> srpt.temp
		done

		var="no"
	#Si el usuario ha decidido meter los datos de los procesos por teclado
	else
		#pido el numero de particiones
		echo "Introduce el numero de particiones:"
		read nPart
		#compruebo que el dato introducido sea un numero
		CompruebaNumero $nPart
		#si no es un numero valido lo vuelvo a solicitar hasta que se introduzca 
		#un dato valido
		while [[ $numValido -eq 0 || $nPart -eq 0 ]]
		do
			echo "No has introducido un número entero positivo para el número de particiones."
			echo "Vuelve a introducirlo de forma correcta:"
			read nPart
			CompruebaNumero $nPart
		done
		#vuelco la informacion introducida al fichero entradaSRPT.txt
		echo "Numero de particiones $nPart" > entradaSRPT.txt
        #pido el tamaño de cada particion
		echo "Introduce el tamaño para cada partición:"
		read MEM
		#compruebo que el dato introducido sea un numero
		CompruebaNumero $MEM
		#si no es un numero valido lo vuelvo a solicitar hasta que se introduzca 
		#un dato valido
		while [[ $numValido -eq 0 || $MEM -eq 0 ]]
		do
			echo "No has introducido un número entero positivo para la memoria."
			echo "Vuelve a introducirlo de forma correcta:"
			read MEM
			CompruebaNumero $MEM
		done
		#vuelco la informacion introducida al fichero entradaSRPT.txt
		echo "Memoria de partición $MEM" >> entradaSRPT.txt
		
		#Mientras que el usuario siga queriendo introducir un proceso mas
		#solicito la informacion de un nuevo proceso
		while [[ $var == "si" || $var == "s" ]]
		do
			echo ""
			echo "Introduzca el nombre del proceso_$p:"
			read nombre
			echo "hereamai"
			#procedemos a comprobar si es correcto el nombre introducido
			acomprobar = 0
			while [ $acomprobar -ne 1 ]; #valido!=1
				do
					echo "aim in zorra"
					read nombre;
					if [Comprobarn $nombre -eq 1 && CompruebaNombre $nombre -eq 1]; then
						$valido = 1
					else
						echo "Nombre no valido vuelva a introducirlo ostias"
						read $nombre
					fi
			done
			proceso[$p]=$nombre; #añado a el vector ese nombre
			CompruebaNombre $nombre #comprueba que los nombres son distintos
			#hasta que no se introduzca un nombre valido y unico lo vuelvo a solicitar
			while [ $correcto -eq 1 ];
				do
					if [ -z $nombre ]
						then
							clear
							read -p "Entrada vacía no válida. Introduce un nombre:" nombre
					else
						read nombre
						Comprobarn $nombre  #envio nombre a comprobar por la funcion
						proceso[$p]=$nombre; #añado a el vector ese nombre
						CompruebaNombre $nombre #comprueba que los nombres son distintos
					fi
				done
				
            #Envio el nombre a la parte grafica
			echo -n "|	$nombre		|"  >> srpt.temp
			echo -n "|	$nombre		|"  >> muestra
			clear
			cat muestra
			
			
			#pido el tiempo de llegada
			echo ""
			echo "Tiempo De llegada:"
			read llegad

			CompruebaNumero $llegad
			
			#Hasta que no se intruduzca un tiempo de llegada valido vuelvo a pedirlo 
			while [[ $numValido -eq 0 ]]
			do
				echo "No has introducido un número entero positivo para el tiempo de llegada."
				echo "Vuelve a introducirlo de forma correcta:"
				read llegad
				CompruebaNumero $llegad
			done
			llegada[$p]=$llegad;   #añado al vector ese numero

			echo -n " 	 $llegad 		 |"  >> srpt.temp
			echo -n " 	 $llegad 		 |"  >> muestra
			clear
			cat muestra

			#pido el tiempo de ejecucion
			echo ""
			echo "Tiempo De Ejecución_$p"
			read tiemp
			CompruebaNumero $tiemp
			#Hasta que no se intruduzca un tiempo de ejecucion valido vuelvo a pedirlo 
			while [[ $numValido -eq 0 || $tiemp -eq 0 ]]
			do
				echo "No has introducido un número entero positivo para el tiempo de ejecución."
				echo "Vuelve a introducirlo de forma correcta:"
				read tiemp
				CompruebaNumero $tiemp
			done
		
			
			tiempo[$p]=$tiemp;   #añado al vector ese numero
			

			echo -n " 	 $tiemp 		 |"  >> srpt.temp
			echo -n " 	 $tiemp 		 |"  >> muestra
			clear
			cat muestra
			
			#pido el tamaño del proceso
			echo ""
			echo "Tamaño del proceso $p:"
			read mem
			CompruebaNumero $mem
			CompruebaTamaño $mem
			#Hasta que no se intruduzca un tamaño del proceso valido vuelvo a pedirlo 
			while [[ $numValido -eq 0 || $mem -eq 0 || $cabeProceso = "false" ]]
			do
				if [[ $mem =~ $es_numero ]]
					then
					if [[ $mem -eq 0 ]]
						then
						echo "El tamaño del proceso no puede ser 0"
						echo "Introduce un tamaño de proceso menor o igual que $MEM y mayor que 0"
					else
						echo "El tamaño del proceso es mayor que el de las particiones de memoria."
						echo "Introduce un tamaño de proceso menor o igual que $MEM"
					fi
				else
					echo "No has introducido un número entero positivo para el tamaño del proceso."
					echo "Vuelve a introducirlo de forma correcta:"
				fi
				read mem
				CompruebaNumero $mem
				CompruebaTamaño $mem
			done
		
			memoria[$p]=$mem

			echo -n " 	 $mem 		|"  >> srpt.temp
			echo -n " 	 $mem 		|"  >> muestra
			clear
			cat muestra
			

			echo ""
			
			echo Proceso $nombre Llegada $llegad Ejecucion $tiemp   >> informeSRPT.txt
			echo Proceso $nombre Llegada $llegad Ejecucion $tiemp   >> informeSRPTColor.txt
			
			echo "" >> srpt.temp
			echo "" >> muestra
			
			#Vuelco todos los datos introducidos manualmente a un fichero
			#por si el usuario quiere volver a lanzarlo de manera automatica
			#sin tener que introducirlos otra vez de manera manual
			datosAFichero
			
			#Si tengo mas de un proceso los ordeno
			if [[ ${#proceso[@]} -gt 1 ]]
				then
				ordenaProcesosEntrada
			fi
			
			#Construyo la parte grafica y la vuelco en el informe
			graficaPideDatosInforme

			echo " Desea introducir mas procesos?si/no"
			read var
			p=`expr $p + 1` #incremento el contador
			pp=`expr $pp + 1` #incremento el contador
	
		done
	fi

	#Copiamos los procesos ya ordenados en los vectores auxiliares, en caso de que hayamos introducido los datos por teclado.
	for (( i=0 ; i<${#proceso[@]} ; i++ ))
	do
		proceso1[${#proceso1[@]}]=${proceso[$i]}
		llegada1[${#llegada1[@]}]=${llegada[$i]}
		tiempo1[${#tiempo1[@]}]=${tiempo[$i]}
		memoria1[${#memoria1[@]}]=${memoria[$i]}
	done

	#Construyo la parte grafica
	clear
	cat srpt.temp >> informeSRPT.txt
	cat srpt.temp >> informeSRPTColor.txt
	rm srpt.temp
	graficaPideDatosPantalla
	
	echo "" >> informeSRPT.txt
	echo "" >> informeSRPTColor.txt
	echo "" 
	rm muestra
}


#########################################################################################
#																						#
#	Funcion que ordena por menor tiempo de ejecución los procesos que han tenido que 	#
#	ser sacados de la memoria y están a espera de poder continuar con la ejecución.	    #
#																						#
#########################################################################################
function ordenaPorTiempoLasEsperas() {

	for ((j=0;j<${#tiempoEspera[@]};j++))
 	do   # esto me indica ${#tiempo[@]} el tamaño de mi vector

 	for ((k=j;k<${#tiempoEspera[@]};k++))
 	do

     		a=${llegadaEspera[$j]};
            b=${llegadaEspera[$k]};    #Tiempo de llegada para comparar

            c=${tiempoEspera[$j]};   #Tiempo de ejecucion para comparar
            d=${tiempoEspera[$k]};

            if [ $c -gt $d ];
             then
                     aux=${tiempoEspera[$j]};
                     tiempoEspera[$j]=${tiempoEspera[$k]};   #para buscar el mayor
                     tiempoEspera[$k]=$aux;

                     aux1=${llegadaEspera[$j]};
                     llegadaEspera[$j]=${llegadaEspera[$k]};   #cambio tambien si llegada para mostrar al final 
                     llegadaEspera[$k]=$aux1;
                
                     aux2=${procesoEspera[$j]};
                     procesoEspera[$j]=${procesoEspera[$k]};  #para acomodar los nombres con sus mismos valores
                     procesoEspera[$k]=$aux2;

                     aux3=${memoriaEspera[$j]};
                     memoriaEspera[$j]=${memoriaEspera[$k]};  #para acomodar los nombres con sus mismos valores
                     memoriaEspera[$k]=$aux3;
             fi

             if [ $c -eq $d ];
             then
                if [ $b -gt $a ];
                    then
                     aux=${tiempoEspera[$j]};
                     tiempoEspera[$j]=${tiempoEspera[$k]};   #para buscar el mayor
                     tiempoEspera[$k]=$aux;

                     aux1=${llegadaEspera[$j]};
                     llegadaEspera[$j]=${llegadaEspera[$k]};   #cambio tambien si llegada para mostrar al final 
                     llegadaEspera[$k]=$aux1;
                
                     aux2=${procesoEspera[$j]};
                     procesoEspera[$j]=${procesoEspera[$k]};  #para acomodar los nombres con sus mismos valores
                     procesoEspera[$k]=$aux2;

                     aux3=${memoriaEspera[$j]};
                     memoriaEspera[$j]=${memoriaEspera[$k]};  #para acomodar los nombres con sus mismos valores
                     memoriaEspera[$k]=$aux3;
                 fi
             fi
     	 done
	done
}

#########################################################################################
#																						#
#	Funcion que elimina de la lista de espera el proceso que entra en memoria.			#
#																						#
#########################################################################################
function eliminaDeEspera(){
	cont=0
	particion=$1
	procesoEsperaAux=();
	llegadaEsperaAux=();
	tiempoEsperaAux=();
	memoriaEsperaAux=();
	restanteEsperaAux=();
	#Si hay mas de un proceso en espera
	if [[ ${#procesoEspera[@]} -gt 1 ]]
		then
		
		#copio en las listas auxiliares todos los procesos excepto el
		#primero que es el que quiero eliminar de la espera
		for (( n=1 ; n<${#procesoEspera[@]} ; n++ ))
		do
			procesoEsperaAux[$cont]=${procesoEspera[$n]}
			llegadaEsperaAux[$cont]=${llegadaEspera[$n]}
			tiempoEsperaAux[$cont]=${tiempoEspera[$n]}
			memoriaEsperaAux[$cont]=${memoriaEspera[$n]}
			restanteEsperaAux[$cont]=${restanteEspera[$n]}
			((cont++))
		done
		#elimino todos los datos de los arrays
		procesoEspera=();
		llegadaEspera=();
		tiempoEspera=();
		memoriaEspera=();
		restanteEspera=();
		#copio todos los datos de los arrays auxiliares donde ya 
		#no aparecera el primero que hemos eliminado
		for (( m=0 ; m<${#procesoEsperaAux[@]} ; m++ ))
		do
			procesoEspera[$m]=${procesoEsperaAux[$m]}
			llegadaEspera[$m]=${llegadaEsperaAux[$m]}
			tiempoEspera[$m]=${tiempoEsperaAux[$m]}
			memoriaEspera[$m]=${memoriaEsperaAux[$m]}
			restanteEspera[$m]=${restanteEsperaAux[$m]}
		done
	#si solo hay un proceso elimino el contenido de toda
	#la lista
	elif [[ ${#procesoEspera[@]} -eq 1 ]]
		then
		procesoEspera=();
		llegadaEspera=();
		tiempoEspera=();
		memoriaEspera=();
		restanteEspera=();
	fi
}

#########################################################################################
#																						#<F8>
#	Funcion que se encarga de simular el comportamiento del algoritmo SRPT a la 	    #
#	hora de seleccionar que proceso es el que va a ejecutar de los que están dentro de 	#
#	las particiones de memoria. Recibe como parametro la posicion del proceso que       #
#   queremos procesar																	#
#																						#
#########################################################################################
function procesaCPU(){
	partEjecu=$1
	#decremento en 1 el tiempo de ejecución que tiene
	resMem[$1]=$(( ${resMem[$partEjecu]} - 1 ))
	procesoEnCPU=${proMem[$1]}
	#llevo la cuenta de que proceso era el anterior
	#dejo las sentencias echo comentadas para poder activar las trazas en un futuro
	#echo !!!!!!!!!! + $anteriorEnCPU
	#echo !!!!!!!!!! + $procesoEnCPU
	if [ "$procesoEnCPU" != "" ];then
            if [ $anteriorEnCPU == $procesoEnCPU ]; then
                #echo iguales!!!!!
                anteriorEnCPU=$procesoEnCPU;
            else
                imprimoSalida=1
                anteriorEnCPU=$procesoEnCPU;
            fi
        #else
            #echo procesoEnCPU vacio
        
        fi
	
	#Recorro la lista de procesos
	for (( d=0 ; d<${#proceso[@]} ; d++ ))
	do
		#Si encuentro el proceso que quiero procesar en la lista
		#de procesos
		if [[ ${proMem[$1]} == ${proceso[$d]} ]]
			then
			#asigno el valor del tiempo restante anteriormente decrementado
			tiempoRestante[$d]=${resMem[$1]}
			#Si el tiempo que queda es 0
			#meto el proceso en la lista de procesos terminados
			#calculo su tiempo medio de retorno y de espera 
			#lo saco de las listas
			if [[ ${tiempoRestante[$d]} -eq 0 ]]
				then
				hayProcesoEnMemoria[$1]=0
				procesosTerminados[${#procesosTerminados[@]}]=${proMem[$1]}
				tMRetorno[${#tMRetorno[@]}]=$(( $t + 1 - ${lleMem[$1]} ))
				tMEspera[${#tMEspera[@]}]=$(( $t + 1 - ${lleMem[$1]} - tieMem[$1] ))
				proFinalizando=${proMem[$1]}
				tamFinalizando=${tamMem[$1]}
				parFinalizando=$1
				unset proMem[$1]
				unset lleMem[$1]
				unset tieMem[$1]
				unset resMem[$1]
				imprimoSalida=1
			fi
			#no tengo que seguir recorriendo la lista asi que salgo del for
			break 1
		fi
	done
}

#########################################################################################
#																						#
#	Funcion que imprime la tabla con la información de los procesos en                  #
#	cada uno de los tiempos del sistema.												#
#																						#
#########################################################################################
function imprimeTablas(){
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m"
	echo "________________________________________________________________________________________________________________________________________________" >> informeSRPT.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m" >> informeSRPTColor.txt
	if [[ $haFinalizado -eq 0 ]]
		then
		echo -e "\e[1;34m|								\e[1;96m------Tiempo de Sistema t=$t------								\e[1;34m|\e[0m"
		echo "|									------Tiempo de Sistema t=$t------																			|" >> informeSRPT.txt
		echo -e "\e[1;34m|								\e[1;96m------Tiempo de Sistema t=$t------								\e[1;34m|\e[0m" >> informeSRPTColor.txt
	else
		echo -e "\e[1;34m|								\e[1;36m-------Ejecución finalizada-------								\e[1;34m|\e[0m"
		echo "|										-------Ejecución finalizada-------																		|" >> informeSRPT.txt
		echo -e "\e[1;34m|								\e[1;36m-------Ejecución finalizada-------								\e[1;34m|\e[0m" >> informeSRPTColor.txt
	fi
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m"
	echo "________________________________________________________________________________________________________________________________________________" >> informeSRPT.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m" >> informeSRPTColor.txt
	echo -e "\e[1;34m| 	\e[1;35mProceso		\e[1;34m|	\e[1;35mT. Llegada	 \e[1;34m|	 \e[1;35mT.Ejecución	\e[1;34m|	 \e[1;35mMemoria	\e[1;34m|	 \e[1;35mT.restante	\e[1;34m|	 	\e[1;35mEstado			\e[1;34m|\e[0m"
	echo "| 	Proceso		|	T. Llegada	 |	T.Ejecución	|	 Memoria	|	 T.restante	|	 	Estado													|" >> informeSRPT.txt
	echo -e "\e[1;34m| 	\e[1;35mProceso		\e[1;34m|	\e[1;35mT. Llegada	 \e[1;34m|	 \e[1;35mT.Ejecución	\e[1;34m|	 \e[1;35mMemoria	\e[1;34m|	 \e[1;35mT.restante	\e[1;34m|	 	\e[1;35mEstado			\e[1;34m|\e[0m" >> informeSRPTColor.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m"
	echo "________________________________________________________________________________________________________________________________________________" >> informeSRPT.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m" >> informeSRPTColor.txt
	#Recorremos todos los procesos para mostrar su información
	#calculo la posicion inicial de el timeline de procesos
	#para saber si ha entrado alguno o no
	tamanoTimeline=${#procesosTimeLine[@]}
	espacio="*"	
	for (( w=0 ; w<${#proceso1[@]} ; w++ ))
	do
		estadoProceso=0
		#primero miro si el proceso esta en CPU para calcular su tiempo en CPU 
		if [[ ${proceso1[$w]} == $procesoEnCPU ]]
			then
			estadoProceso=1
			#Añado en el timeline
			procesosTimeLine[${#procesosTimeLine[@]}]=$procesoEnCPU;
			partCPU=0
			for (( p=0 ; p<$nPart ; p++ ))
			do
				if [[ ${proMem[$p]} == ${proceso1[$w]} ]]
					then
					if [[ ${resMem[$p]} -gt 0 ]]
						then
						partCPU=$(( $p + 1 ))
					fi
				fi
			done
			# si ha finalizado actualizo el estado del proceso
			if [[ $haFinalizado -eq 1 ]]
				then
				estadoProceso=3
			fi
			#lo imprimo
			imprimeProceso
			continue
		fi
		#En el caso de que el proceso este en espera actualizo su estado 
		#y lo imprimo
		for (( x=0 ; x<${#procesoEspera[@]} ; x++ ))
		do
			if [[ ${proceso1[$w]} == ${procesoEspera[$x]} ]]
				then
				estadoProceso=2
				imprimeProceso
				break 1
			fi
		done
		#En el caso de que el proceso este en la lista de terminados actualizo su estado 
		#y lo imprimo
		for (( l=0 ; l<${#procesosTerminados[@]} ; l++ ))
		do
			if [[ ${proceso1[$w]} == ${procesosTerminados[$l]} ]]
				then
				estadoProceso=3
				imprimeProceso
				break 1
			fi
		done
		#En el caso de que el proceso este en memoria actualizo su estado 
		#y lo imprimo
		for (( y=0 ; y<$nPart ; y++ ))
		do
			if [[ ${proceso1[$w]} == ${proMem[$y]} ]]
				then
				estadoProceso=4
				partMem=$(( $y + 1 ))
				imprimeProceso
				break 1
			fi
		done
		
		if [[ $estadoProceso -eq 0 ]]
			then
			proImpresos[${#proImpresos[@]}]=${proceso1[$w]}
			imprimeProceso
		fi
	done
	
	
	#En el caso de no haber proceso en CPU introduzco una linea
	if [[ tamanoTimeline -eq ${#procesosTimeLine[@]} ]]; then
            procesosTimeLine[${#procesosTimeLine[@]}]=$espacio;
	fi
	tamanoTimeline=${#procesosTimeLine[@]}
	
}



#########################################################################################
#																						#
#	Funcion que se encarga de mantener el timeline aun cuando no se imprime.			#
#																						#
#########################################################################################
function mantieneTimeline(){
	
	#Recorremos todos los procesos para mostrar su información
	#calculo la posicion inicial de el timeline de procesos
	#para saber si ha entrado alguno o no
	tamanoTimeline=${#procesosTimeLine[@]}
	espacio="*"	
	for (( w=0 ; w<${#proceso1[@]} ; w++ ))
	do
		estadoProceso=0
		#primero miro si el proceso esta en CPU para calcular su tiempo en CPU 
		if [[ ${proceso1[$w]} == $procesoEnCPU ]]
			then
			estadoProceso=1
			#Añado en el timeline
			procesosTimeLine[${#procesosTimeLine[@]}]=$procesoEnCPU;
			partCPU=0
			for (( p=0 ; p<$nPart ; p++ ))
			do
				if [[ ${proMem[$p]} == ${proceso1[$w]} ]]
					then
					if [[ ${resMem[$p]} -gt 0 ]]
						then
						partCPU=$(( $p + 1 ))
					fi
				fi
			done
			# si ha finalizado actualizo el estado del proceso
			if [[ $haFinalizado -eq 1 ]]
				then
				estadoProceso=3
			fi
			continue
		fi
		#En el caso de que el proceso este en espera actualizo su estado 
		#y lo imprimo
		for (( x=0 ; x<${#procesoEspera[@]} ; x++ ))
		do
			if [[ ${proceso1[$w]} == ${procesoEspera[$x]} ]]
				then
				estadoProceso=2
				break 1
			fi
		done
		#En el caso de que el proceso este en la lista de terminados actualizo su estado 
		#y lo imprimo
		for (( l=0 ; l<${#procesosTerminados[@]} ; l++ ))
		do
			if [[ ${proceso1[$w]} == ${procesosTerminados[$l]} ]]
				then
				estadoProceso=3
				break 1
			fi
		done
		#En el caso de que el proceso este en memoria actualizo su estado 
		#y lo imprimo
		for (( y=0 ; y<$nPart ; y++ ))
		do
			if [[ ${proceso1[$w]} == ${proMem[$y]} ]]
				then
				estadoProceso=4
				partMem=$(( $y + 1 ))
				break 1
			fi
		done
		
		if [[ $estadoProceso -eq 0 ]]
			then
			proImpresos[${#proImpresos[@]}]=${proceso1[$w]}
		fi
	done
	
	#En el caso de no haber proceso en CPU introduzco una linea
	if [[ tamanoTimeline -eq ${#procesosTimeLine[@]} ]]; then
            procesosTimeLine[${#procesosTimeLine[@]}]=$espacio;
	fi
	tamanoTimeline=${#procesosTimeLine[@]}
	
}

#########################################################################################
#																						#
#	Funcion que permite imprimir tanto por pantalla como por proceso la tabla del       #
#   estado de los procesos                                                              #
#																						#
#########################################################################################
function tablaImprimeProceso(){
	echo -e "\e[1;34m| 	\e[0m${proceso1[$w]}		\e[1;34m|	\e[0m${llegada1[$w]}		 \e[1;34m|	\e[0m${tiempo1[$w]}		\e[1;34m|	 \e[0m${memoria1[$w]}		\e[1;34m|	 \e[0m${tiempoRestante[$w]}		\e[1;34m|	\e[0m\e[$color$estadoImprime\e[0m\e[1;34m|\e[0m"
	echo "| 	${proceso1[$w]}			|	${llegada1[$w]}			 |	${tiempo1[$w]}			|	 ${memoria1[$w]}			|	 ${tiempoRestante[$w]}			|	$estadoImprimeFichero	|" >> informeSRPT.txt
	echo -e "\e[1;34m| 	\e[0m${proceso1[$w]}		\e[1;34m|	\e[0m${llegada1[$w]}		 \e[1;34m|	\e[0m${tiempo1[$w]}		\e[1;34m|	 \e[0m${memoria1[$w]}		\e[1;34m|	 \e[0m${tiempoRestante[$w]}		\e[1;34m|	\e[0m\e[$color$estadoImprime\e[0m\e[1;34m|\e[0m" >> informeSRPTColor.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m"
	echo "________________________________________________________________________________________________________________________________________________" >> informeSRPT.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m" >> informeSRPTColor.txt
}


#########################################################################################
#																						#
#	Esta función lo que hace es imprimir el estado de cada proceso en el instante en el #
#	que se procede a la impresión por pantalla.
#																						#
#########################################################################################
function imprimeProceso(){
	case $estadoProceso in
			0)	estadoImprime="No ha llegado al sistema	"
				estadoImprimeFichero="No ha llegado al sistema								"
				color="31m";;
			1)	if [[ $partCPU -eq 0 ]]
				then
					estadoImprime="Ejecutando CPU (Finalizando)	"
					estadoImprimeFichero="Ejecutando CPU (Finalizando)							"
				else
					estadoImprime="Ejecutando CPU (Part. $partCPU)	"
					estadoImprimeFichero="Ejecutando CPU (Part. $partCPU)								"
				fi
				color="48;5;34m";;
			2)	estadoImprime="No ha podido entrar en memoria	"
				estadoImprimeFichero="No ha podido entrar en memoria							"
				color="48;5;19m";;
			3)	estadoImprime="Ha finalizado			"
				estadoImprimeFichero="Ha finalizado											"
				color="32m";;
			4)	estadoImprime="Está en partición $partMem		"
				estadoImprimeFichero="Está en partición $partMem										"
				color="33m";;
	esac
	tablaImprimeProceso
}

#########################################################################################
#																						#
#	Funcion que vuelca en el fichero de salida informeSRPT.txt la cabecera de la        #
#   informacion sobre particiones                                                       #
#																						#
#########################################################################################
function cabeceraImprimeMemoriaInforme(){
	echo -e "\e[1;34m|								\e[1;35mEstado de la memoria del sistema								\e[1;34m|\e[0m"
	echo "|									Estado de la memoria del sistema																			|" >> informeSRPT.txt
	echo -e "\e[1;34m|								\e[1;35mEstado de la memoria del sistema								\e[1;34m|\e[0m" >> informeSRPTColor.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m"
	echo "________________________________________________________________________________________________________________________________________________" >> informeSRPT.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m" >> informeSRPTColor.txt
	echo -e "\e[1;34m|	\e[1;35mLeyenda:	\e[41m \e[0m - \e[36mParte vacía de la memoria.	\e[1;32mNomProceso\e[0m - \e[36mParte ocupada por un proceso.	\e[1;96m|\e[0m - \e[36mDivisor de particiones.				\e[1;34m|\e[0m"
	echo "|				Leyenda:	# - Parte vacía de la memoria.	NomProceso - Parte ocupada por un proceso.	| - Divisor de particiones.				|" >> informeSRPT.txt
	echo -e "\e[1;34m|	\e[1;35mLeyenda:	\e[41m \e[0m - \e[36mParte vacía de la memoria.	\e[1;32mNomProceso\e[0m - \e[36mParte ocupada por un proceso.	\e[1;96m|\e[0m - \e[36mDivisor de particiones.				\e[1;34m|\e[0m" >> informeSRPTColor.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m"
	echo "________________________________________________________________________________________________________________________________________________" >> informeSRPT.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m" >> informeSRPTColor.txt
	echo ""
}

#########################################################################################
#											#
#	Funcion que vuelca en el fichero de salida informeSRPT.txt la cabecera de la    #
#   informacion sobre el timeline                                                       #
#				                      					#
#########################################################################################

function cabeceraImprimeTimelineInforme(){
	echo -e "\e[1;34m|								\e[1;35mTimeLine de sistema								                \e[1;34m|\e[0m"
	echo "|									TimeLine de sistema																			|" >> informeSRPT.txt
	echo -e "\e[1;34m|								\e[1;35mTimeLine de sistema								                \e[1;34m|\e[0m" >> informeSRPTColor.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m"
	echo "________________________________________________________________________________________________________________________________________________" >> informeSRPT.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m" >> informeSRPTColor.txt
		
	echo ""
}

#########################################################################################
#																						#
#	Funcion que imprime el timeLine de los procesos                                                       #
#																						#
#########################################################################################

function imprimeTimeline(){
    cabeceraImprimeTimelineInforme
    #imprimo el timeLine
    #variable para controlar el ancho de la linea
    cuentaCaracteresTimeline=0;
    for (( time=0 ; time<${#procesosTimeLine[@]} ; time++ ))
    do
        echo -ne "\e[1;34m| \e[1;37m$time:${procesosTimeLine[$time]} "
        echo -ne "| $time:${procesosTimeLine[$time]} ">> informeSRPT.txt
        echo -ne "\e[1;34m| \e[1;37m$time:${procesosTimeLine[$time]} ">> informeSRPTColor.txt
        if [ $cuentaCaracteresTimeline -eq 20 ];then
		echo ""
                echo "" >> informeSRPT.txt
                echo "" >> informeSRPTColor.txt
		cuentaCaracteresTimeline=0
	fi
	cuentaCaracteresTimeline=`expr $cuentaCaracteresTimeline + 1`; #incremento el contador
    done
    echo -ne "\e[1;34m|"
    echo "|" >> informeSRPT.txt
    echo -ne "\e[1;34m|"  >> informeSRPTColor.txt 
    echo ""
    echo "" >> informeSRPTColor.txt 
    echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m"
    echo "________________________________________________________________________________________________________________________________________________" >> informeSRPT.txt
    echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m" >> informeSRPTColor.txt 
}


#########################################################################################
#																						#
#	Funcion que gestiona la memoria cuando no se realiza la impresion por pantalla      #
#																						#
#########################################################################################
function mantieneMemoria(){
	#cada unidad de tamaño de la memoria va a corresponder a un caracter por eso tendremos un numero total 
	#de (numero de unidades de memoria)*(numero de particiones)
	numeroCaracteres=$(( $nPart * $MEM ))
	#calculo el numero de separadores que voy a necesitar
	numeroSeparadores=$(( $nPart - 1 ))
	#calculo el numero de caracteres totales que voy a mostrar para controlar que no me paso
	caracteresTotales=$(( $numeroSeparadores + $numeroCaracteres ))
	#miro si el numero de caracteres totales es un numero par y si no lo es le sumo 1
	if [[ $(( $caracteresTotales % 2 )) -ne 0 ]]
		then
		caracteresTotales=$(( $caracteresTotales + 1 ))
	fi
	#miro si el numero de caracteres es mayor de 70 para ver cuantas lineas voy a necesitar
	#en el caso de ser menor se que necesito solo 1 linea y en el caso de ser mayor calculo cuantas lineas 
	#voy a necestitar
	if [[ $caracteresTotales -gt 70 && $(( $caracteresTotales % 70 )) -gt 0 ]]
		then
		caracteresPorLinea=$(( $caracteresTotales / (($caracteresTotales / 70) + 1) ))
	else
		caracteresPorLinea=$caracteresTotales
	fi
	cuentaCaracteres=0
	nSeparadores=0
	
		
	#recorro cada una de las particones y voy pintando
	for (( pa=0 ; pa<$nPart ; pa++ ))
	do
		#recorro todas las posiciones de memoria de la particion
		#y voy pintando
		for (( cont=0 ; cont<$MEM ; cont++ ))
		do
			
			if [[ $cuentaCaracteres -eq $caracteresPorLinea ]]
				then
				cuentaCaracteres=0
			fi
			
			cuentaCaracteres=$(( $cuentaCaracteres + 1 ))
		done
		#si he finalizado todos los caracteres de la linea la finalizo 
		#y preparo el contador para la siguiente
		if [[ $cuentaCaracteres -eq $caracteresPorLinea ]]
			then
			cuentaCaracteres=0
		fi
		
		if [[ $parFinalizando -eq $pa && -n $proFinalizando ]]
			then
			unset proFinalizando
			unset tamFinalizando
			unset parFinalizando
		fi
		#si me quedan separadores por poner los pongo
		if [[ $nSeparadores -lt $numeroSeparadores ]]
			then
			cuentaCaracteres=$(( $cuentaCaracteres + 1 ))
			nSeparadores=$(( $nSeparadores + 1 ))
		fi
	done
}



#########################################################################################
#																						#
#	Funcion que imprime el estado de las particiones de la memoria en 	                #
#	cada uno de los instantes del sistema. Ademas, para evitar que salga todo en una    #
#   linea calcula un ancho de 70 caracteres por linea para hacer una paginacion         #
#   automatica                                                                          #
#																						#
#########################################################################################
function imprimeMemoria(){
	#cada unidad de tamaño de la memoria va a corresponder a un caracter por eso tendremos un numero total 
	#de (numero de unidades de memoria)*(numero de particiones)
	numeroCaracteres=$(( $nPart * $MEM ))
	#calculo el numero de separadores que voy a necesitar
	numeroSeparadores=$(( $nPart - 1 ))
	#calculo el numero de caracteres totales que voy a mostrar para controlar que no me paso
	caracteresTotales=$(( $numeroSeparadores + $numeroCaracteres ))
	#miro si el numero de caracteres totales es un numero par y si no lo es le sumo 1
	if [[ $(( $caracteresTotales % 2 )) -ne 0 ]]
		then
		caracteresTotales=$(( $caracteresTotales + 1 ))
	fi
	#miro si el numero de caracteres es mayor de 70 para ver cuantas lineas voy a necesitar
	#en el caso de ser menor se que necesito solo 1 linea y en el caso de ser mayor calculo cuantas lineas 
	#voy a necestitar
	if [[ $caracteresTotales -gt 70 && $(( $caracteresTotales % 70 )) -gt 0 ]]
		then
		caracteresPorLinea=$(( $caracteresTotales / (($caracteresTotales / 70) + 1) ))
	else
		caracteresPorLinea=$caracteresTotales
	fi
	cuentaCaracteres=0
	nSeparadores=0
	#imprimo la cabecera del informe
	cabeceraImprimeMemoriaInforme
	
		
	#recorro cada una de las particones y voy pintando
	for (( pa=0 ; pa<$nPart ; pa++ ))
	do
		if [[ $pa -eq 0 ]]
			then
			echo -n "	"
			echo -n "	" >> informeSRPT.txt
			echo -n "	" >> informeSRPTColor.txt
		fi
		#recorro todas las posiciones de memoria de la particion
		#y voy pintando
		for (( cont=0 ; cont<$MEM ; cont++ ))
		do
			
			if [[ $cuentaCaracteres -eq $caracteresPorLinea ]]
				then
				echo ""
				echo ""
				echo -n "	"
				echo "" >> informeSRPT.txt
				echo "" >> informeSRPT.txt
				echo -n "	" >> informeSRPT.txt
				echo "" >> informeSRPTColor.txt
				echo "" >> informeSRPTColor.txt
				echo -n "	" >> informeSRPTColor.txt
				cuentaCaracteres=0
			fi
			#compruebo si el proceso ha finalizado y lo muestro por pantalla
			if [[ $parFinalizando -eq $pa && -n $proFinalizando ]]
				then
				if [[ $cont -lt $tamFinalizando ]]
					then
					echo -ne "\e[1;32m$proFinalizando\e[0m "
					echo -n "$proFinalizando " >> informeSRPT.txt
					echo -ne "\e[1;32m$proFinalizando\e[0m " >> informeSRPTColor.txt
				else
					echo -ne "\e[41m \e[0m "
					echo -n "# " >> informeSRPT.txt
					echo -ne "\e[41m \e[0m " >> informeSRPTColor.txt
				fi
			else
				#Si no ha finalizado porque esta en memoria y me queda memoria por pintar
				#la pinto
				if [[ -n ${proMem[$pa]} && $cont -lt ${tamMem[$pa]} ]]
					then
					echo -ne "\e[1;32m${proMem[$pa]}\e[0m "
					echo -n "${proMem[$pa]} " >> informeSRPT.txt
					echo -ne "\e[1;32m${proMem[$pa]}\e[0m "  >> informeSRPTColor.txt
				else
					echo -ne "\e[41m \e[0m "
					echo -n "# " >> informeSRPT.txt
					echo -ne "\e[41m \e[0m " >> informeSRPTColor.txt
				fi
			fi
			cuentaCaracteres=$(( $cuentaCaracteres + 1 ))
		done
		#si he finalizado todos los caracteres de la linea la finalizo 
		#y preparo el contador para la siguiente
		if [[ $cuentaCaracteres -eq $caracteresPorLinea ]]
			then
			echo ""
                        echo ""
			echo -n "	"
			echo "" >> informeSRPT.txt
			echo "" >> informeSRPT.txt
			echo -n "	" >> informeSRPT.txt
			echo "" >> informeSRPTColor.txt
			echo "" >> informeSRPTColor.txt
			echo -n "	" >> informeSRPTColor.txt
			cuentaCaracteres=0
		fi
		
		if [[ $parFinalizando -eq $pa && -n $proFinalizando ]]
			then
			unset proFinalizando
			unset tamFinalizando
			unset parFinalizando
		fi
		#si me quedan separadores por poner los pongo
		if [[ $nSeparadores -lt $numeroSeparadores ]]
			then
			echo -ne "\e[1;96m|\e[0m "
			echo -n "| " >> informeSRPT.txt
			echo -ne "\e[1;96m|\e[0m " >> informeSRPTColor.txt
			cuentaCaracteres=$(( $cuentaCaracteres + 1 ))
			nSeparadores=$(( $nSeparadores + 1 ))
		fi
	done
	echo ""
	echo "" >> informeSRPT.txt
	echo "" >> informeSRPTColor.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m"
	echo "________________________________________________________________________________________________________________________________________________" >> informeSRPT.txt
	echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m" >> informeSRPTColor.txt
	
}

#########################################################################################
#																						#
#	Funcion que se encarga de imprimir por pantalla la cabecera del apartado de las  	#
#   medias                                                                              #
#																						#
#########################################################################################
function cabeceraCalculaMedias(){
    #calculo de medias, añado esta informacion en el informe
    echo -e "\e[1;34m|			\e[1;35mTiempo Medio de Espera				\e[1;34m|			\e[1;35mTiempo Medio de Retorno						\e[1;34m|\e[0m"
    echo "|                                     Tiempo Medio de Espera			  |			       Tiempo Medio de Retorno						|" >> informeSRPT.txt
    echo -e "\e[1;34m|			\e[1;35mTiempo Medio de Espera				\e[1;34m|			\e[1;35mTiempo Medio de Retorno						\e[1;34m|\e[0m" >> informeSRPTColor.txt
    echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m"
    echo "_________________________________________________________________________________________________________________________________________________________________">> informeSRPT.txt
    echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m">> informeSRPTColor.txt
    
    echo -e "\e[1;34m|				\e[0m$mediaEspera,$mediaEsperaDecimales					\e[1;34m|				\e[0m$mediaRetorno,$mediaRetornoDecimales							\e[1;34m|\e[0m"
    echo -e "|				$mediaEspera,$mediaEsperaDecimales					|				$mediaRetorno,$mediaRetornoDecimales							|">> informeSRPT.txt
    echo -e "\e[1;34m|				\e[0m$mediaEspera,$mediaEsperaDecimales					\e[1;34m|				\e[0m$mediaRetorno,$mediaRetornoDecimales							\e[1;34m|\e[0m">>informeSRPTColor.txt
    echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m"
    echo "_________________________________________________________________________________________________________________________________________________________________">> informeSRPT.txt
    echo -e "\e[1;34m_________________________________________________________________________________________________________________________________________________________________\e[0m">> informeSRPTColor.txt
}

#########################################################################################
#																						#
#	Funcion que se encarga de calcular el tiempo medio de espera y el tiempo 		    #
#	de retorno una vez que ya han terminado la ejecución todos los procesos.			#
#																						#
#########################################################################################
function calculaMedias(){
	mediaEspera=0
	mediaRetorno=0
	# hago los sumatorios del tiempo medio de espera y de 
	#retorno respectivamente
	for (( i=0 ; i<${#tMEspera[@]} ; i++ ))
	do
		mediaEspera=$(( $mediaEspera + ${tMEspera[$i]} ))
		mediaRetorno=$(( $mediaRetorno + ${tMRetorno[$i]} ))
	done
	mediaEspera=$(( $mediaEspera / ${#tMEspera[@]} ))
	mediaEsperaDecimales=$(( $mediaEspera % ${#tMEspera[@]} ))
	mediaRetorno=$(( $mediaRetorno / ${#tMRetorno[@]} ))
	mediaRetornoDecimales=$(( $mediaRetorno % ${#tMRetorno[@]} ))

    #imprimo por pantalla los calculos del tiempo medio de espera
	#y del tiempo medio de retorno
	cabeceraCalculaMedias
}

#########################################################################################
#																						#
#	Funcion que simula el comportamiento de una memoria con particiones                 #
#   fijas e iguales.			                                                        #                 
#																						#
#########################################################################################
function memoria(){
	#para cada proceso realizo una copia del tiempo que le queda en otra lista
	for (( e<0 ; e<${#proceso[@]} ; e++ ))
	do
		tiempoRestante[$e]=${tiempo[$e]}
	done
	#pongo a 0 toda la lista de procesos en memoria para recalcularlo
	for (( n<0 ; n<$nPart ; n++ ))
	do
		hayProcesoEnMemoria[$n]=0
	done
	#Aumento el tieempo del sistema con el tiempo que llevo
	for (( i = 0; i < ${#proceso[@]};i++)) 
	do 
	   tSistema=$(($tSistema+${tiempo[$i]})); 
	   procesoEjecu[$i]=0;
	   procesLlegan[$i]=0;
	   tEjecucionAux[$i]=0;
	   #solucionado bug al comparar numeros como cadenas
	   if [[ ${llegada[$i]} -gt $max ]] 
	   then 
	     max=${llegada[$i]};
	   fi
	done

	tSistema=$(($tSistema+$max));

	#Bucle tiempo
	for (( t = 0 ; t <= $tSistema ; t++))
	do
		procesoEnCPU=0
		#para cada proceso miro si su tiempo de llegada coincide con el tiempo en el que esta
		#actualmente la iteracion del script
		for (( u=0 ; u < ${#proceso[@]} ; u++ ))
		do
			#Si el tiempo del sistema coincide con el proceso actual, lo añadimos a la lista de espera.
			if [[ ${llegada[$u]} -eq $t ]]
				then
				procesoEspera[${#procesoEspera[@]}]=${proceso[$u]}
				llegadaEspera[${#llegadaEspera[@]}]=${llegada[$u]}
				tiempoEspera[${#tiempoEspera[@]}]=${tiempo[$u]}
				memoriaEspera[${#memoriaEspera[@]}]=${memoria[$u]}
				restanteEspera[${#restanteEspera[@]}]=${tiempoRestante[$u]}
				imprimoSalida=1
			fi
		done
		#Si hay procesos a la espera de entrar en memoria
		if [[ ${#procesoEspera[@]} -ne 0 ]]
			then
			entraEnMemoria="true"
			haEntrado=0
			cuentaParticiones=0
			#Recorro todas las particiones mirando si hay algun procesos en memoria y si estan 
			#en la lista de espera. Si esta en la lista de espera es que ya se ha cumplido su tiempo de llegada
            #y en ese caso lo meto en el sistema
			for (( p=0 ; p<$nPart ; p++ ))
			do
					if [[ ${hayProcesoEnMemoria[$p]} -eq 0 && ${#procesoEspera[@]} -ne 0 ]]
						then
						hayProcesoEnMemoria[$p]=1
						proMem[$p]=${procesoEspera[0]}
						lleMem[$p]=${llegadaEspera[0]}
						tieMem[$p]=${tiempoEspera[0]}
						tamMem[$p]=${memoriaEspera[0]}
						resMem[$p]=${restanteEspera[0]}
						eliminaDeEspera
						haEntrado=1
						imprimoSalida=1
					fi
			done
		fi
		llegadaCompara=();
		restanteCompara=();
		partCompara=();
		#recorro el bucle de particiones paraa mirar donde no hay proceso y poder introducirlo en ella
		for (( p=0 ; p<$nPart ; p++ ))
		do
			if [[ ${hayProcesoEnMemoria[$p]} -eq 1 ]] #Si hay proceso en la partición
				then
				restanteCompara[${#restanteCompara[@]}]=${resMem[$p]}
				llegadaCompara[${#llegadaCompara[@]}]=${lleMem[$p]}
				partCompara[${#partCompara[@]}]=$p 
			fi
		done
		#Ordenamos para saber que proceso es el que tiene un tiempo restante menor
		if [[ ${#restanteCompara[@]} -gt 1 ]]
			then
			for ((j=0;j<${#restanteCompara[@]};j++))
		 	do   # esto me indica ${#tiempo[@]} el tamaño de mi vector

			 	for ((k=j;k<${#restanteCompara[@]};k++))
			 	do
		            c=${restanteCompara[$j]};   #Tiempo de ejecucion para comparar
		            d=${restanteCompara[$k]};

		            if [[ $c -eq $d ]]
		            	then
		            	if [[ ${llegadaCompara[$k]} -lt ${llegadaCompara[$j]} ]]
		            		then
		            		aux=${restanteCompara[$j]};
			                restanteCompara[$j]=${restanteCompara[$k]};   #para buscar el mayor
			                restanteCompara[$k]=$aux;

			                aux1=${partCompara[$j]};
			                partCompara[$j]=${partCompara[$k]};   #cambio tambien si llegada para mostrar al final 
			                partCompara[$k]=$aux1;

			                aux3=${llegadaCompara[$j]};
			                llegadaCompara[$j]=${llegadaCompara[$k]};
			                llegadaCompara[$k]=$aux2;
			            fi
		            elif [ $c -gt $d ];
		            	then
		            	aux=${restanteCompara[$j]};
		                restanteCompara[$j]=${restanteCompara[$k]};   #para buscar el mayor
		                restanteCompara[$k]=$aux;

		                aux1=${partCompara[$j]};
		                partCompara[$j]=${partCompara[$k]};   #cambio tambien si llegada para mostrar al final 
		                partCompara[$k]=$aux1;

		                aux2=${llegadaCompara[$j]};
		                llegadaCompara[$j]=${llegadaCompara[$k]};
		                llegadaCompara[$k]=$aux2;
		            fi
		     	 done
			done
		fi
		#ejecuto el tiempo de CPU del proceso
		#RAE Comparo
		procesaCPU ${partCompara[0]}
		#RAE Si hay cambios
        if [[ $imprimoSalida -eq 1 ]]; then 
			#imprimo la informacion de esta iteracion por pantalla
			imprimeTablas
			#Imprimotimeline
			imprimeTimeline
			#vuelco la informacion en la memoria
			imprimeMemoria
			echo "" >> informeSRPT.txt
			echo "" >> informeSRPT.txt
			echo "" >> informeSRPTColor.txt
			echo "" >> informeSRPTColor.txt
		else
			mantieneTimeline
			mantieneMemoria
		fi
		#si en esta iteracion ha finalizado y era el ultimo proceso lo marco, calculo sus medias
		#y lanzo finalizaEjecucion del script
		if [[ ${#procesosTerminados[@]} -eq ${#proceso1[@]} ]];
			then
			haFinalizado=1
			echo ""
			echo "Pulsa INTRO para continuar..."
			read

			clear
			echo  >> informeSRPT.txt
			echo  >> informeSRPT.txt
			echo "" >> informeSRPTColor.txt
			echo "" >> informeSRPTColor.txt
			imprimeTablas
			calculaMedias
			finalizaEjecucion
			exit
		fi
		if [[ $imprimoSalida -eq 1 ]]; then #Si hay cambios
			echo ""
			echo "Pulsa INTRO para continuar..."
			read
			clear
			imprimoSalida=0
		fi
	done
}


#########################################################################################
#																						#
#	Funcion que indica al usuario y añade al informe que va a comenzar la simulación.	#
#																						#
#																						#
#########################################################################################
function iniciaSimulación(){
	echo "Pulsa INTRO para iniciar la simulación..."
	echo "Pulsa INTRO para iniciar la simulación..." >> informeSRPT.txt
	echo "Pulsa INTRO para iniciar la simulación..." >> informeSRPTColor.txt
	read
	clear
}

#########################################################################################
#																						#
#	Funcion que pide al usuario si quiere finalizar o visualizar el 	                #
#	informe de la simulación y finaliza la ejecución del script.						#
#																						#
#########################################################################################
function finalizaEjecucion(){
	read -p "¿Quieres abrir el informe? ([s],n): " datos
	if [ -z "${datos}" ]
		then
		datos="s"
	fi
	#si me introducen un caracter distinto a s o n vuelvo a pedir el valor
	while [ "${datos}" != "s" -a "${datos}" != "n" ]
	do
		read -p "Entrada no válida, vuelve a intentarlo. ¿Quieres abrir el informe? ([s],n): " datos
		if [ -z "${datos}" ]
			then
			datos="s"
		fi
	done
	#si indicamos una s lo abre con el editor pluma
	if [ $datos = "s" ]
		then
		#lo abre con pluma un fork de gedit 2, si no esta instalado dara error
		#lo abro con libreoffice
		libreoffice informeSRPT.txt
	fi
	echo ""
	echo "Finalizamos la ejecución del script."
	echo "" >> informeSRPT.txt
	echo "Finalizamos la ejecución del script." >> informeSRPT.txt
	echo "" >> informeSRPTColor.txt
	echo "Finalizamos la ejecución del script." >> informeSRPTColor.txt
	exit
}
licencia
licencia > informeSRPT.txt
licencia > informeSRPTColor.txt
algoritmo
autoria >> informeSRPT.txt
algoritmo >> informeSRPTColor.txt
inicializaVariables
creaInforme
pideDatos
iniciaSimulación
memoria

exit 0
