package main

import (
    "errors"
    "flag"
    "fmt"
    "github.com/golang-migrate/migrate/v4"
    _ "github.com/golang-migrate/migrate/v4/database/postgres"
    _ "github.com/golang-migrate/migrate/v4/source/file"
    "github.com/joho/godotenv"
    "log"
    "os"
)

func main() {
    // Load environment variables
    err := godotenv.Load()
    if err != nil {
        log.Fatalln("Environment could not be loaded.")
    }

    // Commandline Flags
    up := flag.Bool("up", false, "Apply all up migrations")
    down := flag.Bool("down", false, "Apply all down migrations")
    step := flag.Int("step", 0, "Number of migrations to apply. Use a positive number for up and a negative number for down")

    // Parse flags
    flag.Parse()

    // Get the database URL from environment variables
    dbURL := os.Getenv("DATABASE_URL")
    if dbURL == "" {
        log.Fatal("DATABASE_URL environment variable not set.")
    }

    // Initialize the migrate instance
    m, err := migrate.New("file://internal/db/migrations", dbURL)
    if err != nil {
        log.Fatalf("Failed to initialize migrate instance: %v", err)
    }

    // Run the migrations based on flags
    if *up {
        if err = m.Up(); err != nil && !errors.Is(err, migrate.ErrNoChange) {
            log.Fatalf("Failed to apply up migrations: %v", err)
        }
        fmt.Println("Up migrations applied successfully")
    } else if *down {
        if err = m.Down(); err != nil && !errors.Is(err, migrate.ErrNoChange) {
            log.Fatalf("Failed to apply down migrations: %v", err)
        }
        log.Println("Down migrations applied successfully")
    } else if *step != 0 {
        if *step > 0 {
            if err = m.Steps(*step); err != nil && !errors.Is(err, migrate.ErrNoChange) {
                log.Fatalf("Failed to apply up step migration: %v", err)
            }
            log.Println("Step up migrations applied successfully")
        } else {
            if err = m.Steps(*step); err != nil && !errors.Is(err, migrate.ErrNoChange) {
                log.Fatalf("Failed to apply down step migration: %v", err)
            }
            log.Println("Step down migrations applied successfully")
        }
    } else {
        log.Println("No migration flags provided. Use -up, -down or -step.")
    }

    if srcerr, dberr := m.Close(); srcerr != nil || dberr != nil {
        log.Fatalf("Failed to close migrate instance: %v", err)
    }
}
