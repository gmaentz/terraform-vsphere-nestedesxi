package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// An example of how to test the Terraform module using Terratest.
func TestTerraformExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",
		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"vcenter_user": "administrator@vsphere.local",
			"vcenter_password":"CHANGEME",
			"vcenter_server": "192.168.169.35",
			"esxi_root_password": "CHANGEME",
			"datacenter_name": "Datacenter",
			"datastore_name": "raid10_gen7",
			"resource_pool": "192.168.169.34/Resources",
			"vm_template_name":"esxi67u3_template",
			"network_name":"VM Network",
			"source_esxi_host": "192.168.169.34",
			"num_esxi_hosts": "1",
			"nameprefix": "esxi_mod_test",
			"offset": 1,
			"hostnetmask": "255.255.255.0",
			"hostgateway": "192.168.169.3",
			"hostdnsservers": "8.8.8.8",
			"hostdomainname": "vsphere.local",
			"useDHCP": "true",
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"var": "value",
		},
	}

	// website::tag::4::At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2::Run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	//RoleName := terraform.Output(t, terraformOptions, "role_name")

}
