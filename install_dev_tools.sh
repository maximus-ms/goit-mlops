#!/bin/bash

echo > install.log
echo "Checking and installing dependencies" | tee -a install.log
echo | tee -a install.log

apt-get update
docker --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    apt-get install -y docker.io docker-compose | tee -a install.log
fi
echo "Docker is installed" | tee -a install.log

if ! command -v docker-compose >/dev/null 2>&1; then
    echo "Docker Compose is NOT installed"
    apt-get install -y docker-compose | tee -a install.log
fi
echo "Docker Compose is installed" | tee -a install.log

#check python version >= 3.9
python --version >/dev/null 2>&1
if [ $? -ne 0 ]; then 
    apt-get install -y python3 python3-venv python3-pip | tee -a install.log
else
    python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3,9) else 1)'
    if [ $? -ne 0 ]; then
        echo "Python 3.9+ is required, found $(python3 --version)." | tee -a install.log
        echo "The latest Python will be installed." | tee -a install.log
        apt-get install -y python3 python3-venv python3-pip | tee -a install.log
        python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3,9) else 1)'
        if [ $? -ne 0 ]; then 
            echo "Python 3.9+ is required after installation. Please install a newer Python." | tee -a install.log
            exit 1
        fi
    fi
fi
echo "Python is installed" | tee -a install.log
pip3 install Django torch torchvision pillow | tee -a install.log
echo "Django, torch, torchvision, pillow are installed" | tee -a install.log

echo | tee -a install.log
echo "Versions:" | tee -a install.log
docker --version | tee -a install.log
docker-compose --version | tee -a install.log
python3 --version | tee -a install.log
pip3 --version | tee -a install.log

echo | tee -a install.log
echo "Python packages:" | tee -a install.log
pip3 show Django torch torchvision pillow | tee -a install.log

echo | tee -a install.log
echo "Dev tools are installed" | tee -a install.log