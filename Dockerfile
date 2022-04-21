# Default ARG values which may be overriden in build command with
# docker-compose build --build-arg KEY=VAL
#  as in 
# make init && make build ARGS="--build-arg MIG_SVN_REV=HEAD"
#  or using
# docker-compose build
# with .env file in place
#
# IMPORTANT: all ARGS here that should allow being overriden from .env MUST be
#            explicitly listed in docker-compose.yml *args* list, too.
#            Furthermore they must be declared after FROM in each stage used.

ARG UID=1000
ARG GID=1000
ARG USER=mig
ARG BUILD_TYPE=basic
ARG BUILD_TARGET=development
ARG DOMAIN=migrid.test
ARG WILDCARD_DOMAIN=*.migrid.test
ARG PUBLIC_DOMAIN=www.migrid.test
ARG MIGCERT_DOMAIN=cert.migrid.test
ARG EXTCERT_DOMAIN=
ARG MIGOID_DOMAIN=ext.migrid.test
ARG EXTOID_DOMAIN=
ARG EXTOIDC_DOMAIN=
ARG SID_DOMAIN=sid.migrid.test
ARG IO_DOMAIN=io.migrid.test
ARG OPENID_DOMAIN=openid.migrid.test
ARG FTPS_DOMAIN=ftps.migrid.test
ARG SFTP_DOMAIN=sftp.migrid.test
ARG WEBDAVS_DOMAIN=webdavs.migrid.test
ARG MIG_OID_PROVIDER=https://ext.migrid.test/openid/
ARG EXT_OID_PROVIDER=unset
ARG EXT_OIDC_PROVIDER_META_URL=unset
ARG EXT_OIDC_CLIENT_NAME=unset
ARG EXT_OIDC_CLIENT_ID=unset
ARG PUBLIC_HTTP_PORT=80
ARG PUBLIC_HTTPS_PORT=444
ARG MIGCERT_HTTPS_PORT=446
ARG EXTCERT_HTTPS_PORT=447
ARG MIGOID_HTTPS_PORT=443
ARG EXTOID_HTTPS_PORT=445
ARG EXTOIDC_HTTPS_PORT=449
ARG SID_HTTPS_PORT=448
ARG SFTP_SUBSYS_PORT=22222
ARG SFTP_PORT=2222
ARG SFTP_SHOW_PORT=22
ARG DAVS_PORT=4443
ARG DAVS_SHOW_PORT=443
ARG FTPS_CTRL_PORT=8021
ARG FTPS_CTRL_SHOW_PORT=21
ARG OPENID_PORT=8443
ARG OPENID_SHOW_PORT=443
ARG MIG_SVN_REPO=https://svn.code.sf.net/p/migrid/code/trunk
ARG MIG_SVN_REV=5408
ARG MIG_GIT_REPO=https://github.com/ucphhpc/migrid-sync.git
ARG MIG_GIT_BRANCH=edge
ARG MIG_GIT_REV=3c72ff684e6c1161e577cfc1c74caa000553ad05
ARG ADMIN_EMAIL=mig
ARG ADMIN_LIST=
ARG LOG_LEVEL=info
ARG TITLE="Minimum intrusion Grid"
ARG SHORT_TITLE=MiG
ARG MIG_OID_TITLE=MiG
ARG EXT_OID_TITLE=External
ARG PEERS_PERMIT="distinguished_name:.*"
ARG VGRID_CREATORS="distinguished_name:.*"
ARG VGRID_MANAGERS="distinguished_name:.*"
ARG EMULATE_FLAVOR=migrid
ARG EMULATE_FQDN=migrid.org
ARG SKIN_SUFFIX=basic
ARG ENABLE_OPENID=True
ARG ENABLE_SFTP=True
ARG ENABLE_SFTP_SUSBSYS=True
ARG ENABLE_DAVS=True
ARG ENABLE_FTPS=True
ARG ENABLE_SHARELINKS=True
ARG ENABLE_TRANSFERS=True
ARG ENABLE_DUPLICATI=True
ARG ENABLE_SEAFILE=False
ARG ENABLE_SANDBOXES=False
ARG ENABLE_VMACHINES=False
ARG ENABLE_CRONTAB=True
ARG ENABLE_JOBS=True
ARG ENABLE_RESOURCES=True
ARG ENABLE_EVENTS=True
ARG ENABLE_FREEZE=False
ARG ENABLE_IMNOTIFY=False
ARG ENABLE_NOTIFY=True
ARG ENABLE_PREVIEW=False
ARG ENABLE_WORKFLOWS=False
ARG ENABLE_VERIFY_CERTS=True
ARG ENABLE_JUPYTER=True
ARG ENABLE_GDP=False
ARG ENABLE_TWOFACTOR=True
ARG ENABLE_TWOFACTOR_STRICT_ADDRESS=False
ARG ENABLE_SELF_SIGNED_CERTS=False
ARG PUBKEY_FROM_DNS=False
ARG PREFER_PYTHON3=False
ARG SIGNUP_METHODS=migoid
ARG LOGIN_METHODS=migoid
ARG USER_INTERFACES=V3
ARG AUTO_ADD_CERT_USER=False
ARG AUTO_ADD_OID_USER=False
ARG AUTO_ADD_OIDC_USER=False
ARG CERT_VALID_DAYS=365
ARG OID_VALID_DAYS=365
ARG GENERIC_VALID_DAYS=365
ARG DEFAULT_MENU=
ARG USER_MENU=jupyter
ARG WITH_PY3=no
ARG WITH_GIT=no
ARG VGRID_LABEL=VGrid
ARG GDP_EMAIL_NOTIFY=True

