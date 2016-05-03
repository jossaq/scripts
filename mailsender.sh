#! /usr/bin/bash

#body=$'Hola \nComo estas\nEspero que todo bien'
#body="$body Cómo estás? \n"
#body="$body Espero que todo bien \n"
#to="jossaq@gmail.com"

input="/home/jossaq/Documents/Personal/UdeM/Ciberseguridad/correo.csv"
while IFS=';' read -r lineas
do

	#IFS="," read -a datos <<< $lineas
	#echo $lineas
	#datos=(`echo $lineas | tr ";" "\n"`)
	#printf 'Hola %s\nTu nota de %s es %s\nLa bonificación es %s\nEspero que todo esté bien\n' ${datos[0]} ${datos[4]} ${datos[2]} ${datos[3]}
	OLD_IFS="$IFS"
	IFS=";"
	datos=( $lineas )
	#IFS="$OLD_IFS"
	body=$(printf '%s buen día\n\n\nTe envío los resultados de  %s:\nCalificación: %s\nLa bonificación te quedó en: %s\nGracias\n' ${datos[0]} ${datos[2]} ${datos[3]} ${datos[4]})

	email -s "[Ciberseguridad] Calificación Practica 2" ${datos[1]} <<< "$body"

#echo "$body"
done < "$input"
