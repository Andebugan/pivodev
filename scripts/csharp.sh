#!/bin/bash

wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb\
    && dpkg -i packages-microsoft-prod.deb\
    && rm packages-microsoft-prod.deb\
    && apt-get update\
    && apt-get install dotnet-sdk-8.0 dotnet-runtime-8.0 aspnetcore-runtime-8.0 zip -y\
    && apt autoremove -y