# Jupyter Arguments
ARG JUPYTER_SERVICES=""
ARG JUPYTER_SERVICES_DESC="{}"

FROM centos:7 as init
ARG BUILD_TYPE
#ARG BUILD_TARGET
ARG DOMAIN
ARG WILDCARD_DOMAIN
ARG PUBLIC_DOMAIN
ARG MIGCERT_DOMAIN
ARG EXTCERT_DOMAIN
ARG MIGOID_DOMAIN
ARG EXTOID_DOMAIN
ARG EXTOIDC_DOMAIN
ARG SID_DOMAIN
ARG IO_DOMAIN
ARG OPENID_DOMAIN
ARG FTPS_DOMAIN
ARG SFTP_DOMAIN
ARG WEBDAVS_DOMAIN
ARG PUBLIC_HTTP_PORT
ARG PUBLIC_HTTPS_PORT
ARG MIGCERT_HTTPS_PORT
ARG EXTCERT_HTTPS_PORT
ARG MIGOID_HTTPS_PORT
ARG EXTOID_HTTPS_PORT
ARG EXTOIDC_HTTPS_PORT
ARG SID_HTTPS_PORT
ARG SFTP_PORT
ARG SFTP_SUBSYS_PORT
ARG SFTP_SHOW_PORT
ARG DAVS_PORT
ARG DAVS_SHOW_PORT
ARG FTPS_CTRL_PORT
ARG FTPS_CTRL_SHOW_PORT
ARG OPENID_PORT
ARG OPENID_SHOW_PORT
#ARG MIG_SVN_REPO
#ARG MIG_SVN_REV
#ARG MIG_GIT_REPO
#ARG MIG_GIT_BRANCH
#ARG MIG_GIT_REV
#ARG EMULATE_FLAVOR
#ARG EMULATE_FQDN
ARG WITH_PY3
ARG JUPYTER_SERVICES
#ARG WITH_GIT

RUN echo "Build type: $BUILD_TYPE"
#RUN echo "Build target: $BUILD_TARGET"
RUN echo "Domains: $DOMAIN" "${PUBLIC_DOMAIN}" "${MIGCERT_DOMAIN}" \
           "${EXTCERT_DOMAIN}" "${MIGOID_DOMAIN}" "${EXTOID_DOMAIN}" \
           "${EXTOIDC_DOMAIN}" "${SID_DOMAIN}" "${IO_DOMAIN}" \
           "${OPENID_DOMAIN}" "${SFTP_DOMAIN}" "${FTPS_DOMAIN}" \
           "${WEBDAVS_DOMAIN}"
RUN echo "Ports: " "${PUBLIC_HTTP_PORT} ${PUBLIC_HTTPS_PORT}" \
    "${MIGOID_HTTPS_PORT} ${EXTOID_HTTPS_PORT} ${EXTOIDC_HTTPS_PORT}" \
    "${MIGCERT_HTTPS_PORT} ${EXTCERT_HTTPS_PORT}" \
    "${SID_HTTPS_PORT} ${SFTP_PORT} ${SFTP_SUBSYS_PORT}" \
    "${FTPS_CTRL_PORT} ${DAVS_PORT} ${OPENID_PORT}"
#RUN echo "MiG svn repo and revision: $MIG_SVN_REPO $MIG_SVN_REV"
#RUN echo "MiG git repo , branch and revision: $MIG_GIT_REPO $MIG_GIT_BRANCH $MIG_GIT_REV"
#RUN echo "Emulate flavor: $EMULATE_FLAVOR"
#RUN echo "Emulate FQDN: $EMULATE_FQDN"
RUN echo "Enable python3 support: $WITH_PY3"
#RUN echo "Designated jupyter services: $JUPYTER_SERVICES"
#RUN echo "Enable git checkout: $WITH_GIT"

FROM init as base
ARG UID
ARG GID
ARG USER
ARG DOMAIN
ARG WILDCARD_DOMAIN
ARG ENABLE_GDP
ARG ENABLE_SELF_SIGNED_CERTS
ARG WITH_PY3

WORKDIR /tmp

# Centos image default yum configs prevent docs installation
# https://superuser.com/questions/784451/centos-on-docker-how-to-install-doc-files
RUN sed -i '/nodocs/d' /etc/yum.conf

RUN yum update -y \
    && yum install -y epel-release \
    && yum clean all \
    && rm -fr /var/cache/yum

