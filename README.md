# kubernetes cluster with minikube in AWS

This is a Terraform code which creates:

An AWS EC2 with helm, minikube, docker installed.

A security group with port 22 opened for SSH.

**Note**: If you don't have a default VPC in the region where you want to create these resources, you should create one before running this code:

```bash
aws ec2 create-default-vpc --region your-region
```

![image](https://github.com/Awan/minikube-ec2/assets/42554663/96ebecfe-0811-4bd3-a097-15a5e7517984)


Once all resources are created, you can login to EC2 and start `minikube`:

```bash
minikube start
```

![image](https://github.com/Awan/minikube-ec2/assets/42554663/7993eab9-7882-4023-a6d3-0be9a499b84a)

