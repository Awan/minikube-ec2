# kubernetes cluster with minikube in AWS

This is a Terraform code which creates:

An AWS EC2 with helm, minikube, docker installed.
A security group with port 22 opened for SSH.


Note: 
    If you don't have a default VPC in the region where you want to create these 
    resource, you should create one before running this code:
    ```bash
    aws ec2 create-default-vpc --region your_region
    ```
    If you already have one default VPC, and want to use it, you can use its 
    `vpc_id`.