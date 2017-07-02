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
Two solutions implemented. One is using puppetlabs-apache module. Another one is created httpd module by myself.
## Using-puppetlabs-apache
Please refer the README.md within the subdirectory using-puppetlabs-apache for details
## creating-httpd-module
Please refer the README.md within the subdirectory creating-httpd-module
