#!/bin/bash
VERSION="1.1.0"

LDAP_HOST="${LDAP_HOST:-ldap.example.com}"
LDAP_PORT="${LDAP_PORT:-389}"
LDAP_USERNAME="${LDAP_USERNAME:-cn=admin,dc=example,dc=com}"
LDAP_PASSWORD="${LDAP_PASSWORD:-password}"
LDAP_BASEDN="${LDAP_BASEDN:-dc=example,dc=com}"
LDAP_USER_CN="${LDAP_USER_CN:-sAMAccountName}"
LDAP_GROUP_CN="${LDAP_GROUP_CN:-group}"
LDAP_GROUP_ATTRIBUTE="${LDAP_GROUP_ATTRIBUTE:-memberOf}"

LDAP_RADIUS_ACCESS_GROUP="${LDAP_RADIUS_ACCESS_GROUP:-}"
RADIUS_CLIENT_CREDENTIALS="${RADIUS_CLIENT_CREDENTIALS:-}"
RADIUSD_ARGS="${RADIUSD_ARGS:--f -l stdout}"


sed -i -e "s/LDAP_HOST/${LDAP_HOST}/g" /etc/raddb/mods-enabled/ldap
sed -i -e "s/LDAP_PORT/${LDAP_PORT}/g" /etc/raddb/mods-enabled/ldap
sed -i -e "s/LDAP_USERNAME/${LDAP_USERNAME}/g" /etc/raddb/mods-enabled/ldap
sed -i -e "s/LDAP_PASSWORD/${LDAP_PASSWORD}/g" /etc/raddb/mods-enabled/ldap
sed -i -e "s/LDAP_BASEDN/${LDAP_BASEDN}/g" /etc/raddb/mods-enabled/ldap
sed -i -e "s/LDAP_USER_CN/${LDAP_USER_CN}/g" /etc/raddb/mods-enabled/ldap
sed -i -e "s/LDAP_GROUP_CN/${LDAP_GROUP_CN}/g" /etc/raddb/mods-enabled/ldap
sed -i -e "s/LDAP_GROUP_ATTRIBUTE/${LDAP_GROUP_ATTRIBUTE}/g" /etc/raddb/mods-enabled/ldap
sed -i -e "s/LDAP_RADIUS_ACCESS_GROUP/${LDAP_RADIUS_ACCESS_GROUP}/g" /etc/raddb/sites-enabled/default

# setup clients
IFS=$',' read -ra RADIUS_CLIENT_CREDENTIALS_ARRAY <<< "$RADIUS_CLIENT_CREDENTIALS"
for i in "${RADIUS_CLIENT_CREDENTIALS_ARRAY[@]}"; do
    CLIENT="${i%%:*}"
    SECRET="${i#*:}"
    cat >> /etc/raddb/clients.conf << EOF
client $CLIENT {
    secret = $SECRET
    shortname = $CLIENT
    ipaddr = $CLIENT
    nas_type = other
}
EOF
done

/usr/sbin/radiusd $RADIUSD_ARGS