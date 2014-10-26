// Take a bunch of dineroIV outputs and produce a csv with cumulative cache hit rates.
// Ignores l1i since l1i is relatively uninteresting for this data set.

package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"strconv"
)

var (
	cacheType = regexp.MustCompile(`^l(\d)-(\w)cache`)
	demandFetches = regexp.MustCompile(`^ Demand Fetches\s+(\d+)`)
	demandMisses = regexp.MustCompile(`^ Demand Misses\s+(\d+)`)
)

// TODO: refactor next two functions into a single function.
func pathToArgsSandy(fp string) string {
	// fp is something like "output/301.apsi.f.out"
	// basePath is like "301.apsi.f.out"
	// want ["301.aspi", "f"] or "301.aspi,f,"
	basePath := filepath.Base(fp)
	parts := strings.Split(basePath, ".")
	return parts[0] + "." +  parts[1] + "," + parts[2] + ","
}

func pathToArgs(fp string) string {
	// fp is something like "output/301.apsi.f.17.out"
	// basePath is like "301.apsi.f.17.out"
	// want ["301.aspi", "f", "17"] or "301.aspi,f,17"
	basePath := filepath.Base(fp)
	parts := strings.Split(basePath, ".")
	return parts[0] + "." +  parts[1] + "," + parts[2] + "," + parts[3] + ","
}


func parseDineroOutput(fp string, fi os.FileInfo, err error) error {
	if err != nil {
		fmt.Println(err) 
		return nil       
	}
	if !!fi.IsDir() {
		// This shouldn't happen with the current setup.
		return nil 
	}

	// fmt.Println(fp)
	file, err := os.Open(fp)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	
	scanner := bufio.NewScanner(file)
	cacheLevel := ""
	totalFetches := -1
	levelMisses := -1
	hitRate := 0.0

	// File contains something like:
	// l1-dcache
	// ...
	//  Demand Fetches 1000
	// ...
	// Demand Misses 30
	// l2-ucache
	// ...
	// scanner reads through file to save interesting parts.
	for scanner.Scan() {
		cacheMatch := cacheType.FindStringSubmatch(scanner.Text())
		if cacheMatch != nil && cacheMatch[2] != "i" {
			cacheLevel = cacheMatch[1]
		}

		fetchMatch := demandFetches.FindStringSubmatch(scanner.Text())
		if fetchMatch != nil && cacheLevel == "1" {
			totalFetches, err = strconv.Atoi(fetchMatch[1])
			if err != nil {
				log.Fatal(err)
			}
		}

		missMatch := demandMisses.FindStringSubmatch(scanner.Text())
		if missMatch != nil && cacheLevel != "" {
			levelMisses, err = strconv.Atoi(missMatch[1])
			if err != nil {
				log.Fatal(err)
			}
			hitRate = float64(levelMisses)/float64(totalFetches)
			typeString := pathToArgs(fp)
			csvString := typeString + cacheLevel + "," + strconv.FormatFloat(hitRate, 'f', -1, 64)
			// fmt.Println(cacheLevel, totalFetches, levelMisses, hitRate)
			fmt.Println(csvString)
		}
		// fmt.Println(scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return nil
}

func main() {
	filepath.Walk("./output",parseDineroOutput)
}
