package main

import (
	"database/sql"
	"log"

	"github.com/Jinx-Heniux/jun-radium-go-gin/api"
	db "github.com/Jinx-Heniux/jun-radium-go-gin/db/sqlc"
	"github.com/Jinx-Heniux/jun-radium-go-gin/util"
	_ "github.com/lib/pq"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	store := db.NewStore(conn)
	server, err := api.NewServer(config, store)
	if err != nil {
		log.Fatal("cannot create server:", err)
	}

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}
}
