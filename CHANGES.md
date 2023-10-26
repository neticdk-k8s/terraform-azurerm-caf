# This file is to see deviants done by Netic

## Remove breaking bug caused by unnecessary var.resource_location variable
- Date: 22/09/2023
- File: modules/diagnostics/module.tf
- Who: MFR
- PR: It's missing, sorry

### Reason:
It didn't make sense to add var.resource_location, because you already have to add the ID of the storage account.

It caused a major bug in our landingzone module, because the resource_location had to be hardcoded, which doesn't make sense since we have storage accounts in different regions.

## Fix max_surge variable for nodepools
- Date: 26/10/2023
- File(s): modules/compute/aks/aks.tf
- Who: MFR
- PR:

### Reason:
I was getting tired of configuring in my local .terraform folder everytime when I had to upgrade a cluster. I had to hardcode max_surge to 3 every time

Then I also had to add max_surge in main.tf file.

But now we can just add the max_surge in the main.tf file without fixing it locally in .terraform first

