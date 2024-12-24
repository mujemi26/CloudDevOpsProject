# Ansible Infrastructure Automation 🚀

## Overview 🎯

This Ansible playbook automates the setup of a complete DevOps infrastructure environment, including essential tools and services for continuous integration and deployment (CI/CD).

## Prerequisites ✅

- Ansible 2.9 or higher installed on the control node
- SSH access to target hosts
- Sudo privileges on target hosts
- Python installed on target hosts

## Playbook Structure 📂

This playbook includes the following roles:

### 1. Common Role 🛠️

- Basic system configurations
- Essential packages installation
- Security updates
- System optimization

### 2. Docker Role 🐳

- Docker installation
- Docker daemon configuration
- Docker compose setup
- User permissions configuration

### 3. Jenkins Role ⚙️

- Jenkins server installation
- Initial configuration
- Required plugins setup
- Security configurations

### 4. Kubernetes Role ☸️

- Kubernetes components installation
- Cluster initialization
- Network plugin setup
- Required tools installation (kubectl, kubeadm, kubelet)

### 5. SonarQube Role 📊

- SonarQube server setup
- Database configuration
- Security settings
- Plugin installation

### Compelete Playbook.yaml:

```yaml
---
- hosts: all
  become: true
  gather_facts: true
  roles:
    - common
    - docker
    - jenkins
    - kubernetes
    - sonarqube
```

## Usage 🔧

1. Configure your inventory file with target hosts
2. Verify SSH connectivity to target hosts
3. Run the playbook:

```bash
ansible-playbook -i inventory/hosts main.yml
```

## Configuration ⚙️

- Modify role variables in roles/<role_name>/defaults/main.yml

- Update inventory settings in inventory/hosts

- Adjust group variables as needed

## Requirements 📋

- Minimum 4GB RAM

- 2 CPU cores

- 20GB free disk space

- Ubuntu 20.04+ / CentOS 7+ / RHEL 7+

# Ansible Configuration Guide (Ansible.cfg) 🔧

## Overview 🎯

This Part explains the Ansible configuration file (`ansible.cfg`) settings used in our infrastructure automation. These settings optimize Ansible's performance and security for our deployment needs.

## Configuration Details ⚙️

### Default Settings [defaults] 🛠️

#### Temporary Directory

```ini
remote_tmp = /tmp/ansible
host_key_checking = False
shell_executable = /bin/bash
become = yes
allow_world_readable_tmpfiles = true
pipelining = True

[privilege_escalation]
become_method = sudo
become_user = root
```

- 📁 Specifies where Ansible stores temporary files on remote hosts

- 🔄 Ensures clean operation across multiple runs

#### SSH Host Key Checking

```ini
host_key_checking = False
```

- 🔑 Disables SSH host key verification

- ⚠️ Security Note : Enable this in production environments for enhanced security

#### Shell Configuration

```ini
shell_executable = /bin/bash
```

- 🐚 Sets Bash as the default shell

- 💻 Ensures consistent command execution across hosts

#### Privilege Elevation

```ini
become = yes
```

- 👑 Automatically enables privilege escalation

- 🔐 Allows Ansible to execute commands with elevated privileges

#### Temporary Files Permission

```ini
allow_world_readable_tmpfiles = true
```

- 📝 Permits world-readable temporary files

- 🔓 Useful when multiple users need access to temporary files

#### Performance Optimization

```ini
pipelining = True
```

- 🚀 Improves performance by reducing SSH connections

- ⚡ Reduces the number of required SSH sessions

#### Privilege Escalation Settings privilege_escalation 🔑

##### Sudo Configuration

```ini
become_method = sudo
become_user = root
```

- 🔐 Specifies sudo as the privilege escalation method

- 👤 Sets root as the target user for privilege escalation

## Troubleshooting 🔍

### Common Issues

- 1.Permission Denied

  - Verify sudo permissions

  - Check become_user settings

  - Review temporary directory permissions

- 2.SSH Connection Issues

  - Validate SSH key configuration

  - Check host key settings

  - Verify network connectivity

- 3.Performance Problems

  - Confirm pipelining is enabled

  - Check system resources

  - Monitor temporary file cleanup

# Ansible Inventory Configuration 📚

