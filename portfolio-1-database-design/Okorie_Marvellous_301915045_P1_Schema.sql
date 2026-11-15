-- Home Health Visit Coordination: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."client" (
  "client_id" bigint NOT NULL,
  "first_name" text NOT NULL,
  "last_name" text NOT NULL,
  "birth_date" date NOT NULL,
  "postal_code" text,
  CONSTRAINT "pk_client" PRIMARY KEY ("client_id")
);
CREATE TABLE portfolio."caregiver" (
  "caregiver_id" bigint NOT NULL,
  "display_name" text NOT NULL,
  "license_code" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_caregiver" PRIMARY KEY ("caregiver_id"),
  CONSTRAINT "uq_caregiver_0" UNIQUE ("license_code")
);
CREATE TABLE portfolio."service_visit" (
  "visit_id" bigint NOT NULL,
  "client_id" bigint NOT NULL,
  "caregiver_id" bigint NOT NULL,
  "scheduled_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  "duration_minutes" bigint,
  CONSTRAINT "pk_service_visit" PRIMARY KEY ("visit_id")
);
ALTER TABLE portfolio."service_visit" ADD CONSTRAINT "fk_service_visit_0" FOREIGN KEY ("client_id") REFERENCES portfolio."client" ("client_id");
ALTER TABLE portfolio."service_visit" ADD CONSTRAINT "fk_service_visit_1" FOREIGN KEY ("caregiver_id") REFERENCES portfolio."caregiver" ("caregiver_id");
ALTER TABLE portfolio."service_visit" ADD CONSTRAINT "visit_duration_positive" CHECK ("duration_minutes" > 0);
CREATE UNIQUE INDEX "visit_slot_unique" ON portfolio."service_visit" ("caregiver_id", "scheduled_at") WHERE (("status" = 'scheduled') OR ("status" = 'started') OR ("status" = 'in_progress') OR ("status" = 'completed'));
COMMIT;
