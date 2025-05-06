package test

import (
	"io/ioutil"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAllExampleModulesOutputsNotEmpty(t *testing.T) {
	// Remove this line to avoid parallel execution of the main test
	// t.Parallel()

	rootDir := "../examples"

	subDirs, err := os.ReadDir(rootDir)
	if err != nil {
			t.Fatalf("Failed to read examples directory: %v", err)
	}

	for _, entry := range subDirs {
			if !entry.IsDir() {
					continue
			}

			examplePath := filepath.Join(rootDir, entry.Name())
			tfOutputFile := filepath.Join(examplePath, "outputs.tf")

			content, err := ioutil.ReadFile(tfOutputFile)
			if err != nil {
					t.Logf("Skipping %s: no outputs.tf found (%v)", examplePath, err)
					continue
			}

			outputNames := extractOutputNames(string(content))

			// This subtest will now run sequentially
			t.Run(entry.Name(), func(t *testing.T) {
					// Do NOT call t.Parallel() here

					terraformOptions := &terraform.Options{
							TerraformDir: examplePath,
					}

					// Init & Apply
					defer terraform.Destroy(t, terraformOptions)
					terraform.InitAndApply(t, terraformOptions)

					// Validate outputs
					for _, name := range outputNames {
							val := terraform.Output(t, terraformOptions, name)
							assert.NotEmpty(t, val, "Output '%s' in %s should not be empty", name, examplePath)
					}
			})
	}
}

// Extracts output variable names using regex
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