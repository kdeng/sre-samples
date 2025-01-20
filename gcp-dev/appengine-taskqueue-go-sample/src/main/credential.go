package main

import (
	"context"
	"errors"
	"fmt"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/jwt"
)

// CredentialsFile is the unmarshalled representation of a credentials file.
type CredentialsFile struct {
	Type string `json:"type"` // serviceAccountKey or userCredentialsKey

	// Service Account fields
	ClientEmail  string `json:"client_email"`
	PrivateKeyID string `json:"private_key_id"`
	PrivateKey   string `json:"private_key"`
	TokenURL     string `json:"token_uri"`
	ProjectID    string `json:"project_id"`

	// User Credential fields
	// (These typically come from gcloud auth.)
	ClientSecret string `json:"client_secret"`
	ClientID     string `json:"client_id"`
	RefreshToken string `json:"refresh_token"`
}

func (f *CredentialsFile) jwtConfig(scopes []string) *jwt.Config {
	cfg := &jwt.Config{
		Email:        f.ClientEmail,
		PrivateKey:   []byte(f.PrivateKey),
		PrivateKeyID: f.PrivateKeyID,
		Scopes:       scopes,
		TokenURL:     f.TokenURL,
	}
	if cfg.TokenURL == "" {
		cfg.TokenURL = JWTTokenURL
	}
	return cfg
}

func (f *CredentialsFile) tokenSource(ctx context.Context, scopes []string) (oauth2.TokenSource, error) {
	switch f.Type {
	case ServiceAccountKey:
		cfg := f.jwtConfig(scopes)
		return cfg.TokenSource(ctx), nil
	case UserCredentialsKey:
		cfg := &oauth2.Config{
			ClientID:     f.ClientID,
			ClientSecret: f.ClientSecret,
			Scopes:       scopes,
			Endpoint:     Endpoint,
		}
		tok := &oauth2.Token{RefreshToken: f.RefreshToken}
		return cfg.TokenSource(ctx, tok), nil
	case "":
		return nil, errors.New("missing 'type' field in credentials")
	default:
		return nil, fmt.Errorf("unknown credential type: %q", f.Type)
	}
}
