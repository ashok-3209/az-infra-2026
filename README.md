# Azure Multi-Tier Infrastructure (az-infra-2026)

This repository contains modular Infrastructure as Code (IaC) written in **Terraform** to deploy a secure, highly-available, 3-tier architecture on **Microsoft Azure**. The codebase supports multiple isolated environment configurations (`dev` and `prod`).

---

## 🏗️ Architecture Overview

The infrastructure provisions a multi-tier landing zone in **Azure Central India** (`centralindia`) consisting of:

```
                          +-----------------------------------+
                          |     Internet / Public Traffic     |
                          +-----------------+-----------------+
                                            |
                    +-----------------------+-----------------------+
                    |                                               |
                    v                                               v
        +-----------------------+                       +-----------------------+
        |   Azure Bastion Host  |                       |  Application Gateway  |
        |  (Secure SSH Access)  |                       |  (Layer 7 Load Balancer)|
        +-----------+-----------+                       +-----------+-----------+
                    |                                               |
                    | Subnet: AzureBastionSubnet                    | Subnet: appgw
  ------------------|-----------------------------------------------|--------------------
                    |                                               v
                    |                                   +-----------------------+
                    |                                   |  Frontend Subnet      |
                    |                                   |  - 2x Ubuntu VMs      |
                    |                                   +-----------+-----------+
                    |                                               |
                    |                                               v
                    |                                   +-----------------------+
                    |                                   | Internal Load Balancer|
                    |                                   | (Layer 4 Load Balancer)|
                    |                                   +-----------+-----------+
                    |                                               |
                    |                                               v
                    |                                   +-----------------------+
                    |                                   |  Backend Subnet       |
                    |                                   |  - 2x Ubuntu VMs      |
                    |                                   +-----------+-----------+
                    |                                               |
                    |                                               v
                    |                                   +-----------------------+
                    |                                   |  Database Subnet      |
                    |                                   |  - 1x Ubuntu VM       |
                    +----------------------------------->  (Internal Network)   |
                                                        +-----------------------+
```

### Components
1. **Public Ingress Layer**:
   - **Azure Application Gateway**: Public-facing Layer 7 load balancer distributing HTTP traffic across Frontend VMs.
   - **Azure Bastion Host**: Managed jumpbox service providing browser-based SSH access without assigning public IPs to VMs.
   - **Public IPs**: Static Standard SKU public IP addresses allocated for Bastion and Application Gateway.

2. **Application & Storage Tier**:
   - **Frontend Tier**: 2x Ubuntu 22.04 LTS VMs receiving web traffic from Application Gateway.
   - **Internal Load Balancer**: Layer 4 internal load balancer distributing traffic from Frontend tier to Backend tier.
   - **Backend Tier**: 2x Ubuntu 22.04 LTS VMs attached to the internal load balancer.
   - **Database Tier**: 1x Ubuntu 22.04 LTS VM isolated within the database subnet.

---

## 📁 Repository Structure

```
az-infra-2026/
├── environment/
│   ├── dev/                  # Development environment root
│   │   ├── main.tf           # Dev environment orchestration & local variables
│   │   ├── outputs.tf        # Dev outputs (IPs, Subnet IDs, VM names)
│   │   ├── provider.tf       # AzureRM provider configuration
│   │   ├── terraform.tfvars  # Dev parameter values & tags
│   │   └── variables.tf      # Dev variable declarations & defaults
│   └── prod/                 # Production environment root
│       ├── main.tf           # Prod environment orchestration & local variables
│       ├── outputs.tf        # Prod outputs
│       ├── provider.tf       # AzureRM provider configuration
│       ├── terraform.tfvars  # Prod parameter values & tags
│       └── variables.tf      # Prod variable declarations & defaults
├── module/                   # Reusable child Terraform modules
│   ├── azure_app_gateway/    # Application Gateway (Standard_v2) module
│   ├── azure_bastion/        # Azure Bastion Host module
│   ├── azure_load_balancer/  # Internal Load Balancer module
│   ├── azure_public_ip/      # Public IP address management module
│   ├── azure_resource_group/ # Azure Resource Group module
│   ├── azure_virtual_machine/# Linux Virtual Machine & NIC provisioner module
│   ├── azure_virtual_network/# Virtual Network (VNet) module
│   └── azure_virtual_subnet/ # Subnet management module
├── main.tf                   # Root stub file
├── variables.tf              # Root stub file
├── outputs.tf                # Root stub file
└── README.md                 # Project documentation
```

---

## ⚙️ Environment Configuration Details

