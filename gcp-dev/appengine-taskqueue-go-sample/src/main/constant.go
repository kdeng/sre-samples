package main

import "golang.org/x/oauth2"

// JWTTokenURL is Google's OAuth 2.0 token URL to use with the JWT flow.
const JWTTokenURL = "https://accounts.google.com/o/oauth2/token"

// Endpoint is Google's OAuth 2.0 endpoint.
var Endpoint = oauth2.Endpoint{
	AuthURL:  "https://accounts.google.com/o/oauth2/auth",
	TokenURL: "https://accounts.google.com/o/oauth2/token",
}

// JSON key file types.
const (
	ServiceAccountKey  = "service_account"
	UserCredentialsKey = "authorized_user"
)
