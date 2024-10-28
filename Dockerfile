# syntax=docker/dockerfile-upstream:master

FROM debian

# install system packages
RUN apt-get update && apt-get install -y \
    dbus-x11 libgtk-4-dev libswt-gtk-4-java wget xvfb zip
RUN rm -rf /var/lib/apt/lists/*

# install python
RUN apt-get update && apt-get install -y \
    python3 python3-dbg python3-pip
RUN ln -s /usr/bin/python3 /usr/local/bin/python

# install capella
ENV CAPELLA_VER_LONG=7.0.0.202407091438
ENV CAPELLA_VER_SHORT=${CAPELLA_VER_LONG%.[0-9]*}
ENV CAPELLA_TAR=https://download.eclipse.org/capella/core/products/releases/${CAPELLA_VER_LONG%.[0-9]*}/capella-${CAPELLA_VER_LONG}-linux-gtk-x86_64.tar.gz
RUN mkdir -p /opt/capella && \
    cd /opt/capella && \
    wget -nv -c "https://download.eclipse.org/capella/core/products/releases/${CAPELLA_VER_LONG%.[0-9]*}/capella-${CAPELLA_VER_LONG}-linux-gtk-x86_64.tar.gz" -O capella.tar.gz && \
    tar -xzf capella.tar.gz && \
    rm capella.tar.gz
ENV PATH="/opt/capella/capella/:${PATH}"
RUN mkdir -p /opt/capella/workspace

# Eclipse Docs: installing software using the p2 director application
# https://help.eclipse.org/latest/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Fguide%2Fp2_director.html

# Install Py4J
# - Py4J Library
ENV PY4J_VER_LONG=0.10.9.5-bnd-CSEoYQ
ENV PY4J_VER_SHORT=${PY4J_VER_LONG%.[0-9]-[A-z]*}
ENV PY4J_REPOSITORY=https://eclipse.py4j.org
RUN capella -nosplash \
    -application org.eclipse.equinox.p2.director \
    -repository "https://eclipse.py4j.org" -installIU \
    org.py4j.feature.feature.group/${PY4J_VER_LONG}

# Install EASE
# - EASE Core Framework (Incubation):           All the core components mandatory for EASE.
# - EASE Py4J Support (Incubation):             Python (using Py4J) integration into EASE as Python Engine. Needs an external python interpreter for script execution.
# - EASE Python Support (Incubation):           EASE component used to handle python language. This feature does not contain any Python Engine.
# - EASE Modules (Incubation):                  EASE basic modules to interact with Eclipse Workbench.
ENV EASE_CORE_VER_LONG=0.9.0.I202206140954
ENV EASE_PY4J_VER_LONG=0.9.0.I202206141122
ENV EASE_PYTHON_VER_LONG=0.9.0.I202204261218
ENV EASE_MOD_VER_LONG=0.9.0.I202207260950
ENV EASE_VER_SHORT=${EASE_CORE_VER_LONG%.I[0-9]*}
ENV EASE_REPOSITORY=https://download.eclipse.org/ease/release/${EASE_VER_SHORT}
RUN capella -nosplash \
    -application org.eclipse.equinox.p2.director \
    -repository "https://download.eclipse.org/ease/release/${EASE_CORE_VER_LONG%.I[0-9]*}" -installIU \
    org.eclipse.ease.feature.feature.group/${EASE_CORE_VER_LONG},org.eclipse.ease.lang.python.py4j.feature.feature.group/${EASE_PY4J_VER_LONG},org.eclipse.ease.lang.python.feature.feature.group/${EASE_PYTHON_VER_LONG},org.eclipse.ease.modules.feature.feature.group/${EASE_MOD_VER_LONG}

# Install Python4Capella
# - Python4Capella:                             Python Scripting for Capella.
# - Python4Capella Command Line Interface:      Python Scripting for Capella Command Line Interface.
ENV PY4C_VER_LONG=1.3.0.202408221204
ENV PY4C_VER_SHORT=${PY4C_VER_LONG%.[0-9]*}
ENV PY4C_REPOSITORY=jar:https://github.com/labs4capella/python4capella/releases/download/${PY4C_VER_SHORT}/org.eclipse.python4capella.update.zip!
RUN capella -nosplash \
    -application org.eclipse.equinox.p2.director \
    -repository "jar:https://github.com/labs4capella/python4capella/releases/download/${PY4C_VER_LONG%.[0-9]*}/org.eclipse.python4capella.update.zip!" -installIU \
    org.eclipse.python4capella.feature.feature.group/${PY4C_VER_LONG},org.eclipse.python4capella.commandline.feature.feature.group/${PY4C_VER_LONG}
RUN mkdir -p /tmp/python4capella && \
    unzip /opt/capella/capella/plugins/org.eclipse.python4capella_${PY4C_VER_LONG}.jar -d /tmp/python4capella && \
    unzip /tmp/python4capella/zips/Python4Capella.zip -d /opt/capella/Python4Capella

# Install Requirements-VP
# - CapellaRequirements Feature
ENV REQVP_VER_LONG=0.14.0.202407170938
ENV REQVP_VER_SHORT=${REQVP_VER_LONG%.[0-9]*}
ENV REQVP_REPOSITORY=jar:https://www.eclipse.org/downloads/download.php?file=/capella/addons/requirements/updates/releases/${REQVP_VER_SHORT}/Requirements-updateSite-${REQVP_VER_LONG}.zip&r=1!
RUN capella -nosplash \
    -application org.eclipse.equinox.p2.director \
    -repository "jar:https://www.eclipse.org/downloads/download.php?file=/capella/addons/requirements/updates/releases/${REQVP_VER_LONG%.[0-9]*}/Requirements-updateSite-${REQVP_VER_LONG}.zip&r=1!" -installIU \
    org.polarsys.capella.vp.requirements.feature.feature.group/${REQVP_VER_LONG}

# Unpack sample scripts and model
RUN mkdir -p /workspace/sample/scripts /workspace/sample/models
RUN mkdir -p /workspace/sample/scripts/Python4Capella-Scripts && \
    mv /opt/capella/Python4Capella/sample_scripts/* /workspace/sample/scripts/Python4Capella-Scripts && \
    cp /opt/capella/Python4Capella/.project /workspace/sample/scripts/Python4Capella-Scripts/.project && \
    sed -i -e 's/Python4Capella/Python4Capella-Scripts/g' /workspace/sample/scripts/Python4Capella-Scripts/.project && \
    perl -0777 -i -pe 's/\x27\x27\x27\n#Here is the "Run Configuration" part to uncomment if you want to use this functionality :\n\n(.*)\x27\x27\x27/$1/s' /workspace/sample/scripts/Python4Capella-Scripts/*.py
RUN cd /opt/capella/samples && \
    unzip IFE_samplemodel.zip -d /workspace/sample/models && \
    rm IFE_samplemodel.zip

COPY utils/find-up.sh /usr/bin/find-up
COPY entrypoint.sh /entrypoint.sh
VOLUME [ "/workspace/user/scripts", "/workspace/user/models" ]
ENTRYPOINT [ "/entrypoint.sh" ]
