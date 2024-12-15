# Vagrant Basebox Ubuntu Noble64

## 1. Project Description

Vagrant Basebox on Ubuntu 24.04 LTS 64-bit Noble. Based on ubuntu/jammy64 with do-release-upgrade to noble.

### 1.1. Business Vision

Canonical has stopped from releasing new Vagrant boxes. Update the vagrant box to the latest LTS by using do-release-upgrade.

### 1.2. Task Management

### 1.3. Personas

### 1.4. Use Cases

### 1.5. Non-Functional Requirements

## 2. Architecture

### 2.1. Technologies

Dev
* Vagrant/Virtualbox

CI
* Jenkins

### 2.2. Naming, Terms and Key Concepts

* dev: Vagrantfile
* (ci): use the dev -env on CI

### 2.3. Coding Convention

Directory structure
* doc/ for UML documents
* etc/ for nginx, ssh etc configs. Can be cp -pr etc/ /etc to the virtual machine during provisioning and matches the os directory structure
* results/ test results
* reports/ for e.g. code coverage reports
* src/ for source code
** Note! Source code should be placed under a single folder (src) that can be mounted over Docker -volume or Vagrant -shared folder inside the virtual machine so that node_modules or vendor directory are not on the shared folder. See https://wiki.phz.fi/Docker and https://wiki.phz.fi/Vagrant for further details how to circumvent the problems.
* tests/ for tests

### 2.4. Development Guide

Add here examples and hints of good ways how to code the project. Convert the silent knowledge as tacit knowledge here.
* See https://en.wikipedia.org/wiki/Knowledge_management

## 3. Development Environment

Note! PHZ Coding Convention: name this environment as dev.

### 3.1. Prerequisites

### 3.2. Start the Application

    vagrant up

Tear down

    vagrant destroy -f

Status

    vagrant status

### 3.3. Access the Application

    vagrant ssh

### 3.4. Run Tests

### 3.5. IDE Setup and Debugging

### 3.6. Version Control

https://github.com/phzfi/noble64

### 3.7. Databases and Migrations

### 3.8. Continuous Integration

PHZ.fi internal Jenkins

## 4. Staging Environment
Note! PHZ Coding Convention: name this environment as stg.

### 4.1. Access

### 4.2. Deployment

### 4.3. Smoke Tests

#### 4.3.1. Automated Test Cases

#### 4.3.2. Manual Test Cases

### 4.4. Rollback

### 4.5. Logs

### 4.6. Monitoring

## 5. Production Environment
Note! PHZ Coding Convention: name this environment as prod.

### 5.1. Access

### 5.2. Deployment

### 5.3. Smoke Tests

#### 5.3.1. Automated Test Cases

#### 5.3.2. Manual Test Cases

### 5.4. Rollback

### 5.5. Logs

### 5.6. Monitoring

## 6. Operating Manual

### 6.1. Scheduled Jobs

### 6.2. Manual Processes

## 7. Problems

### 7.1. Environments

### 7.2. Coding

### 7.3. Dependencies

Add here TODO and blockers that you have found related to upgrading to newer versions.
List the library/framework/service, version, and then the error message.