RUN yum update -y \
    && yum install -y \
    gcc \
    pam-devel \
    httpd \
    htop \
    openssh \
    crontabs \
    nano \
    mod_ssl \
    mod_wsgi \
    mod_proxy \
    mod_auth_openid \
    mod_auth_openidc \
    tzdata \
    initscripts \
    svn \
    git \
    vim \
    net-tools \
    telnet \
    ca-certificates \
    mercurial \
    openssh-server \
    openssh-clients \
    rsyslog \
    lsof \
    python-pip \
    python-devel \
    python-paramiko \
    python-enchant \
    python-jsonrpclib \
    python-requests \
    python2-psutil \
    python-future \
    python2-cffi \
    pysendfile \
    PyYAML \
    pyOpenSSL \
    # NOTE: generally install cracklib from pip as yum only has py2 version
    #cracklib-python \
    cracklib-devel \
    lftp \
    rsync \
    fail2ban \
    ipset \
    wget

RUN if [ "${WITH_PY3}" = "yes" ]; then \
      echo "install py3 deps" \
      && yum update -y \
      && yum install -y \
      python3-pip \
      python3-devel \
      python3-mod_wsgi \
      #python3-paramiko \
      python36-paramiko \
      #python3-enchant \
      #python3-jsonrpclib \
      #python3-requests \
      python36-requests \
      #python3-psutil \
      python36-psutil \
      python3-future \
      #python3-cffi \
      python36-cffi \
      python36-pyOpenSSL \
      python36-PyYAML; \
    else \
      echo "no py3 deps"; \
    fi;

# Install GDP dependencies
# TODO: does postfix "just work" and should it perhaps always be installed?
RUN if [ "${ENABLE_GDP}" = "True" ]; then \
      echo "install GDP deps" \
      && yum update -y \
      && yum install -y \
      postfix \
      python-xvfbwrapper \
      wkhtmltopdf \
      xorg-x11-server-Xvfb \
      && pip install git+https://github.com/Martin-Rehr/python-pdfkit.git ; \
    else \
      echo "no GDP deps"; \
    fi;

# Apache OpenID (provided by epel)
RUN yum install -y mod_auth_openid

# Disable Apache OpenID ssl-certificate verification
# (recompile libopkele with --disable-ssl-verify-host --disable-ssl-verify-peer)
# TODO: do we REALLY want this security crippling to avoid self-signed cert noise?
# TODO: consider e.g. a MiG CA signed dummy cert instead and explicit cacert import
# TODO: this hard-coded version sucks, at least use e.g. yumdownloader from yum-utils
RUN echo "ENABLE_SELF_SIGNED_CERTS: $ENABLE_SELF_SIGNED_CERTS"
RUN if [ "$ENABLE_SELF_SIGNED_CERTS" = "True" ]; then \
	echo "Re-installing libopkele with ssl verification disabled" \
	&& yum update -y \
	&& yum install -y gcc-c++ \
        	rpm-build \
        	boost-devel \
        	openssl-devel \
        	libxslt \
        	libcurl-devel \
        	expat-devel \
        	tidy-devel \
        	sqlite-devel \
        	libuuid-devel \
        && rpm -e --nodeps libopkele \
        && rpm -ivh https://download-ib01.fedoraproject.org/pub/epel/7/SRPMS/Packages/l/libopkele-2.0.4-9.el7.src.rpm \
        && sed -i "s/^%configure$/%configure --disable-ssl-verify-host --disable-ssl-verify-peer/g" /root/rpmbuild/SPECS/libopkele.spec  \
        && rpmbuild -v -ba /root/rpmbuild/SPECS/libopkele.spec \
        && yum localinstall -y /root/rpmbuild/RPMS/x86_64/libopkele-2.0.4-9.el7.x86_64.rpm; \
    fi;
        
# Setup container default language to make sure UTF8 is available in wsgi app.
# Otherwise sys.getfilesystemencoding will return ascii despite utf8 FS, and
# thus result e.g. in broken user path and client_id for users with accented
# chars e.g. in their name.
# https://stackoverflow.com/a/28212946
# TODO: do we need to generate this rather common locale? (looks like no)
#RUN localedef -c -i en_US -f UTF-8 en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Setup user
RUN groupadd -g $GID $USER
RUN useradd -u $UID -g $GID -ms /bin/bash $USER

# MiG environment
ENV MIG_ROOT=/home/$USER
ENV WEB_DIR=/etc/httpd
ENV CERT_DIR=$WEB_DIR/MiG-certificates

USER root

RUN mkdir -p $CERT_DIR/MiG/${WILDCARD_DOMAIN} \
    && chown -R $USER:$USER $CERT_DIR \
    && chmod 775 $CERT_DIR

RUN chown $USER:$USER $WEB_DIR \
    && chmod 755 $WEB_DIR

# Certs and keys
FROM base as setup_security
ARG USER
ARG DOMAIN
ARG WILDCARD_DOMAIN
ARG PUBLIC_DOMAIN
ARG MIGCERT_DOMAIN
ARG EXTCERT_DOMAIN
ARG MIGOID_DOMAIN
ARG EXTOID_DOMAIN
ARG EXTOIDC_DOMAIN
ARG SID_DOMAIN
ARG IO_DOMAIN
ARG OPENID_DOMAIN
ARG FTPS_DOMAIN
ARG SFTP_DOMAIN
ARG WEBDAVS_DOMAIN

# Dhparam - https://wiki.mozilla.org/Security/Archive/Server_Side_TLS_4.0
RUN curl https://ssl-config.mozilla.org/ffdhe4096.txt -o $CERT_DIR/dhparams.pem

