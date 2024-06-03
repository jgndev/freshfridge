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
    user_id UUID REFERENCES Users(id),
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

-- Users Table
CREATE TABLE Users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email_address VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- SmsRecipients Table
CREATE TABLE SmsRecipients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES Users(id),
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- EmailRecipients Table
CREATE TABLE EmailRecipients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES Users(id),
    email_address VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
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
    (uuid_generate_v4(), 'Fresh Produce', 5, 7, 10),
    (uuid_generate_v4(), 'Fresh Beef', 5, 7, 10),
    (uuid_generate_v4(), 'Fresh Pork', 5, 7, 10),
    (uuid_generate_v4(), 'Fresh Chicken', 2, 4, 6),
    (uuid_generate_v4(), 'Fresh Seafood', 2, 3, 5),
    (uuid_generate_v4(), 'Frozen Produce', 120, 180, 270),
    (uuid_generate_v4(), 'Frozen Beef', 120, 180, 270),
    (uuid_generate_v4(), 'Frozen Pork', 120, 180, 270),
    (uuid_generate_v4(), 'Frozen Chicken', 120, 180, 270),
    (uuid_generate_v4(), 'Frozen Fish', 90, 120, 180),
    (uuid_generate_v4(), 'Cooked Food', 3, 5, 7);

-- Initial insertion for the Users table
INSERT INTO Users (id, username, password, email_address) VALUES
    (uuid_generate_v4(), 'freshfridge', '$2b$12$mN6s.kY/npH/Uf7F2Wr4rONkCV5UoXHMcp3r3HarPAx0KYr48y8Zq', 'user@domain.com');