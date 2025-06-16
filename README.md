# AWS Deployment Guide

This guide walks you through deploying your project to AWS using CodePipeline, CodeBuild, and CodeDeploy.

---

## 1. Upload Project to GitHub

- Add scripts to start the server and install dependencies.
- Include `buildspec.yml` for CodeBuild and `appspec.yml` for CodeDeploy.
- Use sudo for installing dependencies with pip

### Nginx (Optional)

- Use Nginx if you want to serve traffic on port 80/443 (HTTP/HTTPS).
- EC2 may restrict binding directly to port 80 without root privileges.
- Nginx listens on 80/443 and forwards requests to Gunicorn on 8080 or another port.
- Nginx can handle HTTPS termination with Let’s Encrypt.

---

## 2. Create EC2 Instance

- Select Amazon Linux, `t2.micro`.
- Allow SSH and HTTP in the security group.
- In advanced details, select the IAM role.

---

## 3. Generate GitHub Personal Access Token

- Generate a pre-granted token and copy it for later use.

---

## 4. Connect to the Instance and Install Dependencies

SSH into your instance and run:

```bash
sudo yum update
sudo yum install python3
sudo yum install python3-pip
```

Or use the following in EC2 User Data:

```bash
#!/bin/bash
sudo yum -y update
sudo yum -y install ruby
sudo yum -y install python3
sudo yum -y install python3-pip
sudo yum -y install wget
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
sudo chmod +x ./install
sudo pip install awscli
```

---

## 5. Create IAM Roles

- **CodePipelineRole**: `AWSCodePipelineFullAccess`, `AWSCodeDeployFullAccess`
- **CodeBuildRole**: `AWSCodeBuildDeveloperAccess`, S3/EC2 access
- **EC2InstanceProfile**: `AmazonEC2RoleforAWSCodeDeploy`, `AWSCodeDeployRole`
- **CodeDeploy**: `AWSCodeDeployRole`

---

## 6. Create CodeBuild Project

- Create a new project.
- Set the source to GitHub.
- Use a managed image (Amazon Linux).
- Assign the CodeBuild role.
- Use `buildspec.yml` for build instructions.
- No artifacts required.
- Enable logs.

---

## 7. Create CodeDeploy Application

- Name your application.
- Choose EC2/on-premise.
- Create a deployment group and attach the role.
- Select your EC2 instance.
- No load balancer required.
- Add your GitHub repo (`ifonsecaz/AWS_module3_part2`) and token.
- Use the latest commit ID.

---

## 8. Create CodePipeline

- Name your pipeline.
- Connect to GitHub and select your repository/branch.
- For the build stage, select CodeBuild and your project.
- For the deploy stage, select CodeDeploy and your deployment group.

---

## 9. Troubleshooting

If deployment fails, check the CodeDeploy agent status:

```bash
sudo service codedeploy-agent status
```

If not found, install the agent:

```bash
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
sudo systemctl enable codedeploy-agent
```

Check logs:

```bash
cat /var/log/aws/codedeploy-agent/codedeploy-agent.log
```

---

## 10. Security Group for Port 8080

Add a rule to allow inbound TCP traffic on port 8080 from `0.0.0.0/0`.

---

## 11. Accessing Endpoints

```
http://<your-ec2-ip>:8080/status
```

---

## 12. Notifications

- Create an SNS topic and subscription (protocol: email).
- In EventBridge, create a rule:

**Event Pattern:**

```json
{
    "source": ["aws.codepipeline"],
    "detail-type": ["CodePipeline Pipeline Execution State Change"],
    "detail": {
        "state": ["SUCCEEDED", "FAILED", "CANCELED"]
    }
}
```

- Set the target as the SNS topic you created.

---

**End of Guide**
