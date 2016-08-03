-- Convert schema 'sql/_source/deploy/1/001-auto.yml' to 'sql/_source/deploy/22/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE "conference_tickets" (
  "conferences_id" integer NOT NULL,
  "sku" character varying(64) NOT NULL,
  PRIMARY KEY ("conferences_id", "sku")
);
CREATE INDEX "conference_tickets_idx_conferences_id" on "conference_tickets" ("conferences_id");
CREATE INDEX "conference_tickets_idx_sku" on "conference_tickets" ("sku");

;
CREATE TABLE "events" (
  "events_id" serial NOT NULL,
  "conferences_id" integer NOT NULL,
  "duration" smallint NOT NULL,
  "title" character varying(255) NOT NULL,
  "abstract" character varying(2048) DEFAULT '' NOT NULL,
  "url" character varying(255) DEFAULT '' NOT NULL,
  "scheduled" boolean DEFAULT '0' NOT NULL,
  "start_time" timestamp,
  "room" character varying(128) DEFAULT '' NOT NULL,
  PRIMARY KEY ("events_id")
);
CREATE INDEX "events_idx_conferences_id" on "events" ("conferences_id");

;
CREATE TABLE "media_messages" (
  "media_id" integer NOT NULL,
  "messages_id" integer NOT NULL,
  PRIMARY KEY ("media_id", "messages_id")
);
CREATE INDEX "media_messages_idx_media_id" on "media_messages" ("media_id");
CREATE INDEX "media_messages_idx_messages_id" on "media_messages" ("messages_id");

;
CREATE TABLE "media_navigations" (
  "media_id" integer NOT NULL,
  "navigation_id" integer NOT NULL,
  PRIMARY KEY ("media_id", "navigation_id")
);
CREATE INDEX "media_navigations_idx_media_id" on "media_navigations" ("media_id");
CREATE INDEX "media_navigations_idx_navigation_id" on "media_navigations" ("navigation_id");

;
CREATE TABLE "navigation_messages" (
  "messages_id" integer NOT NULL,
  "navigation_id" integer NOT NULL,
  PRIMARY KEY ("messages_id", "navigation_id")
);
CREATE INDEX "navigation_messages_idx_messages_id" on "navigation_messages" ("messages_id");
CREATE INDEX "navigation_messages_idx_navigation_id" on "navigation_messages" ("navigation_id");

;
CREATE TABLE "product_messages" (
  "messages_id" integer NOT NULL,
  "sku" character varying(64) NOT NULL,
  PRIMARY KEY ("messages_id", "sku")
);
CREATE INDEX "product_messages_idx_messages_id" on "product_messages" ("messages_id");
CREATE INDEX "product_messages_idx_sku" on "product_messages" ("sku");

;
CREATE TABLE "survey_question_options" (
  "survey_question_option_id" serial NOT NULL,
  "title" character varying(255) NOT NULL,
  "priority" integer NOT NULL,
  "survey_question_id" integer NOT NULL,
  PRIMARY KEY ("survey_question_option_id")
);
CREATE INDEX "survey_question_options_idx_survey_question_id" on "survey_question_options" ("survey_question_id");

;
CREATE TABLE "survey_questions" (
  "survey_question_id" serial NOT NULL,
  "title" character varying(255) NOT NULL,
  "description" character varying(2048) DEFAULT '' NOT NULL,
  "other" character varying(255) DEFAULT '' NOT NULL,
  "type" character varying(16) NOT NULL,
  "priority" integer NOT NULL,
  "survey_section_id" integer NOT NULL,
  PRIMARY KEY ("survey_question_id")
);
CREATE INDEX "survey_questions_idx_survey_section_id" on "survey_questions" ("survey_section_id");

;
CREATE TABLE "survey_response_options" (
  "survey_response_option_id" serial NOT NULL,
  "survey_response_id" integer NOT NULL,
  "survey_question_option_id" integer NOT NULL,
  "value" integer,
  PRIMARY KEY ("survey_response_option_id")
);
CREATE INDEX "survey_response_options_idx_survey_question_option_id" on "survey_response_options" ("survey_question_option_id");
CREATE INDEX "survey_response_options_idx_survey_response_id" on "survey_response_options" ("survey_response_id");

