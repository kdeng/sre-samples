package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"

	"golang.org/x/net/context"
	"golang.org/x/oauth2/google"
	"golang.org/x/oauth2/jwt"
)

var ExpectedBigQueryScope = "https://www.googleapis.com/auth/bigquery"

// JWTConfigFromJSON uses a Google Developers service account JSON key file to read
// the credentials that authorize and authenticate the requests.
// Create a service account on "Credentials" for your project at
// https://console.developers.google.com to download a JSON key file.
func JWTConfigFromJSON(jsonKey []byte, scope ...string) (*jwt.Config, error) {
	var f CredentialsFile
	if err := json.Unmarshal(jsonKey, &f); err != nil {
		return nil, err
	}
	if f.Type != ServiceAccountKey {
		return nil, fmt.Errorf("google: read JWT from JSON credentials: 'type' field is %q (expected %q)", f.Type, ServiceAccountKey)
	}
	scope = append([]string(nil), scope...) // copy
	return f.jwtConfig(scope), nil
}

func ReadCredentialsFromJSON(jsonFilePath string, expectScopes ...string) {
	ctx := context.Background()
	data, err := ioutil.ReadFile(jsonFilePath)
	if err != nil {
		log.Fatal(err)
	}

	creds, err := google.CredentialsFromJSON(ctx, data, expectScopes)
	if err != nil {
		log.Fatal(err)
	}
	log.Fatalf("Get Credentials: %v", creds)
	return creds, err
}

func main() {
	getCredentialsFromJSON()

}
