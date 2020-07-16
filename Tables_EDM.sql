-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/Ocd1w8
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS regions CASCADE;
DROP TABLE IF EXISTS sales_reps CASCADE;
DROP TABLE IF EXISTS web_events CASCADE;


CREATE TABLE "accounts" (
    "id" INTEGER   NOT NULL,
    "name" VARCHAR   NOT NULL,
    "website" VARCHAR   NOT NULL,
    "lat" NUMERIC   NOT NULL,
    "long" NUMERIC   NOT NULL,
    "primary_poc" VARCHAR   NOT NULL,
    "sales_rep_id" INTEGER   NOT NULL,
    CONSTRAINT "pk_accounts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "orders" (
    "id" INTEGER, 
    "account_id" INTEGER ,
    "occurred_at" TIMESTAMP,
    "tandard_qty" INTEGER,
    "gloss_qty" INTEGER   ,
    "poster_qty" INTEGER  ,
    "total" INTEGER   ,
    "standard_amt_usd" NUMERIC   ,
    "gloss_amt_usd" NUMERIC   ,
    "poster_amt_usd" NUMERIC   ,
    "total_amt_usd" NUMERIC   ,
    CONSTRAINT "pk_orders" PRIMARY KEY (
        "id"
     )
);


CREATE TABLE "regions" (
    "id" INTEGER   NOT NULL,
    "name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_regions" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "sales_reps" (
    "id" INTEGER   NOT NULL,
    "name" VARCHAR   NOT NULL,
    "region_id" INTEGER   NOT NULL,
    CONSTRAINT "pk_sales_reps" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "web_events" (
    "id" INTEGER   NOT NULL,
    "account_id" INTEGER   NOT NULL,
    "occurred_at" TIMESTAMP   NOT NULL,
    "channel" VARCHAR   NOT NULL,
    CONSTRAINT "pk_web_events" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "accounts" ADD CONSTRAINT "fk_accounts_sales_rep_id" FOREIGN KEY("sales_rep_id")
REFERENCES "sales_reps" ("id");

ALTER TABLE "orders" ADD CONSTRAINT "fk_orders_account_id" FOREIGN KEY("account_id")
REFERENCES "accounts" ("id");

ALTER TABLE "sales_reps" ADD CONSTRAINT "fk_sales_reps_region_id" FOREIGN KEY("region_id")
REFERENCES "regions" ("id");

ALTER TABLE "web_events" ADD CONSTRAINT "fk_web_events_account_id" FOREIGN KEY("account_id")
REFERENCES "accounts" ("id");


