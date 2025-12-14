# E2E_EKS_CICD
End-to-end EKS CI/CD Projectto deploy a Flask application to AWS EKS using Terraform and Jenkins.

## 📋 Architecture

```
GitHub → Jenkins → Docker → AWS ECR → EKS Cluster → LoadBalancer
```

## 🚀 Quick Start (Total: 2-3 hours)

### Prerequisites
- AWS Account (ID: 975050024946)
- AWS CLI configured
- GitHub account
- SSH key pair in AWS (us-west-2)

---

## 📝 Step-by-Step Implementation

### **STEP 1: Launch Jenkins EC2** (10 mins)

```bash
# 1. Launch EC2 instance
# Go to AWS Console → EC2 → Launch Instance

# Configuration:
# - Name: amoljenkins
# - AMI: Ubuntu 22.04 LTS
# - Instance type: t2.medium
# - Key pair: Your existing key
# - Security Group:
#   * Port 22 (SSH) - Your IP
#   * Port 8080 (Jenkins) - Your IP
# - Storage: 20 GB gp3

# 2. SSH into instance
ssh -i your-key.pem ubuntu@<EC2_PUBLIC_IP>

# 3. Clone your repo
git clone https://github.com/amolkhetan/e2e_eks_cicd.git
cd e2e_eks_cicd

# 4. Run Jenkins setup
chmod +x scripts/jenkins_setup.sh
./scripts/jenkins_setup.sh

# 5 Jenkins password will be there at below location
/var/lib/jenkins/secrets/initialAdminPassword
![alt text](image.png)

![alt text](image-1.png)

# This takes ~15 minutes. Note the initial admin password!
```

---

### **STEP 2: Deploy AWS Infrastructure** (20 mins)

```bash
# On your LOCAL machine/laptop

cd terraform

# Initialize Terraform
terraform init

# Review plan
terraform plan

# Deploy (takes ~15 minutes)
terraform apply -auto-approve

# Save outputs
terraform output -json > ../outputs.json

# Configure kubectl locally
aws eks update-kubeconfig --region us-west-2 --name hello-eks

# Verify cluster
kubectl get nodes

![alt text](image-2.png)

```

**Expected output:**
```
NAME                          STATUS   ROLES    AGE   VERSION
ip-10-0-10-xxx.ec2.internal   Ready    <none>   2m    v1.28.x
ip-10-0-11-xxx.ec2.internal   Ready    <none>   2m    v1.28.x
```

---