## Overview 🎯

This document details the inventory structure for our DevOps infrastructure, defining both development and production environments with Jenkins and SonarQube servers.

## Inventory Structure 🏗️

```yaml
all: # Root group containing all environments
  children:
    dev:
      hosts:
        jenkins-dev:
          ansible_host: 54.227.59.176
          ansible_user: ubuntu
          ansible_ssh_private_key_file: /Users/muhammadjimmy/Downloads/ivolve-final-project.pem
        sonarqube-dev:
          ansible_host: 54.221.92.185
          ansible_user: ubuntu
          ansible_ssh_private_key_file: /Users/muhammadjimmy/Downloads/ivolve-final-project.pem
    prod:
      hosts:
        jenkins-prod:
          ansible_host: 52.201.249.92
          ansible_user: ubuntu
          ansible_ssh_private_key_file: /Users/muhammadjimmy/Downloads/ivolve-final-project.pem
        sonarqube-prod:
          ansible_host: 54.80.213.253
          ansible_user: ubuntu
          ansible_ssh_private_key_file: /Users/muhammadjimmy/Downloads/ivolve-final-project.pem
```

## Environment Details 🌍

### Development Environment 🔧

- Jenkins Server

  - Host: jenkins-dev

  - IP: 54.227.59.176

  - User: ubuntu

  - Authentication: SSH key

- SonarQube Server

  - Host: sonarqube-dev

  - IP: 54.221.92.185

  - User: ubuntu

  - Authentication: SSH key

### Production Environment 🚀

- Jenkins Server

  - Host: jenkins-prod

  - IP: 52.201.249.92

  - User: ubuntu

  - Authentication: SSH key

- SonarQube Server

  - Host: sonarqube-prod

  - IP: 54.80.213.253

  - User: ubuntu

  - Authentication: SSH key

## Configuration Parameters ⚙️

### Common Settings for All Hosts

```yaml
ansible_user: ubuntu                 # SSH user for connection
ansible_ssh_private_key_file: *.pem  # SSH private key location
```

### Basic Commands 💻

```bash
# Test connection to all hosts
ansible all -m ping -i inventory.yaml

# List all hosts
ansible all --list-hosts -i inventory.yaml

# Target specific environment
ansible dev -m ping -i inventory.yaml
ansible prod -m ping -i inventory.yaml
```

### Targeting Specific Servers 🎯

```bash
# Target Jenkins servers
ansible '*jenkins*' -i inventory.yaml

# Target SonarQube servers
ansible '*sonarqube*' -i inventory.yaml
```

### SSH Key Setup 🔑

- 1.Ensure key permissions: chmod 600 \*.pem

- 2.Verify key location is accessible

- 3.Test SSH connection manually before Ansible use

### Troubleshooting 🔍

- 1.Connection Issues

  - Verify IP addresses

  - Check SSH key permissions

  - Confirm security group settings

  - Test direct SSH access

- 2.Authentication Problems

  - Validate user existence

  - Check SSH key path

  - Verify user permissions

### Validation Steps ✅

- 1.Verify inventory syntax:

```bash
ansible-inventory --list -i inventory.yaml
```

- 2.Test connectivity:

```bash
ansible all -m ping -i inventory.yaml
```

# Common Role Tasks Documentation 🛠️

## Overview 🎯

This document details the common role tasks that set up the basic system configuration and essential packages for our infrastructure. These tasks form the foundation for other roles to build upon.

## Task Breakdown 📋

### 1. System Updates 🔄

```yaml
- name: Update apt cache
  apt:
    update_cache: yes
    cache_valid_time: 3600
```

- Updates package repository cache

- Cache remains valid for 1 hour (3600 seconds)

- Ensures efficient package management

### 2. Essential Packages Installation 📦

```yaml
- name: Install common packages
  apt:
    name:
      - git
      - curl
      - wget
      - unzip
      - software-properties-common
    state: present
```

Installs core utilities:

- 🔧 Git (Version Control)

- 🌐 Curl (Data Transfer)

- ⬇️ Wget (File Download)

- 📎 Unzip (File Compression)

- ⚙️ Software Properties Common (Repository Management)

### 3. Environment Variables Configuration 🌍

