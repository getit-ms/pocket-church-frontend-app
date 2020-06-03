#!/bin/bash

export COMANDO=$1

case $COMANDO in

customiza)
  export IGREJA=$2
  export VERSAO=$3

  echo "Customizando igreja $IGREJA para versão $VERSAO"

  sh scripts/customiza-igreja.sh $IGREJA $VERSAO
  ;;


build)
  export VERSAO=$3

  echo "Executando build versão $VERSAO"

  export PLATAFORMA=$2

  case $PLATAFORMA in

  android)
    sh scripts/build-android.sh $VERSAO
    ;;

  ios)
    sh scripts/build-ios.sh $VERSAO
    ;;

  *) echo "Plataforma inválida! opções válidas: android, ios" ;;

  esac

  ;;
deploy)
  echo "Executando deploy"

  export PLATAFORMA=$2

  case $PLATAFORMA in

  android)
    sh scripts/deploy-android.sh
    ;;

  ios)
    sh scripts/deploy-ios.sh
    ;;

  *) echo "Plataforma inválida! opções válidas: android, ios" ;;

  esac

  ;;

release)
  echo "Executando release"

  export PLATAFORMA=$2

  case $PLATAFORMA in

  android)
    sh scripts/release-android.sh
    ;;

  ios)
    sh scripts/release-ios.sh
    ;;

  *) echo "Plataforma inválida! opções válidas: android, ios" ;;

  esac

  ;;
*) echo "Opcao Invalida! opções válidas: customiza, build, deploy, release" ;;
esac
