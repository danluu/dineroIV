package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

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
		ssDir := filepath.Dir(fp)
		ssName := filepath.Base(fp)
		// cmd := exec.Cmd {
		// 	Path: ssName,
		// 	Dir: ssDir,
		// }
		cmd := exec.Command(fp)
		cmd.Dir = ssDir
		cmd.Path = ssName
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