# CA
# https://gist.github.com/Soarez/9688998
RUN openssl genrsa -des3 -passout pass:qwerty -out ca.key 2048 \
    && openssl rsa -passin pass:qwerty -in ca.key -out ca.key \
    && openssl req -x509 -new -key ca.key \
    -subj "/C=DK/ST=NA/L=NA/O=MiGrid-Test/OU=NA/CN=${WILDCARD_DOMAIN}" -out ca.crt \
    && openssl req -x509 -new -nodes -key ca.key -sha256 -days 1024 \
    -subj "/C=DK/ST=NA/L=NA/O=MiGrid-Test/OU=NA/CN=${WILDCARD_DOMAIN}" -out ca.pem

# Server key/ca
# https://gist.github.com/Soarez/9688998
RUN openssl genrsa -out server.key 2048 \
    && openssl req -new -key server.key -out server.csr \
    -subj "/C=DK/ST=NA/L=NA/O=MiGrid-Test/OU=NA/CN=${WILDCARD_DOMAIN}" \
    && openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

# CRL
RUN touch /etc/pki/CA/index.txt \
    && echo '00' > /etc/pki/CA/crlnumber \
    && openssl ca -gencrl -keyfile ca.key -cert ca.pem -out crl.pem

# Daemon keys
RUN cat server.{key,crt} > combined.pem \
    && cat server.crt > server.ca.pem \
    && cat ca.pem >> server.ca.pem \
    && chown $USER:$USER combined.pem \
    && chown $USER:$USER server.ca.pem \
    && ssh-keygen -y -f combined.pem > combined.pub \
    && chown 0:0 *.key server.crt ca.pem \
    && chmod 400 *.key server.crt ca.pem combined.pem server.ca.pem

# Prepare keys for mig
RUN mv server.crt $CERT_DIR/MiG/${WILDCARD_DOMAIN}/ \
    && mv server.key $CERT_DIR/MiG/${WILDCARD_DOMAIN}/ \
    && mv crl.pem $CERT_DIR/MiG/${WILDCARD_DOMAIN}/ \
    && mv ca.pem $CERT_DIR/MiG/${WILDCARD_DOMAIN}/cacert.pem \
    && mv combined.pem $CERT_DIR/MiG/${WILDCARD_DOMAIN}/ \
    && mv combined.pub $CERT_DIR/MiG/${WILDCARD_DOMAIN}/ \
    && mv server.ca.pem $CERT_DIR/MiG/${WILDCARD_DOMAIN}/

WORKDIR $CERT_DIR

RUN ln -s MiG/${WILDCARD_DOMAIN}/server.crt server.crt \
    && ln -s MiG/${WILDCARD_DOMAIN}/server.key server.key \
    && ln -s MiG/${WILDCARD_DOMAIN}/crl.pem crl.pem \
    && ln -s MiG/${WILDCARD_DOMAIN}/cacert.pem cacert.pem \
    && ln -s MiG/${WILDCARD_DOMAIN}/combined.pem combined.pem \
    && ln -s MiG/${WILDCARD_DOMAIN}/server.ca.pem server.ca.pem \
    && ln -s MiG/${WILDCARD_DOMAIN}/combined.pub combined.pub \
    && for domain in "${PUBLIC_DOMAIN}" "${MIGCERT_DOMAIN}" \
           "${EXTCERT_DOMAIN}" "${MIGOID_DOMAIN}" "${EXTOID_DOMAIN}" \
           "${EXTOIDC_DOMAIN}" "${SID_DOMAIN}" "${IO_DOMAIN}" \
           "${OPENID_DOMAIN}" "${SFTP_DOMAIN}" "${FTPS_DOMAIN}" \
               "${WEBDAVS_DOMAIN}"; do \
               [ -L "$domain" ] || ln -s MiG/${WILDCARD_DOMAIN} $domain; \
       done

# Upgrade pip, required by cryptography
RUN python -m pip install -U pip==20.3.4

WORKDIR $MIG_ROOT
USER $USER

RUN mkdir -p MiG-certificates \
    && cd MiG-certificates \
    && ln -s $CERT_DIR/MiG/${WILDCARD_DOMAIN}/cacert.pem cacert.pem \
    && ln -s $CERT_DIR/MiG MiG \
    && ln -s $CERT_DIR/combined.pem combined.pem \
    && ln -s $CERT_DIR/combined.pub combined.pub \
    && ln -s $CERT_DIR/dhparams.pem dhparams.pem


FROM setup_security as mig_dependencies
ARG DOMAIN
ARG ENABLE_DEFAULT_PY
ARG WITH_PY3

# Prepare OpenID (python-openid for py2 and python-openid2 for py3)
ENV PATH=$PATH:/home/$USER/.local/bin
RUN pip install --user python-openid
RUN if [ "$WITH_PY3" = "yes" ]; then \
      echo "install py3 openid" \
      pip3 install --user python-openid2; \
    fi;

# Modules required by grid_events.py
RUN pip install --user \
    watchdog \
    scandir
RUN if [ "$WITH_PY3" = "yes" ]; then \
      pip3 install --user \
      watchdog; \
    fi;

# Modules required by grid_webdavs
# NOTE: we require <=1.3.0 for python2. CherryPy is no longer bundled lately.
RUN pip install --user \
    wsgidav==1.3.0
RUN if [ "$WITH_PY3" = "yes" ]; then \
      pip3 install --user \
      wsgidav cherrypy; \
    fi;

# Modules required by grid_ftps
# NOTE: relies on pyOpenSSL and Cryptography from yum for now
RUN pip install --user \
    pyftpdlib
RUN if [ "$WITH_PY3" = "yes" ]; then \
      pip3 install --user \
      pyftpdlib; \
    fi;

# Modules required by grid_X IO daemons (not availalble in yum for py 3)
RUN pip install --user \
    cracklib
RUN if [ "$WITH_PY3" = "yes" ]; then \
      pip3 install --user \
      cracklib; \
    fi;

# Modules required by jupyter
#RUN pip install --user \
#    requests

# Module required to run pytests
# 4.6 is the latest with python2 support
RUN pip install --user \
    pytest
RUN if [ "$WITH_PY3" = "yes" ]; then \
      pip3 install --user \
      pytest; \
    fi;

# Modules required by 2FA
# NOTE: we require <=2.3.0 for python2.
RUN pip install --user \
    pyotp==2.3.0
RUN if [ "$WITH_PY3" = "yes" ]; then \
      pip3 install --user \
      pyotp; \
    fi;

# Modules required for smart country selection
RUN pip install --user \
    iso3166
RUN if [ "$WITH_PY3" = "yes" ]; then \
      pip3 install --user \
      iso3166; \
    fi;

FROM mig_dependencies as download_mig
ARG USER
ARG DOMAIN
ARG MIG_SVN_REPO
ARG MIG_SVN_REV
ARG WITH_GIT
ARG MIG_GIT_REPO
ARG MIG_GIT_BRANCH
ARG MIG_GIT_REV

# Install and configure MiG
# NOTE: git refuses to clone into non-empty dir - use tmp
#     cd migrid.git && git checkout --track origin/${MIG_GIT_BRANCH} ${MIG_GIT_REV} && cd .. ; \

RUN if [ "$WITH_GIT" = "yes" ]; then \
      git clone ${MIG_GIT_REPO} migrid.git && \
        cd migrid.git && \
        git checkout -B ${MIG_GIT_BRANCH} --track origin/${MIG_GIT_BRANCH} && \
        git checkout ${MIG_GIT_REV} && cd .. && \
        rsync -a migrid.git/ ./ && \
        rm -rf migrid.git/ ; \
    else \
      svn checkout -r ${MIG_SVN_REV} ${MIG_SVN_REPO} . ; \
    fi;

ADD --chown=$USER:$USER mig $MIG_ROOT/

FROM download_mig as install_mig
ARG USER
ARG DOMAIN
ARG PUBLIC_DOMAIN
ARG MIGCERT_DOMAIN
ARG EXTCERT_DOMAIN
ARG MIGOID_DOMAIN
ARG EXTOID_DOMAIN
ARG EXTOIDC_DOMAIN
ARG SID_DOMAIN
ARG IO_DOMAIN
ARG OPENID_DOMAIN
ARG FTPS_DOMAIN
ARG SFTP_DOMAIN
ARG WEBDAVS_DOMAIN
ARG PUBLIC_HTTP_PORT
ARG PUBLIC_HTTPS_PORT
ARG MIGCERT_HTTPS_PORT
ARG EXTCERT_HTTPS_PORT
ARG MIGOID_HTTPS_PORT
ARG EXTOID_HTTPS_PORT
ARG EXTOIDC_HTTPS_PORT
ARG SID_HTTPS_PORT
ARG SFTP_PORT
ARG SFTP_SUBSYS_PORT
ARG SFTP_SHOW_PORT
ARG DAVS_PORT
ARG DAVS_SHOW_PORT
ARG FTPS_CTRL_PORT
ARG FTPS_CTRL_SHOW_PORT
ARG OPENID_PORT
ARG OPENID_SHOW_PORT
ARG ADMIN_EMAIL
ARG ADMIN_LIST
ARG LOG_LEVEL
ARG TITLE
ARG SHORT_TITLE
ARG PEERS_PERMIT
ARG VGRID_CREATORS
ARG VGRID_MANAGERS
ARG MIG_OID_TITLE
ARG EXT_OID_TITLE
ARG MIG_OID_PROVIDER
ARG EXT_OID_PROVIDER
ARG EXT_OIDC_PROVIDER_META_URL
ARG EXT_OIDC_CLIENT_NAME
ARG EXT_OIDC_CLIENT_ID
ARG EXT_OIDC_SCOPE
ARG EMULATE_FLAVOR
ARG EMULATE_FQDN
ARG SKIN_SUFFIX
ARG ENABLE_OPENID
ARG ENABLE_SFTP
ARG ENABLE_SFTP_SUSBSYS
ARG ENABLE_DAVS
ARG ENABLE_FTPS
ARG ENABLE_SHARELINKS
ARG ENABLE_TRANSFERS
ARG ENABLE_DUPLICATI
ARG ENABLE_SEAFILE
ARG ENABLE_SANDBOXES
ARG ENABLE_VMACHINES
ARG ENABLE_CRONTAB
ARG ENABLE_JOBS
ARG ENABLE_RESOURCES
ARG ENABLE_EVENTS
ARG ENABLE_FREEZE
ARG ENABLE_IMNOTIFY
ARG ENABLE_NOTIFY
ARG ENABLE_PREVIEW
ARG ENABLE_WORKFLOWS
ARG ENABLE_VERIFY_CERTS
ARG ENABLE_JUPYTER
ARG ENABLE_GDP
ARG ENABLE_TWOFACTOR
ARG ENABLE_TWOFACTOR_STRICT_ADDRESS
ARG PUBKEY_FROM_DNS
ARG PREFER_PYTHON3
ARG SIGNUP_METHODS
ARG LOGIN_METHODS
ARG USER_INTERFACES
ARG AUTO_ADD_CERT_USER
ARG AUTO_ADD_OID_USER
ARG AUTO_ADD_OIDC_USER
ARG CERT_VALID_DAYS
ARG OID_VALID_DAYS
ARG GENERIC_VALID_DAYS
ARG DEFAULT_MENU
ARG USER_MENU
ARG JUPYTER_SERVICES
ARG JUPYTER_SERVICES_DESC
ARG VGRID_LABEL
ARG GDP_EMAIL_NOTIFY

