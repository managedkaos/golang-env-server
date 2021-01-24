package main

import (
	"github.com/pyroscope-io/pyroscope/pkg/agent/profiler"
	"net/http"
	"os"
	"strings"
)

func indexHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("<title>Environment Variables</title>"))
	w.Write([]byte("<h1>Environment Variables, NOW WITH SSL!! :D</h1>"))
	w.Write([]byte("<table>"))
	w.Write([]byte("<tr><th style='text-align:left'>KEY</th><th style='text-align:left'>VALUE</th></tr>"))
	for _, element := range os.Environ() {
		variable := strings.Split(element, "=")
		w.Write([]byte("<tr><td style='text-align:left'>" + variable[0] + "</td><td style='text-align:left'>" + variable[1] + "</td></tr>"))
	}
	w.Write([]byte("</table>"))

}

func main() {
	profiler.Start(profiler.Config{
		ApplicationName: "backend.purchases",
		ServerAddress:   "http://localhost:4040",
	})

	port := "8080"
	mux := http.NewServeMux()

	mux.HandleFunc("/", indexHandler)
	http.ListenAndServe(":"+port, mux)
}
