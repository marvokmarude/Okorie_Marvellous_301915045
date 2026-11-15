-- Fictional sample records for Home Health Visit Coordination.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."client" ("client_id", "first_name", "last_name", "birth_date", "postal_code") VALUES (1, 'Avery', 'Morgan', '1948-03-12', '02139');
INSERT INTO portfolio."client" ("client_id", "first_name", "last_name", "birth_date", "postal_code") VALUES (2, 'Riley', 'Chen', '1955-07-24', '02140');
INSERT INTO portfolio."caregiver" ("caregiver_id", "display_name", "license_code", "active") VALUES (3, 'Jordan Lee', 'HHA-0003', TRUE);
INSERT INTO portfolio."caregiver" ("caregiver_id", "display_name", "license_code", "active") VALUES (4, 'Casey Patel', 'HHA-0004', TRUE);
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes") VALUES (5, 1, 3, '2026-11-16T10:00:00Z', 'scheduled', 60);
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes") VALUES (6, 2, 4, '2026-11-16T11:00:00Z', 'completed', 45);
COMMIT;
