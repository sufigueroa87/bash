#! /bin/bash

#1. Rep com a únic paràmetre una carpeta ROOT.
carpeta=$1
rutaUsers=$1'/USERS.TXT'
rutaGroups=$1'/GROUPS.TXT'


#2. Comprovar que els arxius existeixen.
if [ -e $rutaUsers ];
then
	existeixFitxerUsers=true;
	echo "OK: El fitxer USERS.TXT existeix."
else
	existeixFitxerUsers=false;
	echo "ERR: El fitxer USERS.TXT no existeix. Finalitza l'script."
fi;

if [ -e $rutaGroups ];
then
	existeixFitxerGroups=true;
	echo "OK: El fitxer GROUPS.TXT existeix.";
else
	existeixFitxerGroups=false;
	echo "ERR: El fitxer GROUPS.TXT no existeix. Finalitza l'script.";
fi;


#3. Elimina els usuaris que es troben a USERS.TXT si existeixen al sistema.
if [ $existeixFitxerUsers = true ] && [ $existeixFitxerGroups = true ];
then
	
	for usuari in $(cat $rutaUsers);
	do
		getent passwd $usuari > /dev/null;
		if [ $? = 0 ];
		then
			#elimino el grup de l'usuari a eliminar
			grup=$(groups $usuari | cut -d':' -f2);
			#quan existeixi el grup, l'output vagi a /dev/null.
			#quan no existeixi el grup (error 2), l'output vagi a la sortida estàndard (&1) /dev/null
			getent group $grup > /dev/null 2>&1;
			if [ $? = 0 ];
			then
				groupdel -f $grup; 
			fi;
			
			#elimino l'usuari
			echo "Eliminem l'usuari "$usuari".";
			userdel -r $usuari;
			echo "Usuari "$usuari" eliminat.";
		else
			echo "No existeix l'usuari "$usuari"."
		fi;		
	done;
fi;
