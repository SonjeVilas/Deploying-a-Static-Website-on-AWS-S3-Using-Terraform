# **Deploying a Static Website on AWS S3 Using Terraform**  

## 📌 **Project Overview**  
This project demonstrates how to **deploy a static website** on **AWS S3** using **Terraform**. Instead of manually setting up infrastructure, we use Terraform to automate the process, ensuring a consistent and scalable deployment.  

## 🛠 **Technologies Used**  
- **Terraform** – For Infrastructure as Code (IaC)  
- **AWS S3** – For hosting the static website  
- **AWS CLI** – For managing AWS resources  
- **IAM (Identity and Access Management)** – For secure access control  

## 🎯 **Project Objectives**  
✔️ Automate the creation of an **S3 bucket** for website hosting  
✔️ Enable **static website hosting** on AWS S3  
✔️ Upload website files (HTML, CSS, JS) to S3  
✔️ Configure **IAM roles and policies** for security  
✔️ Make the website publicly accessible  
✔️ Test and access the website via the S3 URL  

## 🔧 **Setup and Deployment Steps**  

### **Step 1: Install Required Tools**  
Ensure you have the following installed on your system:  
✅ **Terraform** → Download from [Terraform Official Site](https://developer.hashicorp.com/terraform/downloads)  
✅ **AWS CLI** → Install from [AWS CLI Official Site](https://aws.amazon.com/cli/)  
✅ **An AWS Account** with required permissions  

### **Step 2: Configure AWS CLI**  
Run the following command to connect Terraform with AWS:  
```sh
aws configure
```
Enter your **Access Key, Secret Key, Region, and Output Format** (JSON recommended).  

### **Step 3: Create Terraform Configuration File (main.tf)**  
Define the required AWS resources, including S3 bucket and website configuration.  

Example Terraform script:  
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.90.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "your-unique-bucket-name"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
```

### **Step 4: Initialize and Apply Terraform**  
Run the following commands to deploy your infrastructure:  
```sh
terraform init
terraform apply -auto-approve
```
This will create an **S3 bucket** and configure it for **static website hosting**.  

### **Step 5: Upload Website Files**  
After deployment, upload your website files using:  
```sh
aws s3 cp index.html s3://your-unique-bucket-name/ --acl public-read
```

### **Step 6: Test the Website**  
Once the setup is complete, open the **S3 Website URL** (found in AWS Console) in your browser to see your website live.  

## 📌 **Conclusion**  
This project successfully demonstrates **how to automate and deploy a static website on AWS S3 using Terraform**. It eliminates manual setup, making the process more **efficient, scalable, and cost-effective**. 🚀  

## 📝 **License**  
This project is licensed under the **MIT License**. You are free to use, modify, and distribute it, provided proper credit is given.  
