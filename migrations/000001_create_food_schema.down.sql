-- Drop the FoodItem trigger if the table and trigger exist
DO $$
    BEGIN
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'FoodItem') THEN
            EXECUTE 'DROP TRIGGER IF EXISTS before_insert_fooditem ON FoodItem';
        END IF;
    END $$;

-- Drop the trigger function if it exists
DROP FUNCTION IF EXISTS set_dates() CASCADE;

-- Drop the tables if they exist
DROP TABLE IF EXISTS SmsRecipients CASCADE;
DROP TABLE IF EXISTS EmailRecipients CASCADE;
DROP TABLE IF EXISTS FoodItem CASCADE;
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS FoodCategory CASCADE;

-- Drop the uuid-ossp extension if it exists
DROP EXTENSION IF EXISTS "uuid-ossp";
