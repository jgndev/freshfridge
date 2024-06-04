-- Drop the FoodInventory trigger
DROP TRIGGER IF EXISTS before_insert_food_inventory ON FoodInventory;

-- Drop the trigger function
DROP FUNCTION IF EXISTS set_inventory_dates();

-- Drop the tables
DROP TABLE IF EXISTS SmsRecipients;
DROP TABLE IF EXISTS EmailRecipients;
DROP TABLE IF EXISTS FoodInventory;
DROP TABLE IF EXISTS FoodItem;
DROP TABLE IF EXISTS FoodCategory;
DROP TABLE IF EXISTS Users;

-- Drop the uuid-ossp extension
DROP EXTENSION IF EXISTS "uuid-ossp";
