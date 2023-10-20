#! /bin/bash
#1. Rep com a únic paràmetre una carpeta ROOT.
carpeta=$1
rutaUsers=$1'/USERS.TXT'
rutaGroups=$1'/GROUPS.TXT'

#2. Comprovar que els arxius existeixen.
if [ -e $rutaUsers ];
then
	existeixFitxerUsers=true;
	echo "OK: El fitxer USERS.TXT existeix.";
else
	existeixFitxerUsers=false;
	echo "ERR: El fitxer USERS.TXT no existeix. Finalitza l'script.";
fi;

if [ -e $rutaGroups ];
then
	existeixFitxerGroups=true;
	echo "OK: El fitxer GROUPS.TXT existeix.";
else
	existeixFitxerGroups=false;
	echo "ERR: El fitxer GROUPS.TXT no existeix. Finalitza l'script.";
fi;

#3. Si no existeix l'usuari, el crearà amb els paràmetres per defecte, excepte el grup principal, que serà assignat només en el cas d'aparèixer a GROUPS.TXT.
if [ $existeixFitxerUsers = true ] && [ $existeixFitxerGroups = true ];
then
	
	for nomUser in $(cat $rutaUsers);
	do
		getent passwd $nomUser > /dev/null;
		if [ $? = 0 ];
		then
			echo "L'usuari "$nomUser" existeix en el nostre sistema."
		else
			#pels usuaris que tenen assignat gid (g1 o g2)
			grep $nomUser $rutaGroups > /dev/null;
			if [ $? = 0 ];
			then
				for nomGrupUser in $(cat $rutaGroups);
				do
					nomUsuariGroups=$(echo $nomGrupUser | cut -d: -f1);
					grupUsuariGroups=$(echo $nomGrupUser | cut -d: -f2);
					
					if [ $nomUser = $nomUsuariGroups ];
					then
						#creo el grup si no existeix
						getent group "$grupUsuariGroups" > /dev/null;
						if [ $? = 2 ];
						then
							groupadd $grupUsuariGroups;
						fi;
						
						#creo l'usuari		
						useradd -m -g $grupUsuariGroups $nomUsuariGroups;
						getent group $grupUsuariGroups;
						echo "useradd -m -g "$grupUsuariGroups" "$nomUsuariGroups;

					fi;
				done;
			
			else
				#pels usuaris que no tenen assignat gid (ni g1 ni g2)
				useradd -m $nomUser;
				echo "useradd -m "$nomUser;
			fi;

		fi;		
	done;
fi;




