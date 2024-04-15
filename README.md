# TIC-TAC-TOE between 2 AI agents (OPENAI & ANTHROPIC)

This Project is Implemented as part of course work for CLCM3505 - Introduction to Designing Cloud Development and Deployment Environments

## Project Structure

```
 ├── README.md
 ├── create-docker-image.sh         # Instruction to create Docker image
 ├── application-code/
 │   ├── Dockerfile
 │   ├── requirements.txt
 │   └── src/
 │       └── tic-tac-toe-2-AI.py    # Python Code
 ├── terraform-code/
     ├── main.tf
     ├── outputs.tf
     └── modules/
         ├── EC2/
         │   ├── main.tf
         │   ├── outputs.tf
         │   ├── variables.tf
         │   └── installer.sh
         │   └── pod.yaml
         │   └── Project-Application-Server.pem
         └── VPC/
             ├── main.tf
             ├── outputs.tf
             └── variables.tf
```

### Requirements

- AWS EC2 instance Creation Access (AWS CLI configured)
- Ensure `Project-Application-Server.pem` is created as key-pair in your AWS Account.
- Place your `Project-Application-Server.pem` in this location `terraform-code/modules/EC2`.
- Refer to `application-code/.env.sample` and get your OPENAI & Anthropic API keys.

### Terraform Structure

- Terraform code is divided into modules of EC2 and VPC.
- This Configuration creates a VPC with 2 Public Subnets with an internet gateway and then creates and EC2 instance in one of those public subnets.
- The newly created EC2 takes user-data as input from `installer.sh` file which installs Docker and Minikube.
- Then wait for 120 seconds to ensure all the background operations to setup the k8s cluster are complete.
- Then `pod.yaml` from EC2 module to EC2 instance `/tmp/pod.yaml` location.
- Then run the `kubectl` commands to run the pod and get the logs of pod.
- The overall output of the Terraform module is the `public IP` of the EC2 instance.

### Infrastructure in AWS

![project-vpc](https://github.com/shaik-rehan-uddin/tic-tac-toc-AI/assets/144375108/84aab23a-5c35-49c4-85b8-ebef59f50972)

### Demo

[![](https://markdown-videos-api.jorgenkh.no/youtube/QZsWBWRKUaI)](https://youtu.be/QZsWBWRKUaI)
