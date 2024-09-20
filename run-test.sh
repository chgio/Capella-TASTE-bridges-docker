#!/bin/sh
xvfb-run -s "-screen 0 1280x720x24" \
capella -nosplash \
-application org.polarsys.capella.core.commandline.core \
-appid org.eclipse.python4capella.commandline \
-data /opt/capella-${CAPELLA_VER}/workspace \
-import "/opt/capella-${CAPELLA_VER}/Python4Capella|/workspace/sample/models/In-Flight Entertainment System" \
"/workspace/sample/scripts/Python4Capella-Scripts/List_logical_components_in_console.py" "/workspace/sample/models/In-Flight Entertainment System/In-Flight Entertainment System.aird" \
> /tmp/out.txt

grep "In-Flight Entertainment System
 - IFE System
 - Passenger
 - Cabin Crew
 - Aircraft
 - Ground Operator" /tmp/out.txt
