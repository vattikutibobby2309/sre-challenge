# SRE Challenge:
### Challenge:
Using a modern configuration management tool of your choice (i.e. Ansible, Chef, Puppet, SaltStack, etc.) configure a Linux host as a secure web server. The server should be configured to serve a page reading “SRE CHALLENGE” over HTTPS.
### Deliverables:
#### Install and configure a web server on a Debian, Ubuntu, or CentOS host
#### Configure https (a self-signed certificate is acceptable for this challenge)
#### Configure http redirect to https
#### Configure the http/https homepage to display "SRE CHALLENGE"
#### Configure host-based firewall for ports 22, 80 and 443
#### Create an automated test to verify the web server is listening on port 443.

# Solution:
I'm going to use puppet to do this configuration automation with Docker in my local laptop. This solution created a new httpd module to handle the apache httpd installation and configuration for virtual host. It relies on a module firewall from puppetlabs https://forge.puppet.com/puppetlabs/firewall for the firewall configuration. I tested it in centos 7.
## Assumptions:
Have Docker installed in local host. If not, please go to docker.com https://www.docker.com and download the docker engine and install it.

## Steps:
### Test it with puppetagent docker container
#### Git clone SRE-Challenge repo from GitHub
```
cd ~; git clone https://github.com/rongyj/sre-challenge.git
```
#### Pull docker image for puppet agent
```
docker pull rongyj/puppet-agent4-c7-systemd
```
#### Run puppetagent docker container with right mapping for the port and volumes
```
docker run  -d --name puppetagent --cap-add SYS_ADMIN --security-opt seccomp:unconfined --hostname puppetagent -p 8443:443 -p 8080:80 -v ~/sre-challenge/creating-httpd-module/agent/hosts:/etc/hosts -v ~/sre-challenge/creating-httpd-module:/etc/puppet --cap-add=NET_ADMIN --cap-add=NET_RAW rongyj/puppet-agent4-c7-systemd bash -c "/usr/sbin/init"
```
It will map the local port 8443 to the docker container port 443 and local port 8080 to container port 80.

if you see error as below:
```
docker run  -d --name puppetagent --cap-add SYS_ADMIN --security-opt seccomp:unconfined --hostname puppetagent -p 8443:443 -p 8080:80 -v ~/sre-challenge/creating-httpd-module/agent/hosts:/etc/hosts -v ~/sre-challenge/creating-httpd-module:/etc/puppet --cap-add=NET_ADMIN --cap-add=NET_RAW rongyj/puppet-agent4-c7-systemd bash -c "/usr/sbin/init"
docker: Error response from daemon: Conflict. The container name "/puppetagent" is already in use by container 667cbbad0c17fb5a435a9832b8dbc20e73e61a01aaf23e0271e61b37b5e8a76b. You have to remove (or rename) that container to be able to reuse that name..
See 'docker run --help'.
```
you need stop the container "puppetagent" and remove it as below from local host and retry
```
$ docker stop puppetagent
$ docker rm puppetagent
```
#### Connect to the puppetagent docker container
```
# docker exec -it puppetagent /bin/bash
[root@puppetagent /]#puppet apply --modulepath=/etc/puppet/modules /etc/puppet/manifests/init.pp

```
#### Test it from local host browser
type "http://localhost:8080/" in a browser and it will be redirected to "https://localhost:8443/" automatically and the "SRE-Challenge" will be displayed. If the localhost cannot be resolved, you need edit your local /etc/hosts to add "127.0.0.1 localhost localhost " to it and try again.
From the above container terminal and the iptables -L can show the list of the firewall rules:
```
[root@puppetagent manifests]# iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     icmp --  anywhere             anywhere             /* 000 accept all icmp */
ACCEPT     all  --  anywhere             anywhere             /* 001 accept all to lo interface */
ACCEPT     all  --  anywhere             anywhere             /* 003 accept related established rules */ state RELATED,ESTABLISHED
ACCEPT     tcp  --  anywhere             anywhere             multiport dports ssh,http,https /* 300 allow ssh, http and https access */ state NEW
ACCEPT     all  --  anywhere             anywhere             state RELATED,ESTABLISHED
ACCEPT     icmp --  anywhere             anywhere            
ACCEPT     all  --  anywhere             anywhere            
ACCEPT     tcp  --  anywhere             anywhere             state NEW tcp dpt:ssh
REJECT     all  --  anywhere             anywhere             reject-with icmp-host-prohibited
DROP       all  --  anywhere             anywhere             /* 999 drop all */

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
REJECT     all  --  anywhere             anywhere             reject-with icmp-host-prohibited

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere             /* 004 accept related established rules */ state RELATED,ESTABLISHED
ACCEPT     udp  --  anywhere             anywhere             multiport dports domain /* 200 allow outgoing dns lookups */ state NEW
ACCEPT     icmp --  anywhere             anywhere             /* 200 allow outgoing icmp type 8 (ping) */ icmp echo-request
```
