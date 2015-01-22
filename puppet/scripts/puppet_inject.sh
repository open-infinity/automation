#!/bin/sh

# Command line arguments
if [ "$1" != "" ] ; then
    PUPPETMASTER=$1
else
    echo "Usage: puppet_inject.sh <puppetmaster ip address>"
    exit 1
fi

# Ping management node
ping -q -c 1 $PUPPETMASTER >/dev/null
if [ "$?" -ne "0" ]; then
	echo "$PUPPETMASTER doesn't respond to ping"
	exit 1
fi

# /etc/hosts
echo "modifying /etc/hosts"
echo "$PUPPETMASTER puppetmaster" >> /etc/hosts

# /resolv.conf
echo "modifying /etc/resolv.conf"
cat > /etc/resolv.conf <<EOF
domain tieto.com
nameserver $PUPPETMASTER
EOF

# create our puppet repo

echo "Configuring toas repository"
wget -nv http://puppetmaster/cluster_settings/toas.repo -O /etc/yum.repos.d/toas.repo || exit 1

echo "Configuring puppet repository"
wget -nv http://puppetmaster/cluster_settings/RPM-GPG-KEY-puppetlabs -O /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs || exit 1
wget -nv http://puppetmaster/cluster_settings/puppetlabs.repo -O /etc/yum.repos.d/puppetlabs.repo || exit 1

echo "Configuring centos repository"
wget -nv http://puppetmaster/cluster_settings/RPM-GPG-KEY-CentOS-6 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6 || exit 1
wget -nv http://puppetmaster/cluster_settings/centos.repo -O /etc/yum.repos.d/centos.repo || exit 1

echo "Cleaning repository cache"
yum -q clean all

# install puppet
echo "Install puppet"
yum install -q -y puppet || exit 1

# Get puppet.conf
echo "Getting puppet.conf"
wget -q http://puppetmaster/cluster_settings/puppet.conf -O /etc/puppet/puppet.conf || exit 1
HOSTNAME=`hostname` sed -i -e "s/HOSTNAME/${HOSTNAME}/" /etc/puppet/puppet.conf

# Introduce to puppet master
echo "Introducing puppet agent to master ... manual signing expected on puppetmaster soon"
puppet agent --server puppetmaster --waitforcert 60 --no-daemonize --test || exit 1

# Restart puppet
echo "Restarting puppet"
/etc/init.d/puppet start || exit 1

# Repo meta data cleaning is needed, because puppet modifies the repo files
yum -q clean all

# Succeeded
echo "All done."

