FROM centos:7
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y supervisor centos-release-scl subscription-manager && \
    yum install -y https://yum.osc.edu/ondemand/1.6/ondemand-release-web-1.6-4.noarch.rpm && \
    yum install -y ondemand && \
    yum clean all
ADD supervisord.conf /etc/supervisord.conf
CMD ["/bin/sh", "-c", "/usr/bin/supervisord -c /etc/supervisord.conf"]