ENV PYTHONPATH=${MIG_ROOT}
# Ensure that the $USER sets it during session start
RUN echo "PYTHONPATH=${MIG_ROOT}" >> ~/.bash_profile \
    && echo "export PYTHONPATH" >> ~/.bash_profile

WORKDIR $MIG_ROOT/mig/install

RUN echo "Designated jupyter services: $JUPYTER_SERVICES"
RUN echo "Designated jupyter services descriptions: $JUPYTER_SERVICES_DESC"

RUN ./generateconfs.py --source=. \
    --destination=generated-confs \
#    --destination_suffix="_svn$(svnversion -n ~/)" \
    --base_fqdn=$DOMAIN \
    --public_fqdn=${PUBLIC_DOMAIN} \
    --mig_cert_fqdn=${MIGCERT_DOMAIN} \
    --ext_cert_fqdn=${EXTCERT_DOMAIN} \
    --mig_oid_fqdn=${MIGOID_DOMAIN} \
    --ext_oid_fqdn=${EXTOID_DOMAIN} \
    --ext_oidc_fqdn=${EXTOIDC_DOMAIN} \
    --sid_fqdn=${SID_DOMAIN} \
    --io_fqdn=${IO_DOMAIN} \
    --user="${USER}" --group="${USER}" --log_level=${LOG_LEVEL} \
    --admin_email="${ADMIN_EMAIL}" --admin_list="${ADMIN_LIST}" \
    --apache_version=2.4 \
    --apache_etc=/etc/httpd \
    --apache_run=/var/run/httpd \
    --apache_lock=/var/lock/subsys/httpd \
    --apache_log=/var/log/httpd \
    --openssh_version=7.4 \
    --mig_code=/home/mig/mig \
    --mig_state=/home/mig/state \
    --mig_certs=/etc/httpd/MiG-certificates \
    --hg_path=/usr/bin/hg \
    --hgweb_scripts=/usr/share/doc/mercurial-2.6.2 \
    --trac_admin_path= \
    --trac_ini_path= \
    --openid_address=${OPENID_DOMAIN} \
    --sftp_address=${SFTP_DOMAIN} \
    --sftp_subsys_address=${SFTP_SUBSYS_DOMAIN} \
    --ftps_address=${FTPS_DOMAIN} \
    --davs_address=${WEBDAVS_DOMAIN} \
    --public_http_port=${PUBLIC_HTTP_PORT} --public_https_port=${PUBLIC_HTTPS_PORT} \
    --mig_oid_port=${MIGOID_HTTPS_PORT} --ext_oid_port=${EXTOID_HTTPS_PORT} \
    --ext_oidc_port=${EXTOIDC_HTTPS_PORT} --mig_cert_port=${MIGCERT_HTTPS_PORT} \
    --ext_cert_port=${EXTCERT_HTTPS_PORT} --sid_port=${SID_HTTPS_PORT} \
    --sftp_port=${SFTP_PORT} --sftp_subsys_port=${SFTP_SUBSYS_PORT} \
    --sftp_show_port=${SFTP_SHOW_PORT} \
    --davs_port=${DAVS_PORT} --davs_show_port=${DAVS_SHOW_PORT} \
    --ftps_ctrl_port=${FTPS_CTRL_PORT} --ftps_ctrl_show_port=${FTPS_CTRL_SHOW_PORT} \
    --mig_oid_title="${MIG_OID_TITLE}" --ext_oid_title="${EXT_OID_TITLE}" \
    --mig_oid_provider=${MIG_OID_PROVIDER} \
    --ext_oid_provider=${EXT_OID_PROVIDER} \
    --ext_oidc_provider_meta_url=${EXT_OIDC_PROVIDER_META_URL} \
    --ext_oidc_client_name="${EXT_OIDC_CLIENT_NAME}" \
    --ext_oidc_client_id="${EXT_OIDC_CLIENT_ID}" \
    --enable_openid=${ENABLE_OPENID} --enable_wsgi=True \
    --enable_sftp=${ENABLE_SFTP} --enable_sftp_subsys=${ENABLE_SFTP_SUSBSYS} \
    --enable_davs=${ENABLE_DAVS} --enable_ftps=${ENABLE_FTPS} \
    --enable_sharelinks=${ENABLE_SHARELINKS} --enable_transfers=${ENABLE_TRANSFERS} \
    --enable_duplicati=${ENABLE_DUPLICATI} --enable_seafile=${ENABLE_SEAFILE} \
    --enable_sandboxes=${ENABLE_SANDBOXES} --enable_vmachines=${ENABLE_VMACHINES} \
    --enable_crontab=${ENABLE_CRONTAB} --enable_jobs=${ENABLE_JOBS} \
    --enable_resources=${ENABLE_RESOURCES} --enable_events=${ENABLE_EVENTS} \
    --enable_freeze=${ENABLE_FREEZE} --enable_imnotify=${ENABLE_IMNOTIFY} \
    --enable_cracklib=True --enable_twofactor=${ENABLE_TWOFACTOR} \
    --enable_twofactor_strict_address=${ENABLE_TWOFACTOR_STRICT_ADDRESS} \
    --enable_notify=${ENABLE_NOTIFY} --enable_preview=${ENABLE_PREVIEW} \
    --enable_workflows=${ENABLE_WORKFLOWS} --enable_hsts=True \
    --enable_vhost_certs=True --enable_verify_certs=${ENABLE_VERIFY_CERTS} \
    --enable_jupyter=${ENABLE_JUPYTER} --enable_gdp=${ENABLE_GDP} \
    --gdp_email_notify=${GDP_EMAIL_NOTIFY} \
    --jupyter_services=${JUPYTER_SERVICES} \
    --jupyter_services_desc="${JUPYTER_SERVICES_DESC}" \
    --prefer_python3=${PREFER_PYTHON3} \
    --user_clause=User --group_clause=Group \
    --listen_clause='#Listen' \
    --serveralias_clause='ServerAlias' --alias_field=email \
    --dhparams_path=~/certs/dhparams.pem \
    --daemon_keycert=~/certs/combined.pem \
    --daemon_pubkey=~/certs/combined.pub \
    --daemon_pubkey_from_dns=${PUBKEY_FROM_DNS} \
    --daemon_show_address=${IO_DOMAIN} \
    --signup_methods="${SIGNUP_METHODS}" \
    --login_methods="${LOGIN_METHODS}" \
    --distro=centos --user_interface="${USER_INTERFACES}" \
    --skin="${EMULATE_FLAVOR}-${SKIN_SUFFIX}" \
    --title="${TITLE}" --short_title="${SHORT_TITLE}" \
    --vgrid_label="${VGRID_LABEL}" --peers_permit=${PEERS_PERMIT} \
    --vgrid_creators=${VGRID_CREATORS} --vgrid_managers=${VGRID_MANAGERS} \
    --auto_add_cert_user=${AUTO_ADD_CERT_USER} \
    --auto_add_oid_user=${AUTO_ADD_OID_USER} \
    --auto_add_oidc_user=${AUTO_ADD_OIDC_USER} \
    --cert_valid_days=${CERT_VALID_DAYS} --oid_valid_days=${OID_VALID_DAYS} \
    --generic_valid_days=${GENERIC_VALID_DAYS} \
    --default_menu="${DEFAULT_MENU}" --user_menu="${USER_MENU}" \
    --apache_worker_procs=256 --wsgi_procs=25

