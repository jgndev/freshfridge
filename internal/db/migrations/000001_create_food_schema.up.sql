-- Enable uuid-ossp extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Table
CREATE TABLE Users (
   id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
   username VARCHAR(255) NOT NULL UNIQUE,
   password VARCHAR(255) NOT NULL,
   email_address VARCHAR(255) NOT NULL UNIQUE,
   created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

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
    quantity INT DEFAULT 1 NOT NULL,
    image_url VARCHAR(255) NULL,
    category_id UUID REFERENCES FoodCategory(id),
    date_added TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_use_by TIMESTAMP,
    date_warning TIMESTAMP,
    date_expired TIMESTAMP,
    notification_use_by_sent BOOLEAN DEFAULT FALSE,
    notification_expires_sent BOOLEAN DEFAULT FALSE,
    notification_trash_sent BOOLEAN DEFAULT FALSE
);

-- SmsRecipients Table
CREATE TABLE SmsRecipients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES Users(id),
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- EmailRecipients Table
CREATE TABLE EmailRecipients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES Users(id),
    email_address VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
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
    (uuid_generate_v4(), 'Cooked Food', 3, 4, 7);

-- Initial insertion for the Users table
INSERT INTO Users (id, username, password, email_address) VALUES
    (uuid_generate_v4(), 'freshdemo', '$2b$12$QKzZeq2spJiFO/VC.O0rTubXfYq9OfmnAumWFRCPi19.d7/mKDe6C', 'user@domain.com'),
    (uuid_generate_v4(), 'freshfridge', '$2b$12$mN6s.kY/npH/Uf7F2Wr4rONkCV5UoXHMcp3r3HarPAx0KYr48y8Zq', 'user@domain.com');

-- Initial insertion for common grocery list items in the FoodItem table
INSERT INTO FoodItem(id, user_id, name, category_id) VALUES
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Ground Beef', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Ground Beef', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Rib Eye', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Rib Eye', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Sirloin', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Sirloin', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'New York Strip', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'New York Strip', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Flank', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Flank', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Skirt Steak', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Skirt Steak', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Brisket', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Brisket', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Roast', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Roast', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Chuck', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Chuck', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Tri-tip', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Tri-tip', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Round Roast', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Round Roast', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Pork Chops', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Pork Chops', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Spareribs', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Spareribs', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Baby Back Ribs', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Baby Back Ribs', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Pork Loin', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Pork Loin', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Pork Tenderloin', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Pork Tenderloin', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Pork Shoulder', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Pork Shoulder', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Pork Belly', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Pork Belly', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Bacon', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Bacon', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Ham', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Ham', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Chicken Breasts', (SELECT id FROM FoodCategory WHERE name = 'Fresh Chicken')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Chicken Breasts', (SELECT id FROM FoodCategory WHERE name = 'Frozen Chicken')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Chicken Thighs', (SELECT id FROM FoodCategory WHERE name = 'Fresh Chicken')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Chicken Thighs', (SELECT id FROM FoodCategory WHERE name = 'Frozen Chicken')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Salmon', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Salmon', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Bass', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Bass', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Catfish', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Crappie', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Crappie', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Shrimp', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Lettuce', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Tomatoes', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Cucumbers', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Bell Peppers', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Carrots', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Broccoli', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Asparagus', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Zucchini', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Brussels Sprouts', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Green Beans', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce')),
    (uuid_generate_v4(), (SELECT id FROM Users WHERE username = 'freshfridge'), 'Peas', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce'));
