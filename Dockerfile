FROM debian

# install system packages
RUN apt-get update && apt-get install -y \
    dbus-x11 libgtk-4-dev libswt-gtk-4-java wget xvfb zip
RUN rm -rf /var/lib/apt/lists/*

# install python
RUN apt-get update && apt-get install -y \
    python3 python3-dbg python3-pip
RUN ln -s /usr/bin/python3 /usr/local/bin/python

# install capella 7.0.0
ENV CAPELLA_VER=7.0.0
ENV CAPELLA_TAR=https://download.eclipse.org/capella/core/products/releases/7.0.0/capella-7.0.0.202407091438-linux-gtk-x86_64.tar.gz
RUN mkdir -p /opt/capella-${CAPELLA_VER} && \
    cd /opt/capella-${CAPELLA_VER} && \
    wget -nv -c ${CAPELLA_TAR} -O capella.tar.gz && \
    tar -xzf capella.tar.gz && \
    rm capella.tar.gz
ENV PATH="/opt/capella-${CAPELLA_VER}/capella/:${PATH}"
RUN mkdir -p /opt/capella-${CAPELLA_VER}/workspace

# To get install item identifiers from below: Eclipse -> install software
# -> insert & select update site -> disable "group items by category"
# -> click "more" -> Select "General Information"

# Install Py4J latest
# - Py4J Library
ENV PY4J_REPOSITORY=https://eclipse.py4j.org/
RUN capella -nosplash \
    -application org.eclipse.equinox.p2.director \
    -repository ${PY4J_REPOSITORY} -installIU \
    org.py4j.feature.feature.group

# Install EASE latest
# - EASE Core Framework (Incubation):           All the core components mandatory for EASE.
# - EASE Py4J Support (Incubation):             Python (using Py4J) integration into EASE as Python Engine. Needs an external python interpreter for script execution.
# - EASE Python Support (Incubation):           EASE component used to handle python language. This feature does not contain any Python Engine.
# - EASE Modules (Incubation):                  EASE basic modules to interact with Eclipse Workbench.
# - EASE UI Components (Incubation):            All the EASE component for User Interface integration.
ENV EASE_REPOSITORY=http://download.eclipse.org/ease/release/latest/
RUN capella -nosplash \
    -application org.eclipse.equinox.p2.director \
    -repository ${EASE_REPOSITORY} -installIU \
    org.eclipse.ease.feature.feature.group,org.eclipse.ease.lang.python.py4j.feature.feature.group,org.eclipse.ease.lang.python.feature.feature.group,org.eclipse.ease.modules.feature.feature.group,org.eclipse.ease.ui.feature.feature.group

# Install Python4Capella 1.3.0
# - Python4Capella:                             Python Scripting for Capella.
# - Python4Capella Command Line Interface:      Python Scripting for Capella Command Line Interface.
ENV PY4C_REPOSITORY=jar:https://github.com/labs4capella/python4capella/releases/download/1.3.0/org.eclipse.python4capella.update.zip!
RUN capella -nosplash \
    -application org.eclipse.equinox.p2.director \
    -repository ${PY4C_REPOSITORY} -installIU \
    org.eclipse.python4capella.feature.feature.group,org.eclipse.python4capella.commandline.feature.feature.group
RUN mkdir -p /tmp/python4capella && \
    unzip /opt/capella-${CAPELLA_VER}/capella/plugins/org.eclipse.python4capella_1.3.0.202408221204.jar -d /tmp/python4capella && \
    unzip /tmp/python4capella/zips/Python4Capella.zip -d /opt/capella-${CAPELLA_VER}/Python4Capella

# Install Requirements-VP 0.14.0
# - CapellaRequirements Feature
# - CapellaRequirements Representation Feature
# - CapellaRequirements Viewpoint Feature
# - Requirements Feature
# - Requirements Representation Feature
# - Requirements Representation Feature
ENV REQVP_REPOSITORY=jar:https://www.eclipse.org/downloads/download.php?file=/capella/addons/requirements/updates/releases/0.14.0/Requirements-updateSite-0.14.0.202407170938.zip&r=1!
RUN capella -nosplash \
    -application org.eclipse.equinox.p2.director \
    -repository ${REQVP_REPOSITORY} -installIU \
    org.polarsys.capella.vp.requirements.feature.feature.group,org.polarsys.capella.vp.requirements.representation.feature.feature.group,org.polarsys.capella.vp.requirements.af.feature.feature.group,org.polarsys.kitalpha.vp.requirements.feature.feature.group,org.polarsys.kitalpha.vp.requirements.af.feature.feature.group,org.polarsys.kitalpha.vp.requirements.representation.feature.feature.group

# Unpack sample scripts and model
RUN mkdir -p /workspace/sample/scripts /workspace/sample/models
RUN mkdir -p /workspace/sample/scripts/Python4Capella-Scripts && \
    mv /opt/capella-${CAPELLA_VER}/Python4Capella/sample_scripts/* /workspace/sample/scripts/Python4Capella-Scripts && \
    cp /opt/capella-${CAPELLA_VER}/Python4Capella/.project /workspace/sample/scripts/Python4Capella-Scripts/.project && \
    sed -i -e 's/Python4Capella/Python4Capella-Scripts/g' /workspace/sample/scripts/Python4Capella-Scripts/.project && \
    perl -0777 -i -pe 's/\x27\x27\x27\n#Here is the "Run Configuration" part to uncomment if you want to use this functionality :\n\n(.*)\x27\x27\x27/$1/s' /workspace/sample/scripts/Python4Capella-Scripts/*.py
RUN cd /opt/capella-${CAPELLA_VER}/samples && \
    unzip IFE_samplemodel.zip -d /workspace/sample/models && \
    rm IFE_samplemodel.zip

COPY utils/find-up.sh /usr/bin/find-up
COPY entrypoint.sh /entrypoint.sh
VOLUME [ "/workspace/user/scripts", "/workspace/user/models" ]
ENTRYPOINT [ "/entrypoint.sh" ]
