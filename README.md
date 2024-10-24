# Terraform Azure VM, Storage, and Networking

## Overview
This repository contains Terraform code to deploy an Azure Virtual Machine (VM) along with the required networking, a storage account, and a remote backend setup for storing the Terraform state file securely in Azure Blob Storage.

## Features
- Creates a resource group.
- Provisions a storage account and container for Terraform state management.
- Deploys a virtual network (VNet) and a subnet.
- Configures a network security group (NSG) with rules for SSH, HTTP, and HTTPS access.
- Creates a Linux-based VM with a public IP and network interface.
- Stores the Terraform state file in a remote Azure Blob storage container.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) 
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- An Azure account with permissions to create resources

## Usage

### Step 1: Clone the Repository
```bash
git clone https://github.com/yourusername/terraform-azure-vm-storage-networking.git
cd terraform-azure-vm-backend-storage