```yaml
- name: Set up environment variables
  lineinfile:
    path: /etc/environment
```

Configures system-wide environment variables:

- JAVA_HOME: Java installation path

- JENKINS_HOME: Jenkins workspace directory

- PATH: System executable paths

### 4. Temporary Directory Setup 📁

```yaml
- name: Ensure Ansible temp directory exists
  file:
    path: /tmp/ansible
    state: directory
    mode: "0777"
```

Creates and configures Ansible temporary directory:

- Location: /tmp/ansible

- Full permissions (777)

- Root ownership

### 5. SELinux Context Configuration 🔒

```yaml
- name: Set correct SELinux context
  command: chcon -Rt tmp_t /tmp/ansible
```

Sets appropriate SELinux context for temp directory:

- Applies tmp_t context

- Ignores errors if SELinux is disabled

## Variables 📝

- java_version: Java version to be installed

- Default paths can be customized in vars/main.yml

## Troubleshooting 🔍

Common Issues

- 1.Package Installation Failures:

  - Check internet connectivity

  - Verify repository access

  - Ensure apt cache is updated

- 2.Permission Issues

  - Verify sudo access

  - Check directory permissions

  - Confirm user privileges

- 3.SELinux Errors

  - Verify SELinux status

  - Check security contexts

  - Review audit logs

# Docker Role Tasks Guide 🐳

## Overview 🎯

This Part details the Ansible tasks for installing and configuring Docker on Ubuntu systems. The role automates the complete Docker setup process, from installing dependencies to user permission management.

## Task Breakdown 📋

### 1. Docker Dependencies Installation 📦

```yaml
- name: Install Docker dependencies
  apt:
    name:
      - apt-transport-https
      - ca-certificates
      - gnupg
      - lsb-release
```

Installs required packages:

- 🔒 apt-transport-https: Secure apt transport

- 📜 ca-certificates: SSL certificates

- 🔑 gnupg: GNU privacy guard

- ℹ️ lsb-release: Linux Standard Base info

### 2. Docker Repository Setup 🔄

```yaml
- name: Add Docker GPG key
  apt_key:
    url: https://download.docker.com/linux/ubuntu/gpg

- name: Add Docker repository
  apt_repository:
    repo: deb [arch=amd64] https://download.docker.com/linux/ubuntu
```

- Adds Docker's official GPG key

- Configures Docker repository

- Ensures secure package downloads

### 3. Docker Installation ⚙️

```yaml
- name: Install Docker
  apt:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
```

Installs core Docker components:

- Docker Community Edition

- Docker CLI tools

- Containerd runtime

### 4. User Permissions Configuration 👥

```yaml
- name: Add users to docker group
  user:
    name: "{{ item }}"
    groups: docker
    append: yes
  loop: "{{ docker_users }}"
```

- Adds specified users to Docker group

- Enables Docker command execution without sudo

- Maintains existing user groups

## Variables 📝

- docker_users: List of users to add to Docker group

- ansible_distribution_release: Ubuntu release name

## Troubleshooting 🔍

Common Issues:

- 1.Repository Issues:

  - Check internet connectivity

  - Verify GPG key import

  - Confirm repository URL

- 2.Installation Failures

  - Check system requirements

  - Verify package availability

  - Review error logs

- 3.Permission Problems

  - Verify group membership

  - Check user existence

  - Confirm group creation

### System Verification

```bash
# Check Docker status
systemctl status docker

# Verify user permissions
groups <username>

# Test Docker functionality
docker run hello-world
```

# Jenkins Role Tasks Guide 🔧

## Overview 🎯

This Part details the Ansible tasks for installing and configuring Jenkins CI/CD server. The role automates the complete Jenkins setup process, from Java installation to initial password retrieval.

## Task Breakdown 📋

### 1. Java Installation ☕

```yaml
- name: Ensure Java is installed
  apt:
    name: openjdk-17-jdk
```

- Installs OpenJDK 17

- Required for Jenkins operation

- Includes automatic cache update

### 2. Dependencies Installation 📦

```yaml
- name: Install required packages
  apt:
    name:
      - curl
      - gnupg
      - apt-transport-https
```

Essential packages:

- 🌐 curl: Data transfer tool

