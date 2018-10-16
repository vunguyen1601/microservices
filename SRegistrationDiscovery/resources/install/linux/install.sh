#/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "${red}This script must be run as root${reset}" 1>&2
   exit 1
fi
JAVA_VER=$(java -version 2>&1 | grep -i version | sed 's/.*version ".*\.\(.*\)\..*"/\1/; 1q')
if [ $JAVA_VER -lt 7 ]
then
  echo "Require JAVA 1.7 or later."
  exit 1
fi
PROJECT=vhes-discovery

DIRECTORY=/opt/vn/vhes/${PROJECT}

if [[ -d "${DIRECTORY}" && ! -L "${DIRECTORY}" ]] ; then
    echo "VHES discovery installed."
    exit 1
fi

# init
USERID="svhes"
#....
/bin/egrep  -i "^${USERID}:" /etc/passwd
if [ $? -eq 0 ]; then
   echo "User $USERID exists in /etc/passwd"
else 
#   echo "User $USERID does not exists in /etc/passwd"
   adduser --system ${USERID}
   mkdir -p /home/${USERID}/${USERID}/${PROJECT}/cachedb
   mkdir -p /home/${USERID}/${USERID}/${PROJECT}/logs
   chown -R ${USERID}:${USERID} /home/${USERID}/${USERID}/${PROJECT}/cachedb
   chown -R ${USERID}:${USERID} /home/${USERID}/${USERID}/${PROJECT}/logs
fi
# ....

mkdir -p $DIRECTORY


cp -R ../../${PROJECT}/* ${DIRECTORY}

chown -R ${USERID}:${USERID} ${DIRECTORY}

chmod 777 ${DIRECTORY}/bin/*

VAR="
[Unit]
Description=VHES DISCOVERY

[Service]

Environment=\"JAVA_HOME=/usr/java/latest\"

Type=forking

PIDFile=${DIRECTORY}/logs/${PROJECT}.pid
ExecStart=${DIRECTORY}/bin/${PROJECT} start
ExecStop=${DIRECTORY}/bin/${PROJECT} stop
User=svhes

[Install]
WantedBy=multi-user.target
   
"
echo $VAR > /usr/lib/systemd/system/vhes-discovery.service
#cp ${DIRECTORY}/resources/linux/services/vhes-discovery.service /usr/lib/systemd/system/
systemctl daemon-reload
systemctl enable vhes-discovery.service
systemctl status vhes-discovery.service
systemctl start vhes-discovery.service




