package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformAwsNlbEIPs(t *testing.T) {
	t.Parallel()

	nlbName := fmt.Sprintf("nlb-%s", strings.ToLower(random.UniqueId()))
	logsBucket := fmt.Sprintf("terratest-aws-nlb-logs-%s", strings.ToLower(random.UniqueId()))
	environment := "test"
	awsRegion := "us-west-2"
	vpcAzs := aws.GetAvailabilityZones(t, awsRegion)[:3]

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/using_eips/",
		Vars: map[string]interface{}{
			"environment": environment,
			"nlb_name":    nlbName,
			"logs_bucket": logsBucket,
			"vpc_azs":     vpcAzs,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Empty logs_bucket before terraform destroy
	aws.EmptyS3Bucket(t, awsRegion, logsBucket)
}

func TestTerraformAwsNlbIPv4Addrs(t *testing.T) {
	t.Parallel()

	nlbName := fmt.Sprintf("nlb-%s", strings.ToLower(random.UniqueId()))
	logsBucket := fmt.Sprintf("terratest-aws-nlb-logs-%s", strings.ToLower(random.UniqueId()))
	environment := "test"
	awsRegion := "us-west-2"
	vpcAzs := aws.GetAvailabilityZones(t, awsRegion)[:3]

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/using_ipv4_addrs/",
		Vars: map[string]interface{}{
			"environment": environment,
			"nlb_name":    nlbName,
			"logs_bucket": logsBucket,
			"vpc_azs":     vpcAzs,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Empty logs_bucket before terraform destroy
	aws.EmptyS3Bucket(t, awsRegion, logsBucket)
}
