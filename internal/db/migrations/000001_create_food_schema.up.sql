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
    category_id UUID REFERENCES FoodCategory (id),
    image_url VARCHAR(255) NULL
);

-- FoodInventory Table
CREATE TABLE FoodInventory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES Users(id),
    food_item_id UUID REFERENCES FoodItem(id),
    quantity INT DEFAULT 1,
    date_added TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_use_by TIMESTAMP,
    date_warning TIMESTAMP,
    date_expired TIMESTAMP,
    notification_use_by_sent BOOLEAN DEFAULT FALSE,
    notification_warning_sent BOOLEAN DEFAULT FALSE,
    notification_expired_sent BOOLEAN DEFAULT FALSE
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
CREATE OR REPLACE FUNCTION set_inventory_dates()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.date_use_by := NEW.date_added + INTERVAL '1 day' * (
        SELECT days_use_by FROM FoodCategory WHERE id = (
            SELECT category_id FROM FoodItem WHERE id = NEW.food_item_id
        )
    );
    NEW.date_warning := NEW.date_added + INTERVAL '1 day' * (
        SELECT days_warning FROM FoodCategory WHERE id = (
            SELECT category_id FROM FoodItem WHERE id = NEW.food_item_id
        )
    );
    NEW.date_expired := NEW.date_added + INTERVAL '1 day' * (
        SELECT days_expired FROM FoodCategory WHERE id = (
            SELECT category_id FROM FoodItem WHERE id = NEW.food_item_id
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create Trigger
CREATE TRIGGER before_insert_food_inventory
    BEFORE INSERT ON FoodInventory
    FOR EACH ROW
EXECUTE FUNCTION set_inventory_dates();


-- Initial insertion for the FoodCategory table
INSERT INTO FoodCategory (id, name, days_use_by, days_warning, days_expired) VALUES
    (uuid_generate_v4(), 'Fresh Produce', 5, 7, 10),
    (uuid_generate_v4(), 'Fresh Beef', 5, 7, 10),
    (uuid_generate_v4(), 'Fresh Pork', 5, 7, 10),
    (uuid_generate_v4(), 'Fresh Poultry', 2, 4, 6),
    (uuid_generate_v4(), 'Fresh Seafood', 2, 3, 5),
    (uuid_generate_v4(), 'Frozen Produce', 120, 180, 270),
    (uuid_generate_v4(), 'Frozen Beef', 120, 180, 270),
    (uuid_generate_v4(), 'Frozen Pork', 120, 180, 270),
    (uuid_generate_v4(), 'Frozen Poultry', 120, 180, 270),
    (uuid_generate_v4(), 'Frozen Seafood', 90, 120, 180),
    (uuid_generate_v4(), 'Cooked Food', 3, 4, 7);

INSERT INTO FoodItem (id, name, category_id, image_url) VALUES
    (uuid_generate_v4(), 'Ground Beef', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Ground Beef', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Ribeye Steak', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Ribeye Steak', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'T-Bone Steak', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'T-Bone Steak', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Porterhouse Steak', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Porterhouse Steak', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'New York Strip', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'New York Strip', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Sirloin', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Sirloin', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Tri-tip', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Tri-tip', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Filet Mignon', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Filet Mignon', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Flank Steak', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Flank Steak', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Skirt Steak', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Skirt Steak', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Chuck Roast', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Chuck Roast', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Rump Roast', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Rump Roast', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Brisket', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Brisket', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Prime Rib', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Prime Rib', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Short Ribs', (SELECT id FROM FoodCategory WHERE name = 'Fresh Beef'), NULL),
    (uuid_generate_v4(), 'Short Ribs', (SELECT id FROM FoodCategory WHERE name = 'Frozen Beef'), NULL),
    (uuid_generate_v4(), 'Pork Chops', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork'), NULL),
    (uuid_generate_v4(), 'Pork Chops', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork'), NULL),
    (uuid_generate_v4(), 'Pork Loin', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork'), NULL),
    (uuid_generate_v4(), 'Pork Loin', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork'), NULL),
    (uuid_generate_v4(), 'Pork Shoulder', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork'), NULL),
    (uuid_generate_v4(), 'Pork Shoulder', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork'), NULL),
    (uuid_generate_v4(), 'Ham', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork'), NULL),
    (uuid_generate_v4(), 'Ham', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork'), NULL),
    (uuid_generate_v4(), 'Bacon', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork'), NULL),
    (uuid_generate_v4(), 'Bacon', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork'), NULL),
    (uuid_generate_v4(), 'Spare Ribs', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork'), NULL),
    (uuid_generate_v4(), 'Spare Ribs', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork'), NULL),
    (uuid_generate_v4(), 'Baby Back Ribs', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork'), NULL),
    (uuid_generate_v4(), 'Baby Back Ribs', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork'), NULL),
    (uuid_generate_v4(), 'Pork Sausage', (SELECT id FROM FoodCategory WHERE name = 'Fresh Pork'), NULL),
    (uuid_generate_v4(), 'Pork Sausage', (SELECT id FROM FoodCategory WHERE name = 'Frozen Pork'), NULL),
    (uuid_generate_v4(), 'Whole Chicken', (SELECT id FROM FoodCategory WHERE name = 'Fresh Poultry'), NULL),
    (uuid_generate_v4(), 'Whole Chicken', (SELECT id FROM FoodCategory WHERE name = 'Frozen Poultry'), NULL),
    (uuid_generate_v4(), 'Chicken Thighs', (SELECT id FROM FoodCategory WHERE name = 'Fresh Poultry'), NULL),
    (uuid_generate_v4(), 'Chicken Thighs', (SELECT id FROM FoodCategory WHERE name = 'Frozen Poultry'), NULL),
    (uuid_generate_v4(), 'Chicken Breast', (SELECT id FROM FoodCategory WHERE name = 'Fresh Poultry'), NULL),
    (uuid_generate_v4(), 'Chicken Breast', (SELECT id FROM FoodCategory WHERE name = 'Frozen Poultry'), NULL),
    (uuid_generate_v4(), 'Chicken Drumsticks', (SELECT id FROM FoodCategory WHERE name = 'Fresh Poultry'), NULL),
    (uuid_generate_v4(), 'Chicken Drumsticks', (SELECT id FROM FoodCategory WHERE name = 'Frozen Poultry'), NULL),
    (uuid_generate_v4(), 'Chicken Quarters', (SELECT id FROM FoodCategory WHERE name = 'Fresh Poultry'), NULL),
    (uuid_generate_v4(), 'Chicken Quarters', (SELECT id FROM FoodCategory WHERE name = 'Frozen Poultry'), NULL),
    (uuid_generate_v4(), 'Whole Turkey', (SELECT id FROM FoodCategory WHERE name = 'Fresh Poultry'), NULL),
    (uuid_generate_v4(), 'Whole Turkey', (SELECT id FROM FoodCategory WHERE name = 'Frozen Poultry'), NULL),
    (uuid_generate_v4(), 'Turkey Breast', (SELECT id FROM FoodCategory WHERE name = 'Fresh Poultry'), NULL),
    (uuid_generate_v4(), 'Turkey Breast', (SELECT id FROM FoodCategory WHERE name = 'Frozen Poultry'), NULL),
    (uuid_generate_v4(), 'Turkey Drumsticks', (SELECT id FROM FoodCategory WHERE name = 'Fresh Poultry'), NULL),
    (uuid_generate_v4(), 'Turkey Drumsticks', (SELECT id FROM FoodCategory WHERE name = 'Frozen Poultry'), NULL),
    (uuid_generate_v4(), 'Salmon', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Salmon', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Trout', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Trout', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Tuna', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Tuna', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Cod', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Cod', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Tilapia', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Tilapia', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Halibut', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Halibut', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Catfish', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Catfish', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Sea Bass', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Sea Bass', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Bass', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Bass', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Crappie', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Crappie', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Walleye', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Walleye', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Perch', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Perch', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Sunfish', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Sunfish', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Crawfish', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Crawfish', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Shrimp', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Shrimp', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Lobster', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Lobster', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Crab', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Crab', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Oysters', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Oysters', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Clams', (SELECT id FROM FoodCategory WHERE name = 'Fresh Seafood'), NULL),
    (uuid_generate_v4(), 'Clams', (SELECT id FROM FoodCategory WHERE name = 'Frozen Seafood'), NULL),
    (uuid_generate_v4(), 'Produce', (SELECT id FROM FoodCategory WHERE name = 'Fresh Produce'), NULL),
    (uuid_generate_v4(), 'Produce', (SELECT id FROM FoodCategory WHERE name = 'Frozen Produce'), NULL),
    (uuid_generate_v4(), 'Cooked Food', (SELECT id FROM FoodCategory WHERE name = 'Fresh Cooked Food'), NULL),
    (uuid_generate_v4(), 'Cooked Food', (SELECT id FROM FoodCategory WHERE name = 'Frozen Cooked Food'), NULL);

-- Initial insertion for the Users table
INSERT INTO Users (id, username, password, email_address) VALUES
    -- username: freshdemo, password: freshdemo, email: freshdemo@freshfridge.com
    (uuid_generate_v4(), 'freshdemo', '$2b$12$QKzZeq2spJiFO/VC.O0rTubXfYq9OfmnAumWFRCPi19.d7/mKDe6C', 'freshdemo@freshfridge.app'),
    -- username: freshfridge, password: supafresh, email: freshfridge@freshfridge.com
    (uuid_generate_v4(), 'freshfridge', '$2b$12$mN6s.kY/npH/Uf7F2Wr4rONkCV5UoXHMcp3r3HarPAx0KYr48y8Zq', 'freshfridge@freshfridge.app');
