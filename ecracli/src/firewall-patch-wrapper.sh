#!/bin/bash
#
# $Header: ecs/ecra/ecracli/src/firewall-patch-wrapper.sh /main/3 2018/04/25 14:11:56 nelchan Exp $
#
# firewall-patch-wrapper.sh
# Bug 27600742
#
# Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
#
#    NAME
#      firewall-patch-wrapper.sh - Wrapper script to perform dom0 patching and reserve the firewall rules.
#
#    DESCRIPTION
#      firewall-patch-wrapper.sh script can be used to perform dom0 patching and reserve the firewall rules.
#
#    NOTES
#
#
#    MODIFIED   (MM/DD/YY)
#    nelchan    03/28/18 - do pre-check before saving firewall rule, patching dom0 instead of cell, take default agent conf  as parameter.
#    nelchan    03/08/18 - Creation

RED=$(printf '\033[0;31m')
GREEN=$(printf '\033[0;32m')
NC=$(printf '\033[0m') # No Color
timestamp=`date +%Y%m%d-%H%M%S`
SCRIPT_DIR=$(readlink -f ${0%/*})
LOG_FILE="${SCRIPT_DIR}/../log/fw-patch-wrapper-${timestamp}.log"
BAD_COMMAND_EXIT=1
PATCH_ERROR_EXIT=2
INVALID_CLUSTER_EXIT=3
UNEXPECTED_OUTPUT_EXIT=4

# $1 substring, $2 String to be checked
# return true if string contains substring
stringContain() { [[ "$2" = *"$1"* ]]; }

function usage {
    echo """
    Usage: $0 -c <Clustername> -h <ECRA hosts (IP,IP)> -p <Firewall patching directory> [ -a <default agent conf> ]
    """
}

function log {
    curtime="`date +"%Y-%m-%d %T"`"
    echo "[${curtime}] $@">>${LOG_FILE}
}

function message_error {
    printf "${RED}%s${NC}\n" "$*" >&2
    log """$@"""
}

function message_title {
    echo """${GREEN}$@${NC}"""
    log """$@"""
}

function message {
    echo """$@"""
    log """$@"""
}

function message_debug {
    if [ ${DEBUG} ];then
        local _msg="""Debug: $@"""
        echo """${_msg}"""
        log """${_msg}"""
    fi
}

function exec_ssh_dom0 {
    local _dom0=$1
    local _cmd="$2"
    local _matching_string="$3"
    local _result
    local _exit_code

    if [ -z ${DRYRUN} ]
    then
        message "Executing \"${_cmd}\" on ${_dom0}..."
        _result=$(ssh -o StrictHostKeyChecking=no -i ../exacloud/clusters/oeda/id_rsa.${_dom0}.root -l root ${_dom0} "${_cmd}")
        _exit_code=$?
        if [ ${_exit_code} -ne 0 ]
        then
            message_error "ERROR:failed to ssh to ${_dom0}. command tried ssh -o StrictHostKeyChecking=no -i ../exacloud/clusters/oeda/id_rsa.${_dom0}.root -l root ${_dom0} ${_cmd}"
            message_error "Aborting ..."
            exit ${_exit_code}
        fi
        if ! [ -z "${_matching_string}" ];then
            if stringContain "${_matching_string}" "$(echo ${_result})"; then
                message "$_result"
            else
                message_error "ERROR: ${_result}"
                exit $UNEXPECTED_OUTPUT_EXIT
            fi
        fi
    else
        message "Dryrun: ssh -o StrictHostKeyChecking=no -i ../exacloud/clusters/oeda/id_rsa.${_dom0}.root -l root ${_dom0} ${_cmd}"
    fi
}

function wait_for_patching {
    local _uuid=$1
    local _action=$2
    local _status='Pending'
    message "$_action... "
    while [ ${_status} == 'Pending' ]; do
        sleep ${wait_time}
        _status=$(./ecracli status ${_uuid} |python -m json.tool |grep message|cut -d':' -f2|sed 's/,\s$//' |sed 's/"//g')
        echo -n .
    done
    if [ ${_status} == 'error' ];then
        message ""
        message_error "$(./ecracli status ${_uuid} |python -m json.tool)"
        message_error "$_action error! Status: ${_status}, exit..."
        exit $PATCH_ERROR_EXIT
    elif [ ${_status} == 'Done' ];then
        message "$_action is done: Status: ${_status}"
    else
        message_error "Status Unknown"
        message_error "$(./ecracli status ${_uuid} |python -m json.tool)"
        exit 1
    fi
}

function exec_ecracli {
   
    local _ecracli_cmd=$1
    local _action=$2
    if [ -z ${DRYRUN} ]
    then
        message "Executing: ${_ecracli_cmd}"
        status_page=$(${_ecracli_cmd})
        if [[ ${status_page} =~ .*failed ]]
        then
            message_error "Ecracli error! "${status_page}
            exit 1
        fi
        status_uuid=`basename ${status_page}`
        message "Check status at: $status_page"
        wait_for_patching ${status_uuid} ${_action}
    else
        message "Dryrun: ${_ecracli_cmd}"
    fi
}

### Main ###

while getopts ":p:h:c:a:w:" opt; do
    case $opt in
        p)
            #echo "-n was triggered, Parameter: $OPTARG" >&2
            firewall_patching_dir=$OPTARG
            ;;
        h)
            ecra_hosts=$OPTARG
            ;;
        c)
            cluster=$OPTARG
            ;;
        a)
            default_agent_conf=$OPTARG
            ;;
        w)
            wait_time=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

message_title "[$0] started"
message "Log file at ${LOG_FILE}"
[ ${DRYRUN} ]&&message_title "Dryrun mode is on."

dom0s_clustered=$(./ecracli rack get name=${cluster} | python -m json.tool | grep dom0 | awk -F\" '{print $4}')

## check if wait_time is empty or non-digits, set to default if it is the case
([ -z ${wait_time} ] || [[ "${wait_time}" != ?(-)+([0-9]) ]]) && wait_time=300

message "dom0s_clustered: \"${dom0s_clustered}\""

if [ "x${dom0s_clustered}" == "x" ]
then
    message_error "ERROR: Cannot find dom0s for cluster ${cluster}"
    message_error "Check if the cluster name is correct and if it is registered in ECRA"
    exit $INVALID_CLUSTER_EXIT
fi

#split the dom0s into a space seperated list.
# we do this by assuming that the first 3 characters are common for each dom0 name
# and we put a space before these first 3 characters

splitter=$(echo ${dom0s_clustered} | head -c 3)

message_debug "splitter is \"$splitter\""

dom0s_list=$(echo ${dom0s_clustered} | sed "s/${splitter}/ ${splitter}/g")

message ""
message_title "Pre-Check Cluster"
message_title "Pre-checking - ${cluster}"
message ""
exec_ecracli "./ecracli patch dom0 op=patch_prereq_check ${cluster}" "Pre-Check"

# persistant iptables filename
iptables_save_file="iptables"
for dom0 in ${dom0s_list}
do
    message "[$dom0]"
    message_title "Checking connection to ${dom0}"
    exec_ssh_dom0 ${dom0} "hostname >/dev/null"

    message_title "Checking firewall rules on ${dom0}"
    exec_ssh_dom0 ${dom0} "iptables -L dom0_default > /dev/null"

    message "Making iptable rules Persistant across reboot on ${dom0}"
    exec_ssh_dom0 ${dom0} "iptables-save > /etc/sysconfig/${iptables_save_file}"
 
    message "Turn on iptables on startup"
    exec_ssh_dom0 ${dom0} "chkconfig iptables on"
done

message ""
message_title "Cluster is ready for patching"
message_title "Patching cluster - ${cluster}"
message ""
exec_ecracli "./ecracli patch dom0 op=patch ${cluster}" "Patching"

## set --default-agent-conf parameter for FW install agent.
[ -z ${default_agent_conf} ] && default_agent_conf="/root/SoftFW/SoftFW_Upgrade_2/agent_default_rules.conf"

for dom0 in ${dom0s_list}
do
    message ""
    message_title "Reinstalling firewall agent on ${dom0}"
    pushd $firewall_patching_dir
    install_command="./fw_install_agent.py install --dom0-key /root/.ssh/id_rsa --dom0-name ${dom0} --agent-tgz-path firewall-agent.tgz --default-agent-conf ${default_agent_conf} --ecra-hosts $ecra_hosts"
    if [ $DRYRUN ]; then
        message "Dryrun: ${install_command}"
    else
		## If use variable to hold the output,
		## all return characters are elimilated.
		## use tempfile to hold the output

        temp_output="/tmp/temp_${timestamp}"
        ${install_command} > ${temp_output}
        exit_code=$?
        if [ ${exit_code} -ne 0 ]
        then
            message_error "ERROR: When executing: ${install_command}"
            message_error "`cat ${temp_output}`"
            message_error "Aborting ..."
            rm ${temp_output}
            exit ${_exit_code}
        fi
        message "`cat ${temp_output}`"
        rm ${temp_output}
    fi
    popd
    message ""
    message_title "Check if firewall is running on ${dom0}"
    exec_ssh_dom0 ${dom0} "/etc/init.d/agent_init status" "Firewall agent running"  ## $1=cmd, $2=matching string
    message_title "Removing persistant iptables rules"
    exec_ssh_dom0 ${dom0} "rm -f /etc/sysconfig/${iptables_save_file}"
done

message_title "Done"
