ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2022.1.0.209.0

FROM $IMAGE
USER root
WORKDIR /opt/irisapp

# Update package and install sudo
RUN apt-get update && apt-get install -y \
	nano \
	python3-pip \
	python3-venv \
	sudo && \
	/bin/echo -e ${ISC_PACKAGE_MGRUSER}\\tALL=\(ALL\)\\tNOPASSWD: ALL >> /etc/sudoers && \
	sudo -u ${ISC_PACKAGE_MGRUSER} sudo echo enabled passwordless sudo-ing for ${ISC_PACKAGE_MGRUSER}

# Create dev directory
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
USER ${ISC_PACKAGE_MGRUSER}

# Copy source files to image
COPY . /opt/irisapp/

# Start IRIS and load iris.script
RUN iris start IRIS \
    && iris session IRIS < /opt/irisapp/iris.script && iris stop IRIS quietly