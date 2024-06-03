-- Enable uuid-ossp extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- FoodCategory Table
CREATE TABLE FoodCategory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    days_use_by INT NOT NULL,
    days_warning INT NOT NULL,
    days_expired INT NOT NULL
);

-- FoodItem Table
CREATE TABLE FoodItem (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    category_id UUID REFERENCES FoodCategory(id),
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_use_by TIMESTAMP,
    date_warning TIMESTAMP,
    date_expired TIMESTAMP,
    notification_use_by_sent BOOLEAN DEFAULT FALSE,
    notification_expires_sent BOOLEAN DEFAULT FALSE,
    notification_trash_sent BOOLEAN DEFAULT FALSE
);

-- Trigger Functions
CREATE OR REPLACE FUNCTION set_dates()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.date_use_by := NEW.date_added + INTERVAL '1 day' * (SELECT days_use_by FROM FoodCategory WHERE id = NEW.category_id);
    NEW.date_warning := NEW.date_added + INTERVAL '1 day' * (SELECT days_warning FROM FoodCategory WHERE id = NEW.category_id);
    NEW.date_expired := NEW.date_added + INTERVAL '1 day' * (SELECT days_expired FROM FoodCategory WHERE id = NEW.category_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create Trigger
CREATE TRIGGER before_insert_fooditem
BEFORE INSERT ON FoodItem
FOR EACH ROW
EXECUTE FUNCTION set_dates();

-- Initial insertion for the FoodCategory table
INSERT INTO FoodCategory (id, name, days_use_by, days_warning, days_expired) VALUES
    (uuid_generate_v4(), 'Produce', 5, 7, 10),
    (uuid_generate_v4(), 'Fresh Meat', 5, 7, 10),
    (uuid_generate_v4(), 'Cooked Food', 5, 7, 10),
    (uuid_generate_v4(), 'Frozen Food', 60, 90, 120);