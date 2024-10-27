#!/bin/bash

SCRIPT_PATH_ABS=/workspace/${1}
SCRIPT_PRJ_DIR_ABS="$(dirname "$(find-up "${SCRIPT_PATH_ABS}" -name .project)")"
MODEL_PATH_ABS=/workspace/${2}
MODEL_PRJ_DIR_ABS="$(dirname "$(find-up "${MODEL_PATH_ABS}" -name .project)")"
MODEL_PATH_REL_PRJ=${MODEL_PATH_ABS#$(dirname "${MODEL_PRJ_DIR_ABS}")}
EXTRA_ARGS="${@:3}"

xvfb-run -s "-screen 0 1280x720x24" \
capella -nosplash -consolelog \
-application org.polarsys.capella.core.commandline.core \
-appid org.eclipse.python4capella.commandline \
-data /opt/capella/workspace \
-import "/opt/capella/Python4Capella|${SCRIPT_PRJ_DIR_ABS}|${MODEL_PRJ_DIR_ABS}" \
"${SCRIPT_PATH_ABS}" "/${MODEL_PATH_REL_PRJ}" ${EXTRA_ARGS}
