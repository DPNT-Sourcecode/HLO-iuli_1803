#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

SCRIPT_CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CHALLENGE_ID=$1
COVERAGE_TEST_REPORT_XML_FILE="${SCRIPT_CURRENT_DIR}/coverage.xml"
PYTHON_CODE_COVERAGE_INFO="${SCRIPT_CURRENT_DIR}/coverage.tdl"

# Install dependencies
pip install -r ${SCRIPT_CURRENT_DIR}/requirements.txt

# Prepare Python project
function init_python_modules_in() {
    _target_dir=$1
    for dir in `find ${SCRIPT_CURRENT_DIR}/${_target_dir} -type d`; do touch ${dir}/__init__.py; done
}
init_python_modules_in lib
init_python_modules_in test

# Compute coverage
( cd ${SCRIPT_CURRENT_DIR} && PYTHONPATH=lib coverage run --source "lib/solutions" -m pytest -s test || true 1>&2 )
( cd ${SCRIPT_CURRENT_DIR} && coverage xml 1>&2 )

[ -e ${PYTHON_CODE_COVERAGE_INFO} ] && rm ${PYTHON_CODE_COVERAGE_INFO}

# Extract coverage percentage for target challenge
if [ -f "${COVERAGE_TEST_REPORT_XML_FILE}" ]; then
    PERCENTAGE=$(( 0 ))
    echo ${PERCENTAGE} > ${PYTHON_CODE_COVERAGE_INFO}
    COVERAGE_OUTPUT=$(xmllint --xpath '//package[@name="lib.solutions.'${CHALLENGE_ID}'"]/@line-rate' ${COVERAGE_TEST_REPORT_XML_FILE})
    if [[ ! -z "${COVERAGE_OUTPUT}" ]]; then
        PERCENTAGE=$(echo ${COVERAGE_OUTPUT} | cut -d "\"" -f 2 | awk '{printf "%.0f",$1 * 100}' )
    fi
    echo ${PERCENTAGE} > ${PYTHON_CODE_COVERAGE_INFO}
    cat ${PYTHON_CODE_COVERAGE_INFO}
    exit 0
else
    echo "No coverage report was found"
    exit -1
fi