;
CREATE TABLE "survey_responses" (
  "survey_response_id" serial NOT NULL,
  "user_survey_id" integer NOT NULL,
  "survey_question_id" integer NOT NULL,
  "other" text DEFAULT '' NOT NULL,
  PRIMARY KEY ("survey_response_id"),
  CONSTRAINT "user_survey_survey_question" UNIQUE ("user_survey_id", "survey_question_id")
);
CREATE INDEX "survey_responses_idx_survey_question_id" on "survey_responses" ("survey_question_id");
CREATE INDEX "survey_responses_idx_user_survey_id" on "survey_responses" ("user_survey_id");

;
CREATE TABLE "survey_sections" (
  "survey_section_id" serial NOT NULL,
  "title" character varying(255) NOT NULL,
  "description" character varying(2048) DEFAULT '' NOT NULL,
  "priority" integer NOT NULL,
  "survey_id" integer NOT NULL,
  PRIMARY KEY ("survey_section_id")
);
CREATE INDEX "survey_sections_idx_survey_id" on "survey_sections" ("survey_id");

;
CREATE TABLE "surveys" (
  "survey_id" serial NOT NULL,
  "title" character varying(255) NOT NULL,
  "conferences_id" integer NOT NULL,
  "author_id" integer NOT NULL,
  "public" boolean DEFAULT '0' NOT NULL,
  "closed" boolean DEFAULT '0' NOT NULL,
  "created" timestamp NOT NULL,
  "last_modified" timestamp NOT NULL,
  "priority" integer DEFAULT 0 NOT NULL,
  PRIMARY KEY ("survey_id"),
  CONSTRAINT "surveys_conferences_id_title" UNIQUE ("conferences_id", "title")
);
CREATE INDEX "surveys_idx_author_id" on "surveys" ("author_id");
CREATE INDEX "surveys_idx_conferences_id" on "surveys" ("conferences_id");

;
CREATE TABLE "user_surveys" (
  "user_survey_id" serial NOT NULL,
  "users_id" integer NOT NULL,
  "survey_id" integer NOT NULL,
  "completed" boolean DEFAULT '0' NOT NULL,
  PRIMARY KEY ("user_survey_id"),
  CONSTRAINT "users_id_survey_id" UNIQUE ("users_id", "survey_id")
);
CREATE INDEX "user_surveys_idx_survey_id" on "user_surveys" ("survey_id");
CREATE INDEX "user_surveys_idx_users_id" on "user_surveys" ("users_id");

