#!/bin/sh
xvfb-run -s "-screen 0 1280x720x24" \
capella -nosplash \
-application org.polarsys.capella.core.commandline.core \
-appid org.eclipse.python4capella.commandline \
-data /workspace \
-import "/opt/capella-${CAPELLA_VER}/Python4Capella|/workspace/sample/models/In-Flight Entertainment System" \
workspace:/Python4Capella/sample_scripts/List_logical_components_in_console.py "/workspace/sample/models/In-Flight Entertainment System/In-Flight Entertainment System.aird"