RUN cp generated-confs/MiGserver.conf $MIG_ROOT/mig/server/ \
    && cp generated-confs/static-skin.css $MIG_ROOT/mig/images/ \
    && cp generated-confs/index.html $MIG_ROOT/state/user_home/ \
    && cp $MIG_ROOT/mig/images/site-conf-${EMULATE_FQDN}.js $MIG_ROOT/mig/images/site-conf.js


FROM install_mig as setup_mig_configs
ARG USER
ARG DOMAIN
ARG PUBLIC_DOMAIN
ARG MIGCERT_DOMAIN
ARG EXTCERT_DOMAIN
ARG MIGOID_DOMAIN
ARG EXTOID_DOMAIN
ARG EXTOIDC_DOMAIN
ARG SID_DOMAIN
ARG EMULATE_FLAVOR
ARG EMULATE_FQDN
ARG ENABLE_SELF_SIGNED_CERTS

# Prepare oiddiscover for httpd
RUN cd $MIG_ROOT/mig \
    && python shared/httpsclient.py | grep -A 80 "xml version" \
    > $MIG_ROOT/state/wwwpublic/oiddiscover.xml

USER root

# Sftp subsys config
RUN cp generated-confs/sshd_config-MiG-sftp-subsys /etc/ssh/ \
    && chown 0:0 /etc/ssh/sshd_config-MiG-sftp-subsys

# PAM and NSS setup for sftpsubsys login to work
RUN cd $MIG_ROOT/mig/src/libpam-mig \
    && make && make install
RUN cd $MIG_ROOT/mig/src/libnss-mig \
    && make && make install

RUN cp generated-confs/libnss_mig.conf /etc/ \
    #&& cp /etc/pam.d/sshd /etc/pam.d/sshd.backup \
    && cp generated-confs/pam-sshd /etc/pam.d/sshd \
    #&& cp /etc/nsswitch.conf /etc/nsswitch.conf.backup
    && cp generated-confs/nsswitch.conf /etc/

