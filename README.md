[![Maintained by River Point Technology](https://img.shields.io/badge/maintained%20by-River%20Point%20Technology-navy.svg)](http://www.riverpointtechnology.com)

# VMware Nested ESXi Module

This repo contains a set of modules for deploying a [VMware Nested ESXi](https://www.vmware.com/products/esxi-and-esx.html) cluster on the
[VMware](https://www.vmware.com/) hypervisor, ESXi using [Terraform](https://www.terraform.io/).

Nested ESXi is nested virtualization which allows you to run a hypervisor “within” another hypervisor as a virtual instance. This module deploys VMware's ESXi hypervisor nested within the VMWare hypervisor.

This Module uses [Nested ESXi Virtual Appliances](https://www.virtuallyghetto.com/nested-virtualization/nested-esxi-virtual-appliance) as a deployment artifact which are maintained and curated by [William Lam](https://twitter.com/lamw). 

![Nested ESXi architecture](https://voipalooza.files.wordpress.com/2015/01/nested-esxi-lab.jpg)


## How do you use this Module?

This repo has the following structure :

* **test**: Automated tests for the modules and examples.
* **Scripts**: Contains the 'Enable-VmVappProperties.ps1' script which enables vApp properties for a Nested ESXi VM to be user configurable
* **root folder** : Contains the Terraform code to deploy and appropriately customize Nested ESXi VMs to an existing vSphere deployment

Prerequisites/steps to prepare VM Template:

* **Deploy desired Nested ESXi OVF in vSphere**: Deploy an *uncustomized* VM from one of William Lam's Nested [ESXi OVF templates](https://www.virtuallyghetto.com/nested-virtualization/nested-esxi-virtual-appliance), either by manually importing/deploying to a new VM or deploying from William Lam's [Content Library](https://download3.vmware.com/software/vmw-tools/lib.json) items in your existing vSphere environment.
* **Install VMware PowerCLI**: On a system with connectivity to your vSphere environment, open PowerShell (as administrator), download and install VMware PowerCLI:

        Install-Module -Name VMware.PowerCLI

* **Connect to vCenter server, execute script**: From your PowerShell session, connect to your vCenter server:

        Connect-VIServer

    Provide server name/address and credentials to vCenter when prompted.  Next, execute the *Enable-VmVappProperties.ps1* and provide the name of the newly created Nested ESXi VM in your vSphere environment.  This will enable the vApp properties for the VM.

    *Note, this must be a VM and ***not*** a template at this stage.*

        [---Example---]
        
        .\Enable-VmVappProperties.ps1
        Supply values for the following parameters:
        Name[0]: esxi65u3_template_test
        Name[1]:

* **Convert VM to Template** (optional): Back in the vCenter GUI, convert the Nested ESXi VM into a VM template.  You can now reference this VM/template name (value for the `vm_template_name` variable) when executing the Terraform code.

## What's a Module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such
as a database or server cluster. Each Module is created primarily using [Terraform](https://www.terraform.io/),
includes automated tests, examples, and documentation, and is maintained both by the open source community and
companies that provide commercial support.

Instead of having to figure out the details of how to run a piece of infrastructure from scratch, you can reuse
existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself,
you can leverage the work of the Module community and maintainers, and pick up infrastructure improvements through
a version number bump. Use Modules.

## Who maintains this Module?

This Module is maintained by [River Point Technology](http://www.riverpointtechnology.com/). If you're looking for help or commercial
support, send an email to [info@riverpointtechnology.com](mailto:info@riverpointtechnology.com?Subject=ESXi%20Module).
River Point Technology can help with:

* Setup, customization, and support for this Module.
* Modules for other types of infrastructure, such as vSphere, NSX-T, AWS, Azure, GCP and continuous integration.
* Consulting & Training on VMware, AWS, Terraform, Vault and DevOps.

## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release,
along with the changelog, in the [Releases Page](../../releases). 

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR,
MINOR, and PATCH versions on each release to indicate any incompatibilities.

## Terraform Compatiblity

## Great New Feature Introduced

## License

This code is released under the MIT License. Please see [LICENSE](https://github.com/rptcloud/terraform-vsphere-nestedesxi/blob/master/LICENSE.txt) for more details.

Copyright &copy; 2020 River Point Technology