- 🔐 gnupg: Encryption utilities

- 🔒 apt-transport-https: Secure apt transport

### 3. Jenkins Repository Setup 🔄

```yaml
- name: Add Jenkins repository keyring
- name: Add Jenkins repository
```

- Adds Jenkins GPG key

- Configures stable repository

- Sets appropriate file permissions

### 4. Jenkins Installation ⚙️

```yaml
- name: Install Jenkins
  apt:
    name: jenkins
```

- Installs latest stable Jenkins

- Updates package cache

- Ensures consistency

### 5. Service Management 🚀

```yaml
- name: Ensure Jenkins is started and enabled
  service:
    name: jenkins
```

- Starts Jenkins service

- Enables auto-start

- Ensures service reliability

### 6. Initial Setup 🔑

```yaml
- name: Wait for Jenkins to start up
- name: Get initial admin password
- name: Print Jenkins initial admin password
```

- Waits for service readiness

- Retrieves admin password

- Displays setup information

#### System Requirements 💻

- Java 17 (OpenJDK)

- 256MB+ RAM for Jenkins

- 1GB+ disk space

- Internet connectivity

#### Port Configuration 🌐

- Default port: 8080

- HTTPS port: 8443 (optional)

- Agent port: 50000

## Troubleshooting Guide 🔍

Common Issues:

- 1.Service Won't Start

  - Check Java installation

  - Verify port availability

  - Review service logs

- 2.Access Problems

  - Check firewall settings

  - Verify port configuration

  - Confirm network access

- 3.Installation Failures

  - Verify dependencies

  - Check disk space

  - Review package repository

# Kubernetes Tools Installation Role 🎯

## Overview ☸️

This Ansible role automates the installation of essential Kubernetes tools: kubectl (Kubernetes command-line tool) and kind (Kubernetes IN Docker). These tools are fundamental for local Kubernetes development and cluster management.

## Task Breakdown 📋

### 1. kubectl Installation 🛠️

```yaml
- name: Download kubectl
  get_url:
    url: "https://dl.k8s.io/release/v{{ kubectl_version }}/bin/linux/amd64/kubectl"
    dest: /usr/local/bin/kubectl
    mode: "0755"
```

- Downloads official kubectl binary

- Sets executable permissions

- Installs to system PATH

### 2. kind Installation 🐳

```yaml
- name: Download kind
  get_url:
    url: "https://kind.sigs.k8s.io/dl/v{{ kind_version }}/kind-linux-amd64"
    dest: /usr/local/bin/kind
    mode: "0755"
```

- Downloads kind binary

- Sets executable permissions

- Enables local cluster creation

## Prerequisites ✅

- Linux x86_64 system

- Internet connectivity

- Ansible 2.9+

- Root/sudo access

- Docker installed

## Installation Path 📂

- kubectl: /usr/local/bin/kubectl

- kind: /usr/local/bin/kind

## Verification Steps 🔍

```bash
# Check kubectl version
kubectl version --client

# Verify kind installation
kind version

# Create test cluster
kind create cluster --name test
```

# SonarQube Default Configuration Role Guide 🔍

## Overview 🎯

This Part details the default configuration variables for the SonarQube Ansible role. These settings define the core parameters for installing and configuring a SonarQube instance.

## Default Variables Breakdown 📋

### Version Configuration 📌

```yaml
sonarqube_version: "9.9.0.65466"
```

- Specifies SonarQube release version

- LTS (Long Term Support) version

- Stable release for production use

### User and Group Settings 👥

```yaml
sonarqube_user: sonar
sonarqube_group: sonar
```

- System user for SonarQube

- Dedicated service group

- Security isolation

### Directory Structure 📂

```yaml
sonarqube_home: /opt/sonarqube
sonarqube_data_dir: "{{ sonarqube_home }}/data"
sonarqube_temp_dir: "{{ sonarqube_home }}/temp"
```

- Base installation directory

- Data storage location

- Temporary file storage

### Database Configuration 💾

```yaml
sonarqube_db_name: sonar
sonarqube_db_user: sonar
sonarqube_db_password: sonar123
```

- Database name

- Database user credentials

- ⚠️ Change default password in production

### Network Settings 🌐

```yaml
sonarqube_web_port: 9000
```

- Web interface port

- Default HTTP access

- Service accessibility

### Java Runtime Options ☕

```yaml
sonarqube_java_opts: "-Xms512m -Xmx1024m"
```

- Minimum heap size: 512MB

- Maximum heap size: 1024MB

- JVM memory allocation

## System Requirements ⚙️

### Minimum Specifications:

- RAM: 4GB minimum

- CPU: 2 cores minimum

- Disk: 5GB minimum

- Java: OpenJDK 11+

### Recommended Specifications:

- RAM: 8GB+

- CPU: 4+ cores

- Disk: 20GB+

- SSD storage recommended

## Troubleshooting 🔍

Common Issues

- 1.Memory Problems

  - Check Java options

  - Monitor heap usage

  - Verify system resources

- 2.Permission Errors

  - Verify user/group

  - Check directory permissions

  - Review log files

- 3.Database Connection

  - Verify credentials

  - Check connectivity

  - Review database logs

## Environment Variables 🌍

```bash
SONAR_HOME=/opt/sonarqube
SONAR_JDBC_URL=jdbc:postgresql://localhost/sonar
SONAR_JDBC_USERNAME=sonar
SONAR_JDBC_PASSWORD=sonar123
```

# SonarQube Ansible Role Guide (Main.yml Task)

## Overview 🛠️

This Ansible role automates the installation and configuration of SonarQube on a server. SonarQube is a popular platform for continuous inspection of code quality.

## Requirements 📋

Ensure you have Ansible installed and the necessary privileges to perform the tasks.

## Variables 📦

Make sure to set the following variables in your playbook:

- `sonarqube_group`: The group to be created for SonarQube.
- `sonarqube_user`: The user to be created for SonarQube.
- `sonarqube_home`: The home directory for SonarQube.
- `sonarqube_version`: The version of SonarQube to be installed.
- `postgres_password`: The password for the PostgreSQL `postgres` user.
- `sonarqube_db_user`: The PostgreSQL user for the SonarQube database.
- `sonarqube_db_password`: The password for the SonarQube PostgreSQL user.
- `sonarqube_db_name`: The name of the SonarQube PostgreSQL database.

## Tasks 📝

### 1. Create SonarQube Group

```yaml
- name: Create SonarQube group
  group:
    name: "{{ sonarqube_group }}"
    state: present
```

### 2. Create SonarQube User

```yaml
- name: Create SonarQube user
  user:
    name: "{{ sonarqube_user }}"
    group: "{{ sonarqube_group }}"
    home: "{{ sonarqube_home }}"
    shell: /bin/bash
    system: yes
```

### 3. Install Required Packages

```yaml
- name: Install required packages
  apt:
    name:
      - postgresql
      - postgresql-contrib
      - python3-psycopg2
      - acl
    state: present
    update_cache: yes
  become: true
```

### 4. Configure PostgreSQL 🛢️