RUN chmod 755 generated-confs/envvars \
    && chmod 755 generated-confs/httpd.conf

# Automatic inclusion confs
RUN cp generated-confs/MiG.conf $WEB_DIR/conf.d/ \
    && cp generated-confs/httpd.conf $WEB_DIR/ \
    && cp generated-confs/mimic-deb.conf $WEB_DIR/conf/httpd.conf \
    && cp generated-confs/envvars /etc/sysconfig/httpd \
    && cp generated-confs/apache2.service /lib/systemd/system/httpd.service

# Automatic Jupyter inclusion confs
RUN mkdir -p $WEB_DIR/conf.extras.d/ \
    && cp generated-confs/MiG-jupyter-def.conf /etc/httpd/conf.extras.d \
    && cp generated-confs/MiG-jupyter-openid.conf /etc/httpd/conf.extras.d \
    && cp generated-confs/MiG-jupyter-proxy.conf /etc/httpd/conf.extras.d \
    && cp generated-confs/MiG-jupyter-rewrite.conf /etc/httpd/conf.extras.d

# Root confs
RUN cp generated-confs/apache2.conf $WEB_DIR/ \
    && cp generated-confs/ports.conf $WEB_DIR/ \
    && cp generated-confs/envvars $WEB_DIR/

# Disable certificate check for OID if self-signed certs
RUN if [ "$ENABLE_SELF_SIGNED_CERTS" = "True" ]; then \
        sed -i '/\/server.ca.pem/ a SSLProxyCheckPeerName off' $WEB_DIR/conf.d/MiG.conf \
        && sed -i '/SSLProxyCheckPeerName off/ a SSLProxyCheckPeerCN off' \
        $WEB_DIR/conf.d/MiG.conf; \
    fi

# Front page
RUN cp -a $MIG_ROOT/state/wwwpublic/index-${EMULATE_FQDN}.html \
        $MIG_ROOT/state/wwwpublic/index-${DOMAIN}.html && \
    ln -s index-${DOMAIN}.html $MIG_ROOT/state/wwwpublic/index.html && \
    ln -s about-${EMULATE_FQDN}.html $MIG_ROOT/state/wwwpublic/about-snippet.html && \
    ln -s support-${EMULATE_FQDN}.html $MIG_ROOT/state/wwwpublic/support-snippet.html && \
    ln -s tips-${EMULATE_FQDN}.html $MIG_ROOT/state/wwwpublic/tips-snippet.html && \
    ln -s terms-${EMULATE_FQDN}.html $MIG_ROOT/state/wwwpublic/terms-snippet.html && \
    chown -R $USER:$USER $MIG_ROOT/state/wwwpublic/*.html

# TODO: improve this hard-coded translation
# Replace index.html redirects to instance domains
RUN sed -i -e "s@https://ext\.${EMULATE_FQDN}@https://${MIGOID_DOMAIN}@g;s@https://oid\.${EMULATE_FQDN}@https://${EXTOID_DOMAIN}@g;s@https://${EMULATE_FQDN}@https://${EXTOID_DOMAIN}@g;s@https://cert\.${EMULATE_FQDN}@https://${EXTCERT_DOMAIN}@g;s@https://sid\.${EMULATE_FQDN}@https://${SID_DOMAIN}@g" $MIG_ROOT/state/wwwpublic/index-${DOMAIN}.html

# State clean services
RUN chmod 755 generated-confs/{migstateclean,migerrors} \
    && cp generated-confs/{migstateclean,migerrors} /etc/cron.daily/

# Logrotate config
RUN cp generated-confs/logrotate-migrid /etc/logrotate.d/migrid

# Init scripts
RUN cp generated-confs/migrid-init.d-rh /etc/init.d/migrid

WORKDIR $MIG_ROOT

# Prepare default conf.d
RUN mv $WEB_DIR/conf.d/autoindex.conf $WEB_DIR/conf.d/autoindex.conf.centos \
    && mv $WEB_DIR/conf.d/ssl.conf $WEB_DIR/conf.d/ssl.conf.centos \
    && mv $WEB_DIR/conf.d/userdir.conf $WEB_DIR/conf.d/userdir.conf.centos \
    && mv $WEB_DIR/conf.d/welcome.conf $WEB_DIR/conf.d/welcome.conf.centos

# Add generated certificate to trust store
RUN update-ca-trust force-enable \
    && cp $CERT_DIR/combined.pem /etc/pki/ca-trust/source/anchors/ \
    && update-ca-trust extract

FROM setup_mig_configs as start_mig
ARG DOMAIN

# Reap defuncted/orphaned processes
ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

ADD docker-entry.sh /app/docker-entry.sh
ADD migrid-httpd.env /app/migrid-httpd.env
RUN chown $USER:$USER /app/docker-entry.sh \
    && chmod +x /app/docker-entry.sh

# Ensure the USER environment variable is set
ENV USER=$USER

USER root
WORKDIR /app

# EXPOSE is not important but keep in sync with active ports for the record
EXPOSE 80 443 444 445 446 447 448 449 2222 4443 8021 22222

CMD ["bash", "/app/docker-entry.sh"]
