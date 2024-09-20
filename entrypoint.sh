#!/bin/bash

SCRIPT_PATH=${1}
SCRIPT_PRJ_DIR="$(dirname "$(find-up "/workspace/${SCRIPT_PATH}" -name .project)")"
MODEL_PATH=${2}
MODEL_PRJ_DIR="$(dirname "$(find-up "/workspace/${MODEL_PATH}" -name .project)")"
EXTRA_ARGS="${@:3}"

xvfb-run -s "-screen 0 1280x720x24" \
capella -nosplash -consolelog \
-application org.polarsys.capella.core.commandline.core \
-appid org.eclipse.python4capella.commandline \
-data /opt/capella-${CAPELLA_VER}/workspace \
-import "/opt/capella-${CAPELLA_VER}/Python4Capella|${SCRIPT_PRJ_DIR}|${MODEL_PRJ_DIR}" \
"/workspace/${SCRIPT_PATH}" "/workspace/${MODEL_PATH}" ${EXTRA_ARGS}
