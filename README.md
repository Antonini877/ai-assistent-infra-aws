
# Terraform AWS Infrastructure Automation

This project automates the deployment and management of AWS infrastructure using Terraform, with GitHub Actions workflows to handle changes via pull requests and apply them automatically once merged into the `master` branch.

## Problem Statement

People with visual impairments often face significant challenges when performing daily tasks related to food preparation, such as identifying ingredients and preparing meals independently. While there are technological solutions available, there is still a gap in accessible tools that help these individuals maintain a healthy and autonomous lifestyle.

## Solution Overview

The goal of this project is to provide a system that leverages computer vision and AI to help users identify ingredients using a mobile device, suggest recipes based on available ingredients, and provide accessible interaction through voice commands and auditory feedback.

### Objectives:

1. **Ingredient Recognition**: Using AI and image recognition to identify food ingredients from captured images.
2. **Recipe Suggestions**: Based on identified ingredients and user preferences, the system suggests recipes.
3. **Accessible Interaction**: The interface supports voice commands and auditory feedback for ease of use by visually impaired users.

### AWS Services Used:

- **Amazon Rekognition**: To analyze and identify ingredients from images.
- **AWS Lambda**: For serverless processing of images.
- **Amazon API Gateway**: To handle communication between the mobile app and AWS services.
- **Amazon S3**: To store images securely.
- **Amazon DynamoDB**: To store user preferences, ingredients, and recipes.

## GitHub Actions Workflow

This project uses GitHub Actions to automate the application of Terraform configurations.

### 2. **Apply Workflow on Merge** (`.github/workflows/deploy-infra.yml`)

When changes are merged into the `master` branch, this workflow automatically applies the Terraform changes by running `terraform apply`, deploying or updating the AWS infrastructure as defined in the Terraform files.

## Setup Instructions

### Prerequisites

1. **Terraform**: Ensure you have [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
2. **AWS Account**: You'll need an AWS account with appropriate permissions for the services used (Rekognition, Lambda, API Gateway, S3, DynamoDB).
3. **GitHub Secrets**: In your GitHub repository, configure the following secrets to allow the workflows to access your AWS account:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

### Files Structure

```bash
.
├── .github/
│   └── workflows/
│       ├── deploy-infra.yml     # Runs Terraform plan on push to master
│
├── main.tf                      # Terraform configuration for AWS infrastructure
├── variables.tf                 # Variables used in the Terraform configuration
├── outputs.tf                   # Outputs generated by Terraform (e.g., API endpoints, resource IDs)
├── README.md                    # Project documentation
```

### How to Use

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Antonini877/ai-assistent-infra-aws
   cd your-repo-name
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Create a development branch**:
   ```bash
   git checkout -b dev
   ```

4. **Make your Terraform changes**. For example, modify `main.tf` to define AWS resources like Lambda functions, API Gateway, and DynamoDB tables.

5. **Test your changes locally**:
   ```bash
   terraform plan
   ```

6. **Push your changes to the `dev` branch**:
   ```bash
   git add .
   git commit -m "Add new AWS resources"
   git push origin dev
   ```

7. **Create a pull request**:
   - Go to your GitHub repository and create a pull request from `dev` to `master`.
   - The `terraform plan` will run automatically on the PR, showing the changes.

8. **Merge the pull request** once you're satisfied with the plan. The workflow will automatically apply the changes to your AWS infrastructure.

## Workflow Details

### Terraform Apply on Merge

Once the pull request is merged, the `deploy-infra.yml` workflow will:

- Checkout the repository.
- Initialize Terraform.
- Run `terraform apply -auto-approve` to automatically apply the infrastructure changes.




## AWS Cost Estimate

Based on the current configuration, the estimated monthly cost is **$7.39**, with the following breakdown:

- Amazon Rekognition: 0.05 USD/month
- API Gateway: 1.00 USD/month
- S3 Storage: 2.59 USD/month
- DynamoDB: 3.75 USD/month

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
