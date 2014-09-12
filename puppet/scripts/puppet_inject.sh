#!/bin/sh

echo "modifying /etc/hosts"
echo "131.207.104.140 puppetmaster" >> /etc/hosts

echo "modifying /etc/resolv.conf"
cat > /etc/resolv.conf <<EOF
domain tieto.com
nameserver 131.207.104.140
EOF

# create our puppet repo

echo "installing GPG keys and repositories"
wget -nv http://puppetmaster/cluster_settings/RPM-GPG-KEY-puppetlabs -O /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs || exit 1
wget -nv http://puppetmaster/cluster_settings/RPM-GPG-KEY-CentOS-6 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6 || exit 1

echo "configuring puppet repository"
wget -nv http://puppetmaster/cluster_settings/puppetlabs.repo -O /etc/yum.repos.d/puppetlabs.repo || exit 1
wget -nv http://puppetmaster/cluster_settings/centos.repo -O /etc/yum.repos.d/centos.repo || exit 1

wget -nv http://puppetmaster/cluster_settings/toas.repo -O /etc/yum.repos.d/toas.repo || exit 1

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

