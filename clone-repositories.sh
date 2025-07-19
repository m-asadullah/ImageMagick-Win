#/bin/bash
set -e

clone()
{
  local repo=$1
  local folder=$2

  echo ''
  echo "Cloning $repo"

  if [ -z "$folder" ]; then
      folder=$repo
  fi

  if [ -d "$folder" ]; then
      cd $folder
  else
      git clone https://github.com/ImageMagick/$repo.git $folder
      if [ $? != 0 ]; then echo "Error during checkout"; exit; fi

      cd $folder
      git remote add sshpush git@github.com:ImageMagick/$repo.git
      git config remote.pushDefault sshpush
  fi

  git reset --hard
  git pull origin main
  cd ..
}

imageMagickRepository=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --imagemagick6)
      imageMagickRepository="ImageMagick6"
      shift 1
      ;;
    --imagemagick7)
      imageMagickRepository="ImageMagick"
      shift 1
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [[ -z "$imageMagickRepository" ]]; then
  echo "Error: The option to specify the ImageMagick repository is required."
  exit 1
fi

clone "$imageMagickRepository" "ImageMagick"
clone "Configure" "Configure"
clone "Dependencies" "Dependencies"

cd Dependencies
./clone-dependencies.sh
cd ..