![Diagram](https://github.com/bgd11090/test_aws_tf/blob/main/devopstask.drawio.png)

# Terraform task for AWS

This repository contains scripts and configurations to deploy a system on AWS with the following components:

## Components

- **1 VPC**
- **3 backend subnets**
- **3 frontend subnets**
- **3 database subnets**
- **3 route tables**

### Routing Configuration

- Frontend subnets are routed through the Internet Gateway (IGW).
- Backend subnets are routed through a NAT Gateway (NAT).
- Database subnets are routed through a blackhole.

### EC2 Instances

- **3 EC2 instances** deployed across different availability zones, preferably using Ubuntu 22.04 LTS.

### S3 Bucket

- An S3 bucket for storing static content to be used by the EC2 instances running Nginx.
- EC2 instances have access to download files from this S3 bucket.

### Application Load Balancer (ALB) <br/>
> **Note at the end!**

- An internet-facing **ALB** listening on ports 80/tcp and 443/tcp.
- Port 80/tcp forcefully redirects to HTTPS.

### Target Group

- A target group configured to route traffic to EC2 instances on port 80/tcp.

## Deployment

The environment is designed to be:

- Easy to apply
- Easy to destroy
- Easy to adjust in terms of instance types, VPC subnets, etc.

## Optional Stretch Objective

As an optional stretch objective, an **Ansible playbook** is provided to:

- Install Nginx on the EC2 instances.
- Inject a simple configuration file for Nginx.

---

### Pre-requisites

- Terraform installed
```javascript Centos 7
- sudo yum install -y yum-utils
- sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
- sudo yum -y install terraform
```
- Ansible installed
```javascript Centos 7
- sudo yum install epel-release
- sudo yum install ansible
```
- AWS CLI installed
```javascript Centos 7
- sudo yum -y update 
- sudo yum -y upgrade
- sudo yum -y makecache
- sudo yum -y install unzip
- curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscli.zip
- sudo unzip awscli.zip
- ./aws/install -i /usr/bin/aws-cli -b /usr/bin
```

### Deployment Instructions
- Clone this repository
- Run ```aws configure``` and establish your credentials
- Run a ```terraform init``` to grab providers and modules
- Run a ```terraform apply``` and wait untill you got instance_ip = "public.ip.address"
- Run a ```chmod 600 tfkey```
- Run a command for ansible:
```bash
ansible-playbook -i aws_ec2.yaml -e ansible_ssh_private_key_file=tfkey -e ansible_ssh_user=ubuntu nginx_setup.yaml
```

### Test Functionality
Try to access via browser on public ip address that you got eather from TF or Ansible outputs. <br/>
**Note: You need to access with http(port 80) because right now port 443 is commented out for reason that we need to validate ssl certificate, in case you want to do it you need to do few quick steps:**

- Create dns (we can do it with Route53 service on aws)
- Go to AWS Certificate manager and validate your certificate
- You will than need to change value of certificate_arn in main.tf file in line 382 with your certificate value
- Uncomment aws_lb_listener resource in main.tf file in lines 369 and 384
- Run again ```terraform apply``` and ansible command:
```bash
ansible-playbook -i aws_ec2.yaml -e ansible_ssh_private_key_file=tfkey -e ansible_ssh_user=ubuntu nginx_setup.yaml
```
 


