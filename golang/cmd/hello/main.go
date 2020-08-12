/*
package main

// #include <stdio.h>
// #include <stdlib.h>
//
// static void myprint(char* s) {
//   printf("%s\n", s);
// }
import "C"
import "unsafe"

func main() {
    cs := C.CString("Hello CGO")
    C.myprint(cs)
    C.free(unsafe.Pointer(cs))
}
*/

package main

import (
	"fmt"
	"os"

	"github.com/yicm/BazelMixedLanguage/cmd/hello/cli"
)

func main() {
	if err := cli.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
