# vue-nginx-test
FROM docker.io/openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
LABEL maintainer="joetest"

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.openshift.s2i.scripts-url="image:///mytestingpath"
#      io.k8s.description="Platform for building xyz" \
#      io.k8s.display-name="builder x.y.z" \
#      io.openshift.expose-services="8080:http" \
#      io.openshift.tags="builder,x.y.z,etc."

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
RUN yum install -y epel-release && \
    yum install -y --setopt=tsflags=nodocs nginx && \
    yum clean all


RUN sed -i 's/80/8080/' /etc/nginx/nginx.conf


# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /usr/share/nginx
RUN chown -R 1001:1001 /var/log/nginx
RUN chown -R 1001:1001 /var/lib/nginx
RUN touch /run/nginx.pid
RUN chown -R 1001:1001 /run/nginx.pid
RUN chown -R 1001:1001 /etc/nginx

RUN chgrp -R 0 /usr/share/nginx \
    && chmod -R g=u /usr/share/nginx \
    && chgrp -R 0 /var/lib/nginx \
    && chmod -R g=u  /var/lib/nginx \
    && chgrp -R 0 /var/log/nginx \
    && chmod -R g=u  /var/log/nginx \
    && chgrp 0 /run/nginx.pid \
    && chmod g=u /run/nginx.pid 

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
