# TIC-TAC-TOE between 2 AI agents (OPENAI & ANTHROPIC)

This Project is Implemented as part of course work for CLCM3505 - Introduction to Designing Cloud Development and Deployment Environments

## Project Structure

```
  | - README.md
  | - application-code |
                       | - Dockerfile
                       | - requirements.txt
                       | - src |
                               | - tic-tac-toe-2-AI.py

  | - terraform-code   |
                       | - main.tf
                       | - outputs.tf
                       | - modules |
                                   | - EC2 |
                                           | - main.tf
                                           | - outputs.tf
                                           | - variables.tf
                                           | - installer.sh
                                   | - VPC |
                                           | - main.tf
                                           | - outputs.tf
                                           | - variables.tf
```

### Terraform Structure

- Terraform code is divided into modules of EC2 and VPC.
- This Configuration creates a VPC with 2 Public Subnets with an internet gateway and then creates and EC2 instance in one of those public subnets.
- The newly created EC2 takes user-data as input from `installer.sh` file which installs Docker and Minikube.
- The overall output of the Terraform module is the `public IP` of the EC2 instance.
