package test

import (
	"strings"
	"testing"
)

func TestJWTConfigFromJSON(t *testing.T) {

	conf, err := JWTConfigFromJSON(jwtJSONKey, "scope1", "scope2")
	if err != nil {
		t.Fatal(err)
	}
	if got, want := conf.Email, "a@a.com"; got != want {
		t.Errorf("Email = %q, want %q", got, want)
	}
	if got, want := string(conf.PrivateKey), "super secret key"; got != want {
		t.Errorf("PrivateKey = %q, want %q", got, want)
	}
	if got, want := conf.PrivateKeyID, "1234"; got != want {
		t.Errorf("PrivateKeyID = %q, want %q", got, want)
	}
	if got, want := strings.Join(conf.Scopes, ","), "scope1,scope2"; got != want {
		t.Errorf("Scopes = %q; want %q", got, want)
	}
	if got, want := conf.TokenURL, "https://accounts.google.com/o/gophers/token"; got != want {
		t.Errorf("TokenURL = %q; want %q", got, want)
	}

}
