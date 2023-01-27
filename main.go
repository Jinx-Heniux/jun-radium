package main

import (
	"database/sql"
	"log"

	"github.com/Jinx-Heniux/jun-radium-go-gin/api"
	db "github.com/Jinx-Heniux/jun-radium-go-gin/db/sqlc"
	_ "github.com/lib/pq"
)

const (
	dbDriver = "postgres"
	// dbSource      = "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable"
	dbSource      = "postgresql://root:secret@localhost:5433/radium?sslmode=disable"
	serverAddress = "0.0.0.0:8080"
)

func main() {
	conn, err := sql.Open(dbDriver, dbSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(serverAddress)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}
}
