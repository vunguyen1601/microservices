 #!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
NOW_RELEASE=$(date +"%d/%m/%Y %T")
PROJECT="vhes-discovery"

echo "${green}----------------------------------${reset}"
echo "${green}Building...${reset}"
echo "${green}----------------------------------${reset}"
mvn clean
mvn -q install -Dmaven.test.skip=true
STATUS=$?
if [ $STATUS -ne 0 ]; then
echo "${red}Build ${PROJECT} Failed${red}"
exit;
fi
echo "${green}End Building ${PROJECT}...${reset}"

mkdir -p  target/jsw/${PROJECT}/logs
cp -R resources/etc target/jsw/${PROJECT}/

#cp -R resources/scripts target/jsw/${PROJECT}/


echo "${green}Begin Package ${PROJECT}...${reset}"
mkdir -p release/${PROJECT}
cd release/${PROJECT}
rm -rf *
cp -R ../../target/jsw/${PROJECT} .
cp -R ../../resources/install .
#cp -R ../target/plugins iot/

echo ${NOW_RELEASE} >> release.txt

cd ..

tar cfz ${PROJECT}.tar.gz ${PROJECT}/

rm -rf ${PROJECT}/ 
echo "${green}End Package ${PROJECT}...${reset}"


echo "${green}----------------------------------${reset}"
echo "${green}Final all.${reset}"
echo "${green}----------------------------------${reset}"
