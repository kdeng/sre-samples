package handlers

import (
	"fmt"
	"net/http"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/julienschmidt/httprouter"
	"google.golang.org/appengine"
	"google.golang.org/appengine/log"
	"google.golang.org/appengine/taskqueue"
)

// init is default package constructor in this service
func init() {
	router := httprouter.New()

	router.GET("/", Index)
	router.GET("/hello/:name", helloHandler)
	router.GET("/bigquery/import", importHandler)
	router.POST("/worker", worker)
	router.POST("/bigquery", bigqueryJobHandler)
	router.GET("/_ah/:state", stateHandler)
	http.Handle("/", router)

}

// Index is root context handler
func Index(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	ctx := appengine.NewContext(r)
	fmt.Fprint(w, "Welcome!\n")
	log.Debugf(ctx, "Index handler from project '%s'", appengine.AppID(ctx))
	log.Debugf(ctx, "Current Module name : %s", appengine.ModuleName(ctx))
	log.Debugf(ctx, "Current Server Software : %s", appengine.ServerSoftware())

}

// helloHandler handles hello request
func helloHandler(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	ctx := appengine.NewContext(r)
	name := ps.ByName("name")

	for i := 1; i <= 10; i++ {
		t := taskqueue.NewPOSTTask("/worker", map[string][]string{"name": {fmt.Sprintf("%s %d", name, i)}})
		_, err := taskqueue.Add(ctx, t, "queue-red")
		if err != nil {
			log.Errorf(ctx, "Failed to send #%v message", i)
		} else {
			log.Infof(ctx, "Send a #%v task to queue", i)
		}
	}

	// t := taskqueue.NewPOSTTask("/worker", map[string][]string{"name": {name}})
	// _, err := taskqueue.Add(ctx, t, "queue-red")

	// if err == nil {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("OK"))
	// } else {
	// 	http.Error(w, err.Error(), http.StatusInternalServerError)
	// }
}

func importHandler(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	ctx := appengine.NewContext(r)
	currentTime := time.Now()
	t := taskqueue.NewPOSTTask("/bigquery", map[string][]string{"time": {fmt.Sprintf(currentTime.Format("0000-00-00"))}})
	_, err := taskqueue.Add(ctx, t, "queue-blue")
	if err == nil {
		w.WriteHeader(http.StatusCreated)
		w.Write([]byte("Created"))
		log.Infof(ctx, "Created BigQuery import job successfully")
	} else {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func bigqueryJobHandler(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	ctx := appengine.NewContext(r)
	time := r.FormValue("time")
	log.Infof(ctx, "Big Query job receives an import request for data : %s", time)

	projectID := appengine.AppID(ctx)
	log.Infof(ctx, "Current project ID is : %s", projectID)

	client, err := bigquery.NewClient(ctx, projectID)

	if err != nil {
		log.Errorf(ctx, "Failed to build a BigQuery client: %v", err)
	}

	client.

}

func worker(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	ctx := appengine.NewContext(r)
	name := r.FormValue("name")
	currentTime := time.Now()
	log.Infof(ctx, "worker receives: %s", name)
	log.Infof(ctx, "Current timestamp: %v", currentTime)
}

// stateHandler be called to handle status check request from appengine service
func stateHandler(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	ctx := appengine.NewContext(r)
	targetState := ps.ByName("state")

	if targetState == "start" || targetState == "stop" {
		log.Infof(ctx, "Checking the application state - %s", targetState)
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
		return
	}

	http.NotFound(w, r)

}
