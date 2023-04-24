package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"regexp"
	"strconv"
)

type RestResponse struct {
	Status     bool
	Output     string
	TotalPass  string
	TotalError string
	Total      string
}

func run_table(w http.ResponseWriter, r *http.Request) {
	status := false
	table := r.URL.Query().Get("table")
	log.Printf("Table %s: received a request", table)
	cmd := exec.CommandContext(r.Context(), "/bin/sh", "scripts/run_table.sh", "-table-name="+table)
	cmd.Stderr = os.Stderr
	out, err := cmd.Output()
	if err != nil {
		w.WriteHeader(500)
	}

	re := regexp.MustCompile(`Completed\ssuccessfully`)

	if re.MatchString(string(out)) {
		// Mensagem de sucesso não encontrada, então o status é false
		status = true
	}

	// Resposta em json
	restResponse := RestResponse{
		Status: status,
		Output: string(out),
	}
	json.NewEncoder(w).Encode(restResponse)
}

func run_table_full(w http.ResponseWriter, r *http.Request) {
	status := false
	table := r.URL.Query().Get("table")
	log.Printf("Table %s: received a request", table)
	cmd := exec.CommandContext(r.Context(), "/bin/sh", "scripts/run_table_full.sh", "-table-name="+table)
	cmd.Stderr = os.Stderr
	out, err := cmd.Output()
	if err != nil {
		w.WriteHeader(500)
	}

	re := regexp.MustCompile(`Completed\ssuccessfully`)

	if re.MatchString(string(out)) {
		// Mensagem de sucesso não encontrada, então o status é false
		status = true
	}

	// Resposta em json
	restResponse := RestResponse{
		Status: status,
		Output: string(out),
	}
	json.NewEncoder(w).Encode(restResponse)
}

func test_table(w http.ResponseWriter, r *http.Request) {
	status := false
	table := r.URL.Query().Get("table")
	log.Printf("Table %s: received a request", table)
	cmd := exec.CommandContext(r.Context(), "/bin/sh", "scripts/test_table.sh", "-table-name="+table)
	cmd.Stderr = os.Stderr
	out, err := cmd.Output()

	if err != nil {
		// w.WriteHeader(500)
		status = false
	}

	// Parse do consolidado final
	re := regexp.MustCompile(`Done\.\sPASS=(?P<pass>\d+)\sWARN=(?P<warn>\d+)\sERROR=(?P<error>\d+)\sSKIP=(?P<skip>\d+)\sTOTAL=(?P<total>\d+)`)
	matches := re.FindStringSubmatch(string(out))
	totalError := matches[re.SubexpIndex("error")]

	if intTotalError, err := strconv.Atoi(totalError); err == nil && intTotalError == 0 {
		// Não conseguimos converter para int ou tem erro, então o status é false
		status = true
	}

	// Resposta em json
	restResponse := RestResponse{
		Status:     status,
		Output:     string(out),
		TotalPass:  matches[re.SubexpIndex("pass")],
		TotalError: totalError,
		Total:      matches[re.SubexpIndex("total")],
	}
	json.NewEncoder(w).Encode(restResponse)
}

func main() {
	log.Print("helloworld: starting server...")
	http.HandleFunc("/table", run_table)
	http.HandleFunc("/table/full", run_table_full)
	http.HandleFunc("/test", test_table)
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Printf("helloworld: listening on %s", port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), nil))
}
