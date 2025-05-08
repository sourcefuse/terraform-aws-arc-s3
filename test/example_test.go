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
	rootDir := getExamplesRootDir(t)

	// If using "example", just run the test directly in that directory
	if filepath.Base(rootDir) == "example" {
		tfOutputFile := filepath.Join(rootDir, "outputs.tf")

		content, err := ioutil.ReadFile(tfOutputFile)
		if err != nil {
			t.Fatalf("outputs.tf not found in %s: %v", rootDir, err)
		}

		outputNames := extractOutputNames(string(content))

		t.Run("example", func(t *testing.T) {
			runTerraformAndValidateOutputs(t, rootDir, outputNames)
		})
		return
	}

	// If using "examples", loop through subdirectories
	subDirs := getSubDirs(t, rootDir)

	for _, dir := range subDirs {
		examplePath := filepath.Join(rootDir, dir.Name())
		tfOutputFile := filepath.Join(examplePath, "outputs.tf")

		content, err := ioutil.ReadFile(tfOutputFile)
		if err != nil {
			t.Logf("Skipping %s: no outputs.tf found (%v)", examplePath, err)
			continue
		}

		outputNames := extractOutputNames(string(content))

		t.Run(dir.Name(), func(t *testing.T) {
			runTerraformAndValidateOutputs(t, examplePath, outputNames)
		})
	}
}


func getExamplesRootDir(t *testing.T) string {
	if dirExists("../example") {
		return "../example"
	}
	if dirExists("../examples") {
		return "../examples"
	}
	t.Fatal("Neither 'example' nor 'examples' directory found")
	return "" // Not reachable
}

func getSubDirs(t *testing.T, rootDir string) []os.DirEntry {
	entries, err := os.ReadDir(rootDir)
	if err != nil {
		t.Fatalf("Failed to read %s directory: %v", rootDir, err)
	}
	var subDirs []os.DirEntry
	for _, entry := range entries {
		if entry.IsDir() {
			subDirs = append(subDirs, entry)
		}
	}
	return subDirs
}

func runTerraformAndValidateOutputs(t *testing.T, dir string, outputNames []string) {
	terraformOptions := &terraform.Options{
		TerraformDir: dir,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	for _, name := range outputNames {
		val := terraform.Output(t, terraformOptions, name)
		assert.NotEmpty(t, val, "Output '%s' in %s should not be empty", name, dir)
	}
}

func dirExists(path string) bool {
	info, err := os.Stat(path)
	return err == nil && info.IsDir()
}

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
