#!/bin/sh
#
# $Header: dbaas/opc/exadata/ecra/db/ecra_wls.sh /main/1 2015/02/26 20:04:01 angfigue Exp $
#
# ecra_wls.sh
#
# Copyright (c) 2015, Oracle and/or its affiliates. All rights reserved.
#
#    NAME
#      ecra_wls.sh - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    angfigue    02/26/15 - Creation
#

export java=/usr/local/packages/jdk7/bin/java;
export twork=$ADE_VIEW_ROOT/dbaas/work/ecra;
export mhome=$twork/mw_home; #Middleware home
export wlst=$mhome/wlserver/server/lib/weblogic.jar;
export project=$mhome/user_projects/domains/base_domain

echo $java;
echo $wlst;
echo $project;
echo "Setting the environment";
$mhome/wlserver/server/bin/setWLSEnv.sh
$project/bin/setDomainEnv.sh
sdir=$(pwd);

export ECRA_WEBLOGIC=$sdir/ecra.weblogic;
$java -cp $wlst weblogic.WLST $sdir/testweblogic.jy

cd $project;
