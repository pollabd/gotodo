include .env

APP_NAME=gotodo
CMD_PATH=./cmd/api
BIN_DIR=./bin
MIGRATION_DIR=./migrations

.PHONY: help run dev build start clean test fmt vet lint \
migrate-up migrate-down migrate-force migrate-version \
migrate-create print-db

help:
	@echo "======================================="
	@echo "            AVAILABLE COMMANDS"
	@echo "======================================="
	@echo ""
	@echo "Application:"
	@echo "  make run"
	@echo "  make dev"
	@echo "  make build"
	@echo "  make start"
	@echo "  make clean"
	@echo ""
	@echo "Code Quality:"
	@echo "  make test"
	@echo "  make fmt"
	@echo "  make vet"
	@echo "  make lint"
	@echo ""
	@echo "Database:"
	@echo "  make migrate-up"
	@echo "  make migrate-down"
	@echo "  make migrate-force v=1"
	@echo "  make migrate-version"
	@echo "  make migrate-create name=create_users_table"
	@echo ""
	@echo "Utilities:"
	@echo "  make print-db"

run:
	go run $(CMD_PATH)/main.go

dev:
	air

build:
	@if not exist $(BIN_DIR) mkdir $(BIN_DIR)
	go build -ldflags="-s -w" -o $(BIN_DIR)/$(APP_NAME).exe $(CMD_PATH)/main.go

start:
	$(BIN_DIR)/$(APP_NAME).exe

clean:
	@if exist $(BIN_DIR) rmdir /s /q $(BIN_DIR)

test:
	go test -v ./...

fmt:
	go fmt ./...

vet:
	go vet ./...

lint:
	golangci-lint run

migrate-up:
	migrate -path $(MIGRATION_DIR) -database "$(DATABASE_URL)" up

migrate-down:
	migrate -path $(MIGRATION_DIR) -database "$(DATABASE_URL)" down 1

migrate-force:
	migrate -path $(MIGRATION_DIR) -database "$(DATABASE_URL)" force $(v)

migrate-version:
	migrate -path $(MIGRATION_DIR) -database "$(DATABASE_URL)" version

migrate-create:
	migrate create -ext sql -dir $(MIGRATION_DIR) -seq $(name)

print-db:
	@echo $(DATABASE_URL)