```yaml
- name: Find PostgreSQL version directory
  shell: "ls -d /etc/postgresql/*/ | head -n 1"
  register: pg_version_dir
  changed_when: false
  become: true

- name: Debug PostgreSQL directory
  debug:
    var: pg_version_dir.stdout

- name: Update pg_hba.conf for password authentication
  postgresql_pg_hba:
    dest: "{{ pg_version_dir.stdout }}main/pg_hba.conf"
    contype: host
    databases: all
    method: md5
    users: all
    source: localhost
    create: true
  become: true
  notify: Restart PostgreSQL

- name: Update pg_hba.conf for local connections
  postgresql_pg_hba:
    dest: "{{ pg_version_dir.stdout }}main/pg_hba.conf"
    contype: local
    databases: all
    method: md5
    users: all
    create: true
  become: true
  notify: Restart PostgreSQL

- name: Create handler for PostgreSQL restart
  meta: flush_handlers

- name: Ensure PostgreSQL is started and enabled
  systemd:
    name: postgresql
    state: started
    enabled: yes
    daemon_reload: yes
  become: true

- name: Wait for PostgreSQL to be ready
  wait_for:
    port: 5432
    timeout: 30

- name: Set postgres user password
  postgresql_user:
    name: postgres
    password: "{{ postgres_password }}"
  become: true
  become_user: postgres
  become_method: sudo
  when: postgres_password is defined

- name: Check if PostgreSQL user exists
  postgresql_query:
    db: postgres
    query: "SELECT 1 FROM pg_roles WHERE rolname='{{ sonarqube_db_user }}'"
    login_user: postgres
    login_host: localhost
    login_password: "{{ postgres_password }}"
  become: true
  become_user: postgres
  become_method: sudo
  register: user_check
  ignore_errors: true

- name: Terminate existing database connections for sonarqube user
  postgresql_query:
    db: postgres
    query: "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE usename = '{{ sonarqube_db_user }}'"
    login_user: postgres
    login_host: localhost
    login_password: "{{ postgres_password }}"
  become: true
  become_user: postgres
  become_method: sudo
  when: user_check.rowcount > 0
  ignore_errors: true

- name: Revoke all privileges from PostgreSQL user
  postgresql_query:
    db: postgres
    query: "REASSIGN OWNED BY {{ sonarqube_db_user }} TO postgres; DROP OWNED BY {{ sonarqube_db_user }}"
    login_user: postgres
    login_host: localhost
    login_password: "{{ postgres_password }}"
  become: true
  become_user: postgres
  become_method: sudo
  when: user_check.rowcount > 0
  ignore_errors: true

- name: Drop PostgreSQL user if exists
  postgresql_user:
    name: "{{ sonarqube_db_user }}"
    state: absent
    login_user: postgres
    login_host: localhost
    login_password: "{{ postgres_password }}"
  become: true
  become_user: postgres
  become_method: sudo
  when: user_check.rowcount > 0

- name: Drop PostgreSQL database if exists
  postgresql_db:
    name: "{{ sonarqube_db_name }}"
    state: absent
    login_user: postgres
    login_host: localhost
    login_password: "{{ postgres_password }}"
  become: true
  become_user: postgres
  become_method: sudo

- name: Create PostgreSQL user
  postgresql_user:
    name: "{{ sonarqube_db_user }}"
    password: "{{ sonarqube_db_password }}"
    role_attr_flags: CREATEDB,SUPERUSER
    login_user: postgres
    login_host: localhost
    login_password: "{{ postgres_password }}"
  become: true
  become_user: postgres
  become_method: sudo

- name: Create PostgreSQL database
  postgresql_db:
    name: "{{ sonarqube_db_name }}"
    owner: "{{ sonarqube_db_user }}"
    encoding: UTF8
    template: template0
    login_user: postgres
    login_host: localhost
    login_password: "{{ postgres_password }}"
  become: true
  become_user: postgres
  become_method: sudo
```

- Find PostgreSQL version directory

- Update pg_hba.conf for password and local authentication

- Set postgres user password

- Create and configure PostgreSQL user and database for SonarQube

### 5. Download and Extract SonarQube 📥

```yaml
- name: Download SonarQube
  get_url:
    url: "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-{{ sonarqube_version }}.zip"
    dest: /tmp/sonarqube.zip
    mode: "0644"
  register: download_result
  until: download_result is success
  retries: 3
  delay: 5

- name: Create SonarQube directory
  file:
    path: "{{ sonarqube_home }}"
    state: directory
    owner: "{{ sonarqube_user }}"
    group: "{{ sonarqube_group }}"
    mode: "0755"

- name: Check if SonarQube is already extracted
  stat:
    path: "{{ sonarqube_home }}/conf"
  register: sonarqube_conf

- name: Create temporary directory
  file:
    path: /tmp/sonarqube_temp
    state: directory
    mode: "0755"
  when: not sonarqube_conf.stat.exists

- name: Extract SonarQube to temp directory
  unarchive:
    src: /tmp/sonarqube.zip
    dest: /tmp/sonarqube_temp
    remote_src: yes
  when: not sonarqube_conf.stat.exists

- name: Find extracted directory name
  find:
    paths: /tmp/sonarqube_temp
    file_type: directory
    recurse: no
  register: found_directory
  when: not sonarqube_conf.stat.exists

- name: Copy SonarQube files to final location
  shell: "cp -R {{ found_directory.files[0].path }}/* {{ sonarqube_home }}/"
  when: not sonarqube_conf.stat.exists and found_directory.files | length > 0

- name: Set ownership of SonarQube directory
  file:
    path: "{{ sonarqube_home }}"
    owner: "{{ sonarqube_user }}"
    group: "{{ sonarqube_group }}"
    recurse: yes
    mode: "0755"
```

