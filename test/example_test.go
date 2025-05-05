package test

import (
	"io/ioutil"
	"regexp"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAllTerraformOutputsNotEmpty(t *testing.T) {
	t.Parallel()

	tfDir := "../examples"
	tfOutputFile := tfDir + "/output.tf"

	// Step 1: Parse output.tf for output variable names
	content, err := ioutil.ReadFile(tfOutputFile)
	if err != nil {
		t.Fatalf("Failed to read %s: %v", tfOutputFile, err)
	}

	outputNames := extractOutputNames(string(content))

	// Step 2: Setup Terraform options
	terraformOptions := &terraform.Options{
		TerraformDir: tfDir,
	}

	// Step 3: Iterate through each output and assert it's not empty
	for _, name := range outputNames {
		t.Run(name, func(t *testing.T) {
			val := terraform.Output(t, terraformOptions, name)
			assert.NotEmpty(t, val, "Output '%s' should not be empty", name)
		})
	}
}

// Helper to extract output names using regex
func extractOutputNames(tfContent string) []string {
	re := regexp.MustCompile(`(?m)^output\s+"([^"]+)"`)
	matches := re.FindAllStringSubmatch(tfContent, -1)

	var outputNames []string
	for _, match := range matches {
		if len(match) > 1 {
			outputNames = append(outputNames, strings.TrimSpace(match[1]))
		}
	}
	return outputNames
}