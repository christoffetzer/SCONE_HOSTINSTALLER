#!/bin/bash
: '
Access to this file is granted under the SCONE COMMERCIAL LICENSE V1.0 

Any use of this product using this file requires a commercial license from scontain UG, www.scontain.com.

Permission is also granted  to use the Program for a reasonably limited period of time  (but no longer than 1 month) 
for the purpose of evaluating its usefulness for a particular purpose.

THERE IS NO WARRANTY FOR THIS PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING 
THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. 

THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, 
YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED ON IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY
MODIFY AND/OR REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, 
INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM INCLUDING BUT NOT LIMITED TO LOSS 
OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE 
WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

Copyright (C) 2017-2018 scontain.com
'

set -x -e

docker -v || install_docker=true
if [[ $install_docker == true ]] ; then
  sudo apt-get install --yes apt-transport-https  ca-certificates  curl  software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install --yes docker-ce
fi
