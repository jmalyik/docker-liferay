##
## Docker image: Liferay DXP -> WildFly (JBoss)
##
## Build: docker build -t liferay-dxp-wildfly .
## Run: docker run -it -p 8080:8080 liferay-dxp-wildfly
##
FROM jboss/base-jdk:11

# ENVIRONMENT
ENV WILDFLY_VERSION		"10.1.0.Final"
ENV WILDFLY_SHA1		"9ee3c0255e2e6007d502223916cefad2a1a5e333"
ENV LIFERAY_VERSION		"7.2.1 GA2"
ENV LIFERAY_VERSION_FULL	"7.2.1-ga2-20191111141448326"
ENV LIFERAY_WAR_SHA1		"cd0a55a09a4e3e4d3e7430204f9b5b56ab3ea4f9"
ENV LIFERAY_OSGI_SHA1		"da079a183f548704bc98944ff8dd4a85a7239b3a"
ENV LIFERAY_DEPS_SHA1		"a0e72d11236597af79319653bd193b1e19e2bf76"

# PATHS
ENV DOWNLOAD			/tmp/download
ENV LIFERAY_HOME		/opt/app/liferay/
ENV WILDFLY_HOME		/opt/app/liferay/wildfly
ENV WILDFLY_STANDALONE_CFG 	/opt/app/liferay/wildfly/standalone/configuration/standalone.xml

# DOWNLOAD packages
RUN mkdir $DOWNLOAD \
    && cd $DOWNLOAD
RUN curl -O "https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz"
#ENV WARURL "http://downloads.sourceforge.net/project/lportal/Liferay Portal/$LIFERAY_VERSION/liferay-ce-portal-$LIFERAY_VERSION_FULL.war"
#RUN echo $WARURL && curl -O -L $WARURL
ADD liferay-ce-portal-$LIFERAY_VERSION_FULL.war $DOWNLOAD/liferay-ce-portal-$LIFERAY_VERSION_FULL.war
#ENV OSGIURL "http://downloads.sourceforge.net/project/lportal/Liferay Portal/$LIFERAY_VERSION/liferay-ce-portal-osgi-$LIFERAY_VERSION_FULL.zip"
#RUN echo $OSGIURL &&curl -O -L $OSGIURL
ADD liferay-ce-portal-osgi-$LIFERAY_VERSION_FULL.zip $DOWNLOAD/liferay-ce-portal-osgi-$LIFERAY_VERSION_FULL.zip
#ENV DEPSURL = "http://downloads.sourceforge.net/project/lportal/Liferay Portal/$LIFERAY_VERSION/liferay-ce-portal-dependencies-$LIFERAY_VERSION_FULL.zip"
#RUN echo $DEPSURL && curl -O -L $DEPSURL
ADD liferay-ce-portal-dependencies-$LIFERAY_VERSION_FULL.zip $DOWNLOAD/liferay-ce-portal-dependencies-$LIFERAY_VERSION_FULL.zip
RUN mv *.* $DOWNLOAD

## INSTALLATION: JBOSS WildFly
USER root
COPY files /tmp/files

RUN mkdir -p $LIFERAY_HOME \
    && cd $LIFERAY_HOME \
    && sha1sum $DOWNLOAD/wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf $DOWNLOAD/wildfly-$WILDFLY_VERSION.tar.gz \
    && ln -s $LIFERAY_HOME/wildfly-$WILDFLY_VERSION wildfly 

## LIFERAY DXP
RUN mkdir $WILDFLY_HOME/standalone/deployments/ROOT.war \
    && cd $WILDFLY_HOME/standalone/deployments/ROOT.war \
    && sha1sum $DOWNLOAD/liferay-ce-portal-$LIFERAY_VERSION_FULL.war | grep $LIFERAY_WAR_SHA1 \
    && unzip $DOWNLOAD/liferay-ce-portal-$LIFERAY_VERSION_FULL.war \
    && touch $WILDFLY_HOME/standalone/deployments/ROOT.war.dodeploy
RUN cd $LIFERAY_HOME \
    && sha1sum $DOWNLOAD/liferay-ce-portal-osgi-$LIFERAY_VERSION_FULL.zip | grep $LIFERAY_OSGI_SHA1 \
    && unzip $DOWNLOAD/liferay-ce-portal-osgi-$LIFERAY_VERSION_FULL.zip > /dev/null \
    && find -name "liferay-ce-portal-osgi*" -exec ln -s {} osgi \;
RUN mkdir -p $WILDFLY_HOME/modules/com/liferay/portal/ \
    && cd $WILDFLY_HOME/modules/com/liferay/portal/ \
    && sha1sum $DOWNLOAD/liferay-ce-portal-dependencies-$LIFERAY_VERSION_FULL.zip | grep $LIFERAY_DEPS_SHA1 \
    && unzip $DOWNLOAD/liferay-ce-portal-dependencies-$LIFERAY_VERSION_FULL.zip > /dev/null \
    && mv liferay-ce-portal-dependencies-* main \
    && cp /tmp/files/module.xml main/

## CONFIGURATION
RUN sed -i -e '/<paths/r /tmp/files/standalone-systemmodules.xml' $LIFERAY_HOME/wildfly/modules/system/layers/base/sun/jdk/main/module.xml
RUN sed -i '/org.jboss.as.weld/d' $WILDFLY_STANDALONE_CFG \
    && sed -i -e '/\/extensions/r /tmp/files/standalone-systemproperties.xml' $WILDFLY_STANDALONE_CFG \
    && sed -i 's/<deployment-scanner/<deployment-scanner deployment-timeout="360"/g' $WILDFLY_STANDALONE_CFG \
    && sed -i -e '/<security-domains/r /tmp/files/standalone-securitydomain.xml' $WILDFLY_STANDALONE_CFG \
    && sed -i '/welcome-content/d' $WILDFLY_STANDALONE_CFG \
    && sed -i '/urn:jboss:domain:weld/d' $WILDFLY_STANDALONE_CFG
RUN cat /tmp/files/standalone.conf >> $WILDFLY_HOME/bin/standalone.conf

# place postgresql driver
ENV POSTGRES_DRIVER_URL https://jdbc.postgresql.org/download/postgresql-42.2.5.jar
RUN curl -O -L ${POSTGRES_DRIVER_URL}
RUN mv postgresql-42.2.5.jar $WILDFLY_HOME/modules/com/liferay/portal/main

ADD ./files/portal-setup-wizard.properties $LIFERAY_HOME/portal-setup-wizard.properties

## USER PERMISSIONS
RUN chown -R jboss.users $LIFERAY_HOME

## CLEANUP
RUN rm -rf $HOME/files \
    && rm -rf $DOWNLOAD

# Expose the ports we're interested in EXPOSE 8080
# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
USER jboss
CMD $WILDFLY_HOME/bin/standalone.sh -b 0.0.0.0