| Parameter / Feature | Development (`dev`) | Production (`prod`) |
| :--- | :--- | :--- |
| **Resource Group** | `iad-az-dev-rg` | `iad-az-prod-rg` |
| **Location** | `centralindia` | `centralindia` |
| **Virtual Network** | `iad-az-dev-vnet` | `iad-az-prod-vnet` |
| **VNet Address CIDR** | `10.0.0.0/16` | `10.1.0.0/16` |
| **App Gateway Subnet** | `10.0.0.0/24` | `10.1.0.0/24` |
| **Frontend Subnet** | `10.0.1.0/24` | `10.1.1.0/24` |
| **Backend Subnet** | `10.0.2.0/24` | `10.1.2.0/24` |
| **Database Subnet** | `10.0.3.0/24` | `10.1.3.0/24` |
| **Bastion Subnet** | `10.0.4.0/26` | `10.1.4.0/26` |
| **VM Sizing** | `Standard_D2s_v3` | `Standard_B2s` |
| **VM OS Image** | Ubuntu 22.04 LTS | Ubuntu 22.04 LTS |
| **VM Instance Count** | 5 VMs (2 Frontend, 2 Backend, 1 Database) | 5 VMs (2 Frontend, 2 Backend, 1 Database) |

---

## 📦 Modular Components

Each child module in `module/` handles a single resource responsibility:

- **[azure_resource_group](file:///c:/az-infra-2026/module/azure_resource_group)**: Creates resource groups based on a map input.
- **[azure_virtual_network](file:///c:/az-infra-2026/module/azure_virtual_network)**: Provisions Virtual Networks and address spaces.
- **[azure_virtual_subnet](file:///c:/az-infra-2026/module/azure_virtual_subnet)**: Manages subnet allocation within VNets.
- **[azure_public_ip](file:///c:/az-infra-2026/module/azure_public_ip)**: Creates static Standard SKU Public IPs for Gateway & Bastion.
- **[azure_virtual_machine](file:///c:/az-infra-2026/module/azure_virtual_machine)**: Configures NICs, Linux VMs, OS disks, and credentials.
- **[azure_bastion](file:///c:/az-infra-2026/module/azure_bastion)**: Deploys Azure Bastion host service connected to `AzureBastionSubnet`.
- **[azure_app_gateway](file:///c:/az-infra-2026/module/azure_app_gateway)**: Deploys Application Gateway with HTTP listener, routing rules, and frontend pool targets.
- **[azure_load_balancer](file:///c:/az-infra-2026/module/azure_load_balancer)**: Configures internal load balancer with health probes, rules, and backend pool associations for Backend VMs.

---

## 🚀 Getting Started & Deployment

### Prerequisites
- [Terraform](https://www.terraform.io/downloads) >= 1.0.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed & authenticated
- Azure Subscription with Contributor/Owner rights

### Deployment Steps

1. **Authenticate to Azure**:
   ```bash
   az login
   az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
   ```

2. **Navigate to the target environment**:
   - For **Development**:
     ```bash
     cd environment/dev
     ```
   - For **Production**:
     ```bash
     cd environment/prod
     ```

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Review execution plan**:
   ```bash
   terraform plan -var-file="terraform.tfvars"
   ```

5. **Apply configuration**:
   ```bash
   terraform apply -var-file="terraform.tfvars"
   ```

6. **Tear down resources (optional)**:
   ```bash
   terraform destroy -var-file="terraform.tfvars"
   ```

---

## 📤 Output Values

After a successful deployment, Terraform exposes the following outputs:

- `resource_group_names`: Name(s) of created Azure Resource Group(s).
- `virtual_network_names`: Name(s) of provisioned Virtual Network(s).
- `subnet_ids`: Map of subnet names to their Azure Resource IDs.
- `vm_private_ip_addresses`: Private IP addresses allocated to each of the 5 VMs.
- `vm_names`: List of created virtual machine names.
- `bastion_public_ip`: Public IP allocated for Azure Bastion.
- `application_gateway_public_ip`: Public IP allocated for Application Gateway ingress.
- `backend_load_balancer_private_ip`: Private IP assigned to the internal backend load balancer.

---

## 🔐 Security Considerations

- **No Public IPs on VMs**: Virtual Machines exist entirely on private subnets. External access is strictly controlled via Application Gateway for web traffic and Azure Bastion for management SSH sessions.
- **Sensitive Variables**: Administrator credentials (`vm_admin_password`) are marked as `sensitive` in Terraform. Avoid committing plain-text secrets into version control for production environments. Use Azure Key Vault or environment variables (`TF_VAR_vm_admin_password`) in production pipelines.