;
ALTER TABLE "conference_tickets" ADD CONSTRAINT "conference_tickets_fk_conferences_id" FOREIGN KEY ("conferences_id")
  REFERENCES "conferences" ("conferences_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "conference_tickets" ADD CONSTRAINT "conference_tickets_fk_sku" FOREIGN KEY ("sku")
  REFERENCES "products" ("sku") ON DELETE CASCADE DEFERRABLE;

;
ALTER TABLE "events" ADD CONSTRAINT "events_fk_conferences_id" FOREIGN KEY ("conferences_id")
  REFERENCES "conferences" ("conferences_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "media_messages" ADD CONSTRAINT "media_messages_fk_media_id" FOREIGN KEY ("media_id")
  REFERENCES "medias" ("media_id") DEFERRABLE;

;
ALTER TABLE "media_messages" ADD CONSTRAINT "media_messages_fk_messages_id" FOREIGN KEY ("messages_id")
  REFERENCES "messages" ("messages_id") DEFERRABLE;

;
ALTER TABLE "media_navigations" ADD CONSTRAINT "media_navigations_fk_media_id" FOREIGN KEY ("media_id")
  REFERENCES "medias" ("media_id") DEFERRABLE;

;
ALTER TABLE "media_navigations" ADD CONSTRAINT "media_navigations_fk_navigation_id" FOREIGN KEY ("navigation_id")
  REFERENCES "navigations" ("navigation_id") DEFERRABLE;

;
ALTER TABLE "navigation_messages" ADD CONSTRAINT "navigation_messages_fk_messages_id" FOREIGN KEY ("messages_id")
  REFERENCES "messages" ("messages_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "navigation_messages" ADD CONSTRAINT "navigation_messages_fk_navigation_id" FOREIGN KEY ("navigation_id")
  REFERENCES "navigations" ("navigation_id") ON DELETE CASCADE DEFERRABLE;

;
ALTER TABLE "product_messages" ADD CONSTRAINT "product_messages_fk_messages_id" FOREIGN KEY ("messages_id")
  REFERENCES "messages" ("messages_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "product_messages" ADD CONSTRAINT "product_messages_fk_sku" FOREIGN KEY ("sku")
  REFERENCES "products" ("sku") ON DELETE CASCADE DEFERRABLE;

;
ALTER TABLE "survey_question_options" ADD CONSTRAINT "survey_question_options_fk_survey_question_id" FOREIGN KEY ("survey_question_id")
  REFERENCES "survey_questions" ("survey_question_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "survey_questions" ADD CONSTRAINT "survey_questions_fk_survey_section_id" FOREIGN KEY ("survey_section_id")
  REFERENCES "survey_sections" ("survey_section_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "survey_response_options" ADD CONSTRAINT "survey_response_options_fk_survey_question_option_id" FOREIGN KEY ("survey_question_option_id")
  REFERENCES "survey_question_options" ("survey_question_option_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "survey_response_options" ADD CONSTRAINT "survey_response_options_fk_survey_response_id" FOREIGN KEY ("survey_response_id")
  REFERENCES "survey_responses" ("survey_response_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "survey_responses" ADD CONSTRAINT "survey_responses_fk_survey_question_id" FOREIGN KEY ("survey_question_id")
  REFERENCES "survey_questions" ("survey_question_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "survey_responses" ADD CONSTRAINT "survey_responses_fk_user_survey_id" FOREIGN KEY ("user_survey_id")
  REFERENCES "user_surveys" ("user_survey_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "survey_sections" ADD CONSTRAINT "survey_sections_fk_survey_id" FOREIGN KEY ("survey_id")
  REFERENCES "surveys" ("survey_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "surveys" ADD CONSTRAINT "surveys_fk_author_id" FOREIGN KEY ("author_id")
  REFERENCES "users" ("users_id") DEFERRABLE;

;
ALTER TABLE "surveys" ADD CONSTRAINT "surveys_fk_conferences_id" FOREIGN KEY ("conferences_id")
  REFERENCES "conferences" ("conferences_id") DEFERRABLE;

;
ALTER TABLE "user_surveys" ADD CONSTRAINT "user_surveys_fk_survey_id" FOREIGN KEY ("survey_id")
  REFERENCES "surveys" ("survey_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "user_surveys" ADD CONSTRAINT "user_surveys_fk_users_id" FOREIGN KEY ("users_id")
  REFERENCES "users" ("users_id") DEFERRABLE;

;
ALTER TABLE addresses ADD COLUMN latitude float(20);

;
ALTER TABLE addresses ADD COLUMN longitude float(30);

;
ALTER TABLE cart_products ADD COLUMN combine boolean DEFAULT '1' NOT NULL;

;
ALTER TABLE cart_products ADD COLUMN extra text;

;
ALTER TABLE carts DROP CONSTRAINT carts_fk_sessions_id;

;
ALTER TABLE carts ADD CONSTRAINT carts_fk_sessions_id FOREIGN KEY (sessions_id)
  REFERENCES sessions (sessions_id) ON DELETE SET NULL DEFERRABLE;

;
ALTER TABLE conferences ADD COLUMN start_date date;

;
ALTER TABLE conferences ADD COLUMN end_date date;

;
ALTER TABLE medias ADD COLUMN priority integer DEFAULT 0 NOT NULL;

;
ALTER TABLE medias ALTER COLUMN file DROP NOT NULL;

;
ALTER TABLE medias ALTER COLUMN file DROP DEFAULT;

;
ALTER TABLE messages ADD COLUMN summary character varying(1024) DEFAULT '' NOT NULL;

;
ALTER TABLE messages ADD COLUMN tags character varying(256) DEFAULT '' NOT NULL;

;
ALTER TABLE orderlines ALTER COLUMN price TYPE numeric(21,3);

;
ALTER TABLE orderlines ALTER COLUMN subtotal TYPE numeric(21,3);

;
ALTER TABLE orderlines ALTER COLUMN shipping TYPE numeric(21,3);

;
ALTER TABLE orderlines ALTER COLUMN shipping SET DEFAULT 0;

;
ALTER TABLE orderlines ALTER COLUMN handling TYPE numeric(21,3);

;
ALTER TABLE orderlines ALTER COLUMN handling SET DEFAULT 0;

;
ALTER TABLE orderlines ALTER COLUMN salestax TYPE numeric(21,3);

;
ALTER TABLE orderlines ALTER COLUMN salestax SET DEFAULT 0;

;
ALTER TABLE orderlines_shippings DROP CONSTRAINT orderlines_shippings_pkey;

;
ALTER TABLE orderlines_shippings ADD COLUMN quantity integer NOT NULL;

;
ALTER TABLE orderlines_shippings ADD PRIMARY KEY (orderlines_id, addresses_id, shipments_id);

;
ALTER TABLE orders ALTER COLUMN subtotal TYPE numeric(21,3);

;
ALTER TABLE orders ALTER COLUMN subtotal SET DEFAULT 0;

;
ALTER TABLE orders ALTER COLUMN shipping TYPE numeric(21,3);

;
ALTER TABLE orders ALTER COLUMN shipping SET DEFAULT 0;

;
ALTER TABLE orders ALTER COLUMN handling TYPE numeric(21,3);

;
ALTER TABLE orders ALTER COLUMN handling SET DEFAULT 0;

;
ALTER TABLE orders ALTER COLUMN salestax TYPE numeric(21,3);

;
ALTER TABLE orders ALTER COLUMN salestax SET DEFAULT 0;

;
ALTER TABLE orders ALTER COLUMN total_cost TYPE numeric(21,3);

;
ALTER TABLE orders ALTER COLUMN total_cost SET DEFAULT 0;

;
ALTER TABLE payment_orders ALTER COLUMN amount TYPE numeric(21,3);

;
ALTER TABLE payment_orders ALTER COLUMN amount SET DEFAULT 0;

;
ALTER TABLE payment_orders ALTER COLUMN payment_fee TYPE numeric(12,3);

;
ALTER TABLE payment_orders ALTER COLUMN payment_fee SET DEFAULT 0;

;
ALTER TABLE price_modifiers DROP CONSTRAINT price_modifiers_fk_sku;

;
ALTER TABLE price_modifiers ALTER COLUMN price TYPE numeric(21,3);

;
ALTER TABLE price_modifiers ADD CONSTRAINT price_modifiers_fk_sku FOREIGN KEY (sku)
  REFERENCES products (sku) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE products ADD COLUMN combine boolean DEFAULT '1' NOT NULL;

;
ALTER TABLE products ALTER COLUMN price TYPE numeric(21,3);

;
ALTER TABLE products ALTER COLUMN price SET DEFAULT 0;

;
ALTER TABLE shipment_rates ALTER COLUMN price TYPE numeric(21,3);

;
ALTER TABLE shipment_rates ALTER COLUMN price SET DEFAULT 0;

;
ALTER TABLE talks ADD COLUMN video_url character varying(255) DEFAULT '' NOT NULL;

;
ALTER TABLE talks ADD COLUMN scheduled boolean DEFAULT '0' NOT NULL;

;
ALTER TABLE talks ADD COLUMN survey_id integer;

;
ALTER TABLE talks ALTER COLUMN author_id DROP NOT NULL;

;
CREATE INDEX talks_idx_survey_id on talks (survey_id);

;
ALTER TABLE talks ADD CONSTRAINT talks_fk_survey_id FOREIGN KEY (survey_id)
  REFERENCES surveys (survey_id) ON DELETE SET NULL DEFERRABLE;

;
ALTER TABLE users ADD COLUMN monger_groups character varying(256) DEFAULT '' NOT NULL;

;
ALTER TABLE users ADD COLUMN guru_level integer DEFAULT 0 NOT NULL;

;
ALTER TABLE users ADD COLUMN t_shirt_size character varying(8);

;
ALTER TABLE users ALTER COLUMN password TYPE character varying(2048);

;
ALTER TABLE users ALTER COLUMN password SET DEFAULT '*';

;
DROP TABLE product_reviews CASCADE;

;

COMMIT;

