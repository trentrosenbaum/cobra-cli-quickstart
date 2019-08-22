package cmd

import "fmt"

type Version struct {
	Tag string
	Commit string
	Branch string
}

func (v Version) String() string {
	return fmt.Sprintf("Tag: %s, Commit: %s, Branch: %s", v.Tag, v.Commit, v.Branch)
}
