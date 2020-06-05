# Deploying Scenario1

## Prequiste Check

Mac OS, Linux or WSL shell is required to work seamlessly

Verify the following tools are installed:

* Azure CLI 2.2.0+ ([download](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest))
* Visual Studio Code (optional) ([download](https://code.visualstudio.com/download))
* Terraform 0.12.24+

## Clone the repo and customize variables

Clone this repository to your local workstation:

```bash
git clone https://github.com/retaildevcrews/secure-aks-infra
```

Change into the `scenario1` directory under the `src` folder.

```bash
cd secure-aks-infra/src/scenario1
```

This directory will have 4 main files:

* `main.tf` : This file is the main run sequence of what will be deployed by Terraform.
* `variables.tf`: This file contains all of the variable type definitions that can be passed into `main.tf` to cusotmize the deployment. This file should be left as is.
* `terraform.tfvars` : This file contains the values for the `variables.tf` file that can be edited that are then picked up at deployment time. This is the file you wil edit to customize the deployemnt
* `output.tf` : This file will specifiy any values that are to be sent to the output of the command that can be used as reference later.

The following values can be used for a `terraform.tfvars`

```hcl
CLUSTER_ID          = "egresstst"
COST_CENTER         = "RC8765"
DEPLOY_TYPE         = "AKS_WCNP"
ENVIRONMENT         = "PROD"
NOTIFY_LIST         = "mngrs@microsoft.com"
OWNER_INFO          = "tstgrp"
PLATFORM            = "azk8s"
SPONSOR_INFO        = "BizDev"
REGION              = "centralus"
HUB_VNET_ADDR_SPACE = ["192.168.0.0/24"]
HUB_SUBNET_NAMES = {
  AzureFirewallSubnet = "192.168.0.0/26"
}
DOCKER_REGISTRY = "ejvlab.azurecr.io"
AKS_VNET_NAME   = "aks-vnet-centralus-001"
AKS_VNET_CIDR   = ["172.20.0.0/16"]
AKS_SUBNET_NAMES = {
  aks-subnet = "172.20.0.0/21"
}
ADMIN_USER = "ejvuser"
K8S_VER    = "1.16.7"
# AAD_CLIENTAPP_ID="<APPID_FOR_AAD_CLIENT_SP>"
# AAD_SERVERAPP_ID="<APPID_FOR_AAD_SERVER_SP>"
# AAD_SERVERAPP_SECRET="<APPID_SECRET_FOR_AAD_SP>"
AUTH_IP_RANGES     = "100.100.0.0/14,123.56.21.1/32,40.23.43.0/12"
POD_CIDR           = "172.18.0.0/16"
SERVICE_CIDR       = "172.16.0.0/16"
DNS_IP             = "172.16.0.10"
DOCKER_CIDR        = "172.17.0.1/16"
DEF_POOL_NODE_SIZE = "Standard_D2s_v3"
DEF_POOL_OS_DISK   = "128"
DEF_POOL_NAME      = "istiopool"
DEF_POOL_MIN       = "1"
DEF_POOL_MAX       = "5"
ENABLE_CA_DEF_POOL = "true"
NODEPOOL_DEFS = {
  nodepool1 = {
    name             = "workerpool"
    node_count       = "3"
    enable_autoscale = true
    min_count        = "3"
    max_count        = "5"
    vm_size          = "Standard_D2s_v3"
    node_disk_size   = "128"
  },
  nodepool2 = {
    name             = "coreinfpool"
    node_count       = "3"
    enable_autoscale = true
    min_count        = "3"
    max_count        = "5"
    vm_size          = "Standard_D2s_v3"
    node_disk_size   = "128"
  }
}
```

## Prepare your credentials

The template requires 2 accounts in Azure to deploy properly.
The first account is a Service Principal that Terraform will use as the account it runs as. This account needs to have owner rights in the subscription to be able to do role assignments properly.
The second account is a Service Principal that will be used by AKS to call the Azure API when it needs to create or update certain resources such as Load Balancers. This account does not have to have any roles assigned as this is taken care of my the template.

You can then set the environmen variables your system will need to deploy. Setting this as environment variables instead of defining them in the `terraform.tfvars` file prevenst secrets from being written to disk.

```bash
export TF_VAR_TFUSER_CLIENT_ID="<APP_ID_OF_TF_SEVICE_PRINCIPAL>"
export TF_VAR_TFUSER_CLIENT_SECRET="CLIENT_SECRET_OF_TF_SERVICE_PRINCIPAL"
export TF_VAR_SUB_ID="<SUBSCRIPTION_ID>"
export TF_VAR_TENANT_ID="<TENANT_ID>"
export TF_VAR_K8S_SP_CLIENT_ID="<APP_ID_OF_AKS_SEVICE_PRINCIPAL>"
export TF_VAR_K8S_SP_CLIENT_SECRET="CLIENT_SECRET_OF_AKS_SERVICE_PRINCIPAL"
export TF_VAR_AKS_SSH_ADMIN_KEY="<SSH PUBLIC KEY to be used for AKS Nodes. start with ssh-rsa ...>"
```

## Initialize your Terraform Directory

Ensure you are in the `<repo>/src/scenario1` directory.
Run the `terraform init` command to setup the proper providers and module dependencies. Once that is complete you can run a `terraform plan` to see what will be built or `terraform apply` to deploy the infrastructure.

```bash
terraform init
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "dns" (hashicorp/dns) 2.2.0...
- Downloading plugin for provider "azurerm" (hashicorp/azurerm) 2.2.0...
- Downloading plugin for provider "null" (hashicorp/null) 2.1.2...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.azurerm: version = "~> 2.2"
* provider.dns: version = "~> 2.2"
* provider.null: version = "~> 2.1"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # azurerm_resource_group.aksrg will be created
  + resource "azurerm_resource_group" "aksrg" {
      + id       = (known after apply)
      + location = "centralus"
      + name     = "rg-egresstst"
      + tags     = {
          + "costcenter"           = "RC8765"
          + "deploymenttype"       = "AKS_WCNP"
          + "environmentinfo"      = "PROD"
          + "notificationdistlist" = "mngrs@microsoft.com"
          + "ownerinfo"            = "tstgrp"
          + "platform"             = "azk8s"
          + "sponsorinfo"          = "BizDev"
        }
    }

 ... shortened for brevity

  # module.vnet-peer.null_resource.dependency_setter will be created
  + resource "null_resource" "dependency_setter" {
      + id = (known after apply)
    }

Plan: 38 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```