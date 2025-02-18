#!/bin/bash
set -e  # Exit on error

LOGFILE="setup.log"
exec > >(tee -a "$LOGFILE") 2>&1  # Log output to file

echo "Starting automated setup..."

# Function to check if a command exists
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Terraform silently
install_terraform() {
    if check_command terraform; then
        echo "Terraform is already installed."
    else
        echo "Installing Terraform..."
        wget -q https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip -O terraform.zip
        unzip -o terraform.zip -d /usr/local/bin/
        rm -f terraform.zip
        terraform --version && echo "Terraform installed successfully." || { echo "Terraform installation failed!"; exit 1; }
    fi
}

# Function to install Ansible silently
install_ansible() {
    if check_command ansible; then
        echo "Ansible is already installed."
    else
        echo "Installing Ansible..."
        sudo apt update
        sudo apt install -y ansible
        ansible --version && echo "Ansible installed successfully." || { echo "Ansible installation failed!"; exit 1; }
    fi
}

# Function to authenticate to Azure automatically (for VM or CI/CD)
authenticate_azure() {
    echo "Authenticating to Azure..."
    
    # If running on an Azure VM with Managed Identity
    if az login --identity >/dev/null 2>&1; then
        echo "Successfully authenticated using Managed Identity."
    else
        echo "Trying interactive login..."
        az login --use-device-code >/dev/null 2>&1 || { echo "Azure login failed! Ensure you have access."; exit 1; }
    fi
}

# Function to check if user has Admin (Owner) access in Azure
check_azure_admin() {
    echo "          Checking Azure Subscription Admin access..."

    ROLE=$(az role assignment list --assignee $(az ad signed-in-user show --query id -o tsv) --query "[?roleDefinitionName=='Owner'].roleDefinitionName" -o tsv)

    if [[ "$ROLE" == "Owner" ]]; then
        echo "User has Azure Admin (Owner) privileges."
    else
        echo "User is NOT an Azure Admin. Continuing, but some actions may fail."
    fi                                          
}

# Run all functions automatically
install_terraform
install_ansible
authenticate_azure
check_azure_admin

echo "Package installation setup completed successfully!"
