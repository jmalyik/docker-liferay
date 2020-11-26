Inspired by

https://github.com/SvenWerlen/docker-liferay-dxp-wildfly/blob/master/base/Dockerfile

I changed it a bit as the downloading from the sourceforge.net was terrible slow, so instead of that I decided to download them to the liferay folder from here:

https://github.com/liferay/liferay-portal/releases?after=7.3.0-ga1

You will need to place the following files:

- liferay-ce-portal-7.2.1-ga2-20191111141448326.war
- liferay-ce-portal-dependencies-7.2.1-ga2-20191111141448326.zip
- liferay-ce-portal-osgi-7.2.1-ga2-20191111141448326.zip

The openldap is not in use for now I just put it there for later use.