- Download SonarQube

- Extract to the desired directory

- Set ownership and permissions

### 6. Configure SonarQube ⚙️

```yaml
- name: Configure SonarQube properties
  template:
    src: sonar.properties.j2
    dest: "{{ sonarqube_home }}/conf/sonar.properties"
    owner: "{{ sonarqube_user }}"
    group: "{{ sonarqube_group }}"
    mode: "0640"

- name: Configure SonarQube wrapper
  template:
    src: wrapper.conf.j2
    dest: "{{ sonarqube_home }}/conf/wrapper.conf"
    owner: "{{ sonarqube_user }}"
    group: "{{ sonarqube_group }}"
    mode: "0640"

- name: Create SonarQube service
  template:
    src: sonarqube.service.j2
    dest: /etc/systemd/system/sonarqube.service
    mode: "0644"
  notify: Restart SonarQube

- name: Ensure elastic search limits are set
  sysctl:
    name: "{{ item.key }}"
    value: "{{ item.value }}"
    state: present
    reload: yes
  with_items:
    - { key: "vm.max_map_count", value: "262144" }
    - { key: "fs.file-max", value: "65536" }

- name: Configure system limits for SonarQube
  pam_limits:
    domain: "{{ sonarqube_user }}"
    limit_type: "{{ item.limit_type }}"
    limit_item: "{{ item.limit_item }}"
    value: "{{ item.value }}"
  with_items:
    - { limit_type: "-", limit_item: "nofile", value: "65536" }
    - { limit_type: "-", limit_item: "nproc", value: "4096" }
```

- Configure sonar.properties

- Configure wrapper.conf

- Create systemd service for SonarQube

- Ensure elastic search and system limits are set

### 7. Start and Enable SonarQube Service 🚀

```yaml
- name: Start and enable SonarQube service
  systemd:
    name: sonarqube
    state: started
    enabled: yes
    daemon_reload: yes
```

### Handlers 🔄

- Restart PostgreSQL

- Restart SonarQube

## Troubleshooting 🔍

### Common Issues and Solutions

- 1.Failed to Connect to the Marketplace via Proxy

  - Issue: SonarQube fails to connect to the marketplace through a proxy.

  - Solution: Ensure that the proxy settings in sonar.properties are correctly configured. If the username contains a backslash, escape it properly.

- 2.Elasticsearch Cannot Run as Root

  - Issue: SonarQube starts an Elasticsearch process, which cannot run as root.

  - Solution: Run SonarQube using a non-root account. Create a dedicated account for SonarQube.

- 3.Java Version Mismatch

  - Issue: SonarQube requires a specific Java version (e.g., JRE 11).

  - Solution: Ensure you have the correct Java version installed. Update your environment variables if necessary.

- 4.Out of Memory Error

  - Issue: SonarQube runs out of memory during analysis.

  - Solution: Increase the Java heap size. Ensure your system has sufficient RAM2.

- 5.Database-Related Issues

  - Issue: Issues with connecting to or configuring the database.

  - Solution: Verify database credentials and ensure the database is running. Check for any network issues.

- 6.Self-Signed Certificates

  - Issue: Issues with self-signed certificates when integrating with DevOps platforms.

  - Solution: Add the CA certificate to the Java truststore. Use the keytool command to import the certificate.

- 7.Port Availability

  - Issue: Default port is already in use.

  - Solution: Change the default port in the sonar.properties file.

- 8.System Limits

  - Issue: System limits are too low for SonarQube to run properly.

  - Solution: Configure system limits using sysctl and pam_limits2.

- 9.SonarQube Service Not Starting

  - Issue: SonarQube service fails to start or enable.

  - Solution: Check the service status and logs for errors. Ensure all dependencies are installed and configured correctly.

- 10.DNS Cache Issues

  - Issue: DNS cache settings causing connectivity issues.

  - Solution: Adjust the DNS cache settings in the JVM configuration
