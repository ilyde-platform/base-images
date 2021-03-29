#!/bin/bash
set -o nounset -o errexit

CONF_DIR="$HOME/.jupyter"
CONF_FILE="${CONF_DIR}/jupyter_notebook_config.py"
mkdir -p "${CONF_DIR}"

PREFIX=/workspacesession/${ILYDE_JOB_ID}/

cat >> $CONF_FILE << EOF
c = get_config()
c.ServerApp.root_dir = '/'
c.ServerApp.base_url = '${PREFIX}'
c.LabApp.tornado_settings = {'headers': {'Content-Security-Policy': 'frame-ancestors *'}, 'static_url_prefix': '${PREFIX}static/'}
c.LabApp.default_url = '/lab/tree${ILYDE_WORKING_DIR}'
c.LabApp.token = u''
c.ServerApp.disable_check_xsrf = True
EOF

COMMAND='jupyter-lab --config="$CONF_FILE" --no-browser --ip="0.0.0.0" 2>&1'
eval ${COMMAND} 
 