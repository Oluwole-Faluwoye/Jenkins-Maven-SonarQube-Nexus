MAVEN INSTALLATION ON AMAZON LINUX 2

# Apache Maven Installation/Config
sudo su
yum update -y
sudo amazon-linux-extras install java-openjdk11 -y  # Use for Java and Maven Compiler
sudo /usr/sbin/alternatives --config java  # NOTE: Select 4 or 2 or 3 for java11
java --version
wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
yum install -y apache-maven

## Configure MAVEN_HOME and PATH Environment Variables
rm .bash_profile
wget https://raw.githubusercontent.com/awanmbandi/realworld-cicd-pipeline-project/jenkins-master-client-config/.bash_profile
source .bash_profile
mvn -v

# Create ".m2" and download your "settings.xml" file into it to Authorize Maven
## Make sure to Update the RAW GITHUB Link to your "settings.xml" config
mkdir /var/lib/jenkins/.m2
wget https://raw.githubusercontent.com/DreamMyles/Jenkins-Maven-SonarQube-Nexus/refs/heads/main/settings.xml -P /var/lib/jenkins/.m2/
chown -R jenkins:jenkins /var/lib/jenkins/.m2/
chown -R jenkins:jenkins /var/lib/jenkins/.m2/settings.xml

-------------------------------------------------------------------------------------
USERDATA FOR INSTALLING MAVEN ON AMAZON LINUX 2023
-------------------------------------------------------------------------------------


#!/bin/bash

# Switch to root
sudo su

# Update packages
dnf update -y

# Install OpenJDK 11
dnf install -y java-11-amazon-corretto

sudo /usr/sbin/alternatives --config java  # NOTE: Select 4 or 2 or 3 for java11

# Verify Java version
java --version

# Set JAVA_HOME
echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))" >> /etc/profile.d/java.sh
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/profile.d/java.sh
source /etc/profile.d/java.sh

# Install Apache Maven manually
cd /opt

# Download from the archive instead of the main mirror
wget https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz

# Extract
tar -xvzf apache-maven-3.9.6-bin.tar.gz

# Create symlink
ln -s apache-maven-3.9.6 maven

# Set environment variables
cat <<EOF | sudo tee /etc/profile.d/maven.sh
export M2_HOME=/opt/maven
export PATH=\$M2_HOME/bin:\$PATH
EOF

# Load the environment
source /etc/profile.d/maven.sh

# Verify installation
mvn -version

# Setup Jenkins .m2 directory and Maven settings.xml
mkdir -p /var/lib/jenkins/.m2
wget https://raw.githubusercontent.com/DreamMyles/Jenkins-Maven-SonarQube-Nexus/refs/heads/main/settings.xml -P /var/lib/jenkins/.m2/

# Set correct permissions
chown -R jenkins:jenkins /var/lib/jenkins/.m2
chown jenkins:jenkins /var/lib/jenkins/.m2/settings.xml
