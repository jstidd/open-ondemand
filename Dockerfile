FROM centos:7
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y supervisor centos-release-scl subscription-manager && \
    yum install -y https://yum.osc.edu/ondemand/1.6/ondemand-release-web-1.6-4.noarch.rpm && \
    yum install -y ondemand && \
    yum clean all

# keycloak
WORKDIR /opt
RUN sudo wget https://downloads.jboss.org/keycloak/4.8.3.Final/keycloak-4.8.3.Final.tar.gz && \
    sudo tar xzf keycloak-4.8.3.Final.tar.gz && \
    sudo groupadd -r keycloak && \
    sudo useradd -m -d /var/lib/keycloak -s /sbin/nologin -r -g keycloak keycloak && \
    sudo chown keycloak: -R keycloak-4.8.3.Final
WORKDIR /opt/keycloak-4.8.3.Final
RUN sudo -u keycloak chmod 700 standalone && \
    sudo yum -y install java-1.8.0-openjdk-devel && \
    sudo -u keycloak ./bin/add-user-keycloak.sh --user admin --password KEYCLOAKPASS --realm master && \
    sudo -u keycloak ./bin/jboss-cli.sh 'embed-server,/subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=proxy-address-forwarding,value=true)' && \
    sudo -u keycloak ./bin/jboss-cli.sh 'embed-server,/socket-binding-group=standard-sockets/socket-binding=proxy-https:add(port=8443)' && \
    sudo -u keycloak ./bin/jboss-cli.sh 'embed-server,/subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=redirect-socket,value=proxy-https)'

ADD supervisord.conf /etc/supervisord.conf
CMD ["/bin/sh", "-c", "/usr/bin/supervisord -c /etc/supervisord.conf"]