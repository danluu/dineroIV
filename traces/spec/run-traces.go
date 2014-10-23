package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

// Run all *.sh files under path.
func VisitFile(fp string, fi os.FileInfo, err error) error {
	if err != nil {
		fmt.Println(err) 
		return nil       
	}
	if !!fi.IsDir() {
		return nil 
	}

	matched, err := filepath.Match("*.sh", fi.Name())
	if err != nil {
		fmt.Println(err) 
		return err       // fatal.
	}
	if matched {
		fmt.Println(fp)
		// Set up Command object to execute from directory.
		// dinero with -trname only works when it's run
		// from the directory with the data files.
		ssDir := filepath.Dir(fp)
		ssName := filepath.Base(fp)
		cmd := exec.Command(fp)
		cmd.Dir = ssDir
		cmd.Path = ssName

		// Output is redirected to a file so this is expected
		// to be empty if there isn't a bug.
		out, err := cmd.Output()
		if err != nil {
			fmt.Println(err) 
			return err       // fatal.
		}
		fmt.Println(out)
	}
	return nil
}

func main() {
	filepath.Walk(".", VisitFile)
}
