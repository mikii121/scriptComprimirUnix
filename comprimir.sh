#!/bin/bash
#*********************************************************************************
# Nombre del shell script: comprimir.sh
# Descripcion: Comprime el archivo/carpeta que le pases como parametro
# Parametros: Nombre_Archivo tipo_cpmpresion
# Autor: Miguel Andrés (mac_121@hotmail.com)

#*********************************************************************************

#funciones
function ayuda {
	echo ""
	echo "Programa que comprime el archivo/carpeta que le pases como argumento."
	echo ""
	echo "Usage:"
	echo $'\t'"./tree.sh [PARAMS]"
	echo ""
	echo "Options:"
	echo $'\t'"[-h|--help] "$'\t'""$'\t'" Muestra el siguiente mensaje de ayuda."
	echo $'\t'"[-d|--dir directorio] "$'\t'" Directorio que queremos comprimir."
	echo $'\t'"[-c|--compresion tipo] "$'\t'" Tipo de compresión que usaremos."
	echo $'\t'""$'\t'""$'\t'""$'\t'" tar.gz | zip | rar | tar | gz."
	echo $'\t'"[-f|--file archivo] "$'\t'" Archivo que vamos a comprimir."
	echo $'\t'"[-u|--uncompress] "$'\t'" Descomprimir un archivo comprimido."
	echo $'\t'""$'\t'""$'\t'""$'\t'" Debes utilizar la opción -f para elegir el archivo."
	echo ""
}


# Mientras el número de argumentos NO SEA 0
while [ $# -ne 0 ]
do
    case "$1" in
    -h|--help)
        ayuda	
		exit 2
        ;;
	-d|--dir)
        DIRECTORIO=$2	
		shift
        ;;
	-c|--compresion)
        COMPRESION=$2	
		shift
        ;;
	-f|--file)
        ARCHIVO=$2	
		shift
        ;;
	-u|--uncompress)
        DESCOMPRIMIR=1
        ;;
    *)
        echo "comprimir: illegal option -- $1."
		ayuda
        exit 2
        ;;
    esac
    shift
done

#condiciones
if [ -z "$DIRECTORIO" ]
then
	if [ -z "$ARCHIVO" ]
	then
		if [ -z "$DESCOMPRIMIR" ]
		then
			echo "Debes introducir un directorio o un archivo."
			ayuda
			exit 2
		else
			echo "Debes introducir un archivo (-f file)."
			ayuda
			exit 2
		fi
	fi
fi
if [ -z "$COMPRESION" ]
then
	if [ -z "$DESCOMPRIMIR" ]
	then
		echo "Debes introducir el formato de compresion/descompresion que desea utilizar."
		ayuda
		exit 2
	fi
fi


#ejecucion del programa
DIRECTORIO=$(echo $DIRECTORIO | sed -e 's/\/$//') #eliminamos el ultimo caracter si es una /

if [ -z "$DESCOMPRIMIR" ]
then
	if [ ! -z "$DIRECTORIO" ]
	then
		case "$COMPRESION" in
			tar.gz)
				tar cvf $DIRECTORIO.tar.gz $DIRECTORIO/*
				;;
			zip)
				zip $DIRECTORIO.zip $DIRECTORIO/*
				;;
			rar)
				rar -a $DIRECTORIO.rar $DIRECTORIO/*
				;;
			tar)
				tar cvf $DIRECTORIO.tar $DIRECTORIO/*
				;;
			gz)
				gzip -l -S gz $DIRECTORIO/*
				;;
			*)
				echo "Esta opción de compresión no es permitida"
				ayuda
				exit 2
				;;
		esac
	elif [ ! -z "$ARCHIVO" ]
	then
		case "$COMPRESION" in
			tar.gz)
				tar cvf $ARCHIVO.tar.gz $ARCHIVO
				;;
			zip)
				zip $ARCHIVO.zip $ARCHIVO
				;;
			rar)
				rar -a $ARCHIVO.rar $ARCHIVO
				;;
			tar)
				tar cvf $ARCHIVO.tar $ARCHIVO
				;;
			gz)
				gzip -l -S gz $ARCHIVO
				;;
			*)
				echo "Esta opción de compresión no es permitida"
				ayuda
				exit 2
				;;
		esac
	fi
else
	# Comenzamos extrayendo la parte derecha desde el ultimo caracter "/", es decir, el archivo
	NombreArchivo="${ARCHIVO##*/}"
	# Lo siguiente es extraer nombre de archivo
	NombreSolo="${NombreArchivo%.[^.]*}"
	# Extension se obtiene eliminando del nombre completo el nombre mas el punto
	Extension="${NombreArchivo:${#NombreSolo} + 1}"
	
	echo $Extension

	case "$Extension" in
		tar.gz)
			tar xvf $ARCHIVO
			;;
		zip)
			unzip $ARCHIVO
			;;
		rar)
			rar -x $ARCHIVO
			;;
		tar)
			tar xvf $ARCHIVO
			;;
		gz)
			gzip -d $ARCHIVO
			;;
		*)
			echo "Esta opción de compresión no es permitida"
			ayuda
			exit 2
			;;
	esac
fi

