-- Create the crowdfunding database.
CREATE DATABASE crowdfunding_db
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
    
-- Create the tables for the crowdfunding database.
CREATE TABLE "campaign" (
    "cf_id" int   NOT NULL,
    "contact_id" int   NOT NULL,
    "company_name" VARCHAR(100)   NOT NULL,
    "description" VARCHAR(100)   NOT NULL,
    "goal" float   NOT NULL,
    "pledged" float   NOT NULL,
    "outcome" VARCHAR(10)   NOT NULL,
    "backers_count" int   NOT NULL,
    "country" VARCHAR(2)   NOT NULL,
    "currency" VARCHAR(3)   NOT NULL,
    "launched_date" date   NOT NULL,
    "end_date" date   NOT NULL,
    "category_id" VARCHAR(4)   NOT NULL,
    "subcategory_id" VARCHAR(8)   NOT NULL,
    CONSTRAINT "pk_campaign" PRIMARY KEY (
        "cf_id"
     )
);

CREATE TABLE "contacts" (
    "contact_id" int   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "email" VARCHAR(60)   NOT NULL,
    CONSTRAINT "pk_contacts" PRIMARY KEY (
        "contact_id"
     )
);

CREATE TABLE "category" (
    "category_id" VARCHAR(4)   NOT NULL,
    "category" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_category" PRIMARY KEY (
        "category_id"
     )
);

CREATE TABLE "subcategory" (
    "subcategory_id" VARCHAR(8)   NOT NULL,
    "subcategory" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_subcategory" PRIMARY KEY (
        "subcategory_id"
     )
);

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_contact_id" FOREIGN KEY("contact_id")
REFERENCES "contacts" ("contact_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_category_id" FOREIGN KEY("category_id")
REFERENCES "category" ("category_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_subcategory_id" FOREIGN KEY("subcategory_id")
REFERENCES "subcategory" ("subcategory_id");

-- load the data into the tables from the csv files in the following order:
-- subcategory.csv, category.csv, contacts.csv, campaign.csv

-- Verify the table creation by running a SELECT statement for each table.

SELECT * FROM campaign;
SELECT * FROM contacts;
SELECT * FROM category;
SELECT * FROM subcategory;

-- SELECT statement to return the number of campaigns that were successful, failed, or are still live.
SELECT outcome, 
COUNT(outcome) 
FROM campaign 
GROUP BY outcome;

-- SELECT statement to return the number of campaigns that were successful, failed, or are still live, 
-- sorted by the number of campaigns in each outcome category.
SELECT outcome, 
COUNT(outcome) 
FROM campaign 
GROUP BY outcome 
ORDER BY COUNT(outcome) DESC;

-- SELECT statement to return the number of campaigns that were successful, failed, or are still live, 
-- sorted by the number of campaigns in each outcome category, and the percentage of total campaigns for each outcome category.
SELECT outcome, 
COUNT(outcome), 
ROUND(COUNT(outcome) * 100.0 / (SELECT COUNT(*) FROM campaign), 2) 
AS percentage FROM campaign 
GROUP BY outcome 
ORDER BY COUNT(outcome) DESC;

-- list email addresses for contacts who have backed successful campaigns.
SELECT DISTINCT contacts.email
FROM contacts
INNER JOIN campaign
ON contacts.contact_id = campaign.contact_id
WHERE campaign.outcome = 'successful';

-- return the number of sccessful campaigns based on category.
SELECT category.category,
COUNT(category.category)
FROM category
INNER JOIN campaign
ON category.category_id = campaign.category_id
WHERE campaign.outcome = 'successful'
GROUP BY category.category
ORDER BY COUNT(category.category) DESC;

-- return the number of sccessful campaigns based on subcategory.
SELECT subcategory.subcategory,
COUNT(subcategory.subcategory)
FROM subcategory
INNER JOIN campaign
ON subcategory.subcategory_id = campaign.subcategory_id
WHERE campaign.outcome = 'successful'
GROUP BY subcategory.subcategory
ORDER BY COUNT(subcategory.subcategory) DESC;
