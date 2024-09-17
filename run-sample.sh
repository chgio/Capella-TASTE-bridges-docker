echo "CAPELLA_VER=${CAPELLA_VER}"

cd /opt/capella-${CAPELLA_VER}/samples && \
    unzip IFE_samplemodel.zip && \
    rm IFE_samplemodel.zip

xvfb-run -s "-screen 0 1280x720x24" \
capella -nosplash -consolelog \
-application org.polarsys.capella.core.commandline.core \
-appid org.eclipse.python4capella.commandline \
-data /tmp/workspace \
-import "/opt/capella-${CAPELLA_VER}/Python4Capella|/opt/capella-${CAPELLA_VER}/samples/In-Flight Entertainment System" \
workspace:/Python4Capella/sample_scripts/List_logical_components_in_console.py "/opt/capella-${CAPELLA-VER}/samples/In-Flight Entertainment System/In-Flight Entertainment System.aird"
