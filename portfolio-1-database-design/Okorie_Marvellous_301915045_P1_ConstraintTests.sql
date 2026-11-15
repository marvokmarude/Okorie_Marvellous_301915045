-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. client pk violation. Expected: pk_client, SQLSTATE 23505.
INSERT INTO portfolio."client" ("client_id", "first_name", "last_name", "birth_date", "postal_code")
VALUES (1, 'Taylor', 'Reed', '1960-05-18', '02141');

-- 2. client id not null. Expected: client_id, SQLSTATE 23502.
INSERT INTO portfolio."client" ("client_id", "first_name", "last_name", "birth_date", "postal_code")
VALUES (NULL, 'Taylor', 'Reed', '1960-05-18', '02141');

-- 3. client first name not null. Expected: first_name, SQLSTATE 23502.
INSERT INTO portfolio."client" ("client_id", "first_name", "last_name", "birth_date", "postal_code")
VALUES (101, NULL, 'Reed', '1960-05-18', '02141');

-- 4. client last name not null. Expected: last_name, SQLSTATE 23502.
INSERT INTO portfolio."client" ("client_id", "first_name", "last_name", "birth_date", "postal_code")
VALUES (102, 'Taylor', NULL, '1960-05-18', '02141');

-- 5. client birth date not null. Expected: birth_date, SQLSTATE 23502.
INSERT INTO portfolio."client" ("client_id", "first_name", "last_name", "birth_date", "postal_code")
VALUES (103, 'Taylor', 'Reed', NULL, '02141');

-- 6. caregiver pk violation. Expected: pk_caregiver, SQLSTATE 23505.
INSERT INTO portfolio."caregiver" ("caregiver_id", "display_name", "license_code", "active")
VALUES (3, 'Drew Kim', 'HHA-0103', TRUE);

-- 7. caregiver license unique violation. Expected: uq_caregiver_0, SQLSTATE 23505.
INSERT INTO portfolio."caregiver" ("caregiver_id", "display_name", "license_code", "active")
VALUES (104, 'Drew Kim', 'HHA-0003', TRUE);

-- 8. caregiver id not null. Expected: caregiver_id, SQLSTATE 23502.
INSERT INTO portfolio."caregiver" ("caregiver_id", "display_name", "license_code", "active")
VALUES (NULL, 'Drew Kim', 'HHA-0105', TRUE);

-- 9. caregiver display name not null. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."caregiver" ("caregiver_id", "display_name", "license_code", "active")
VALUES (105, NULL, 'HHA-0106', TRUE);

-- 10. caregiver license code not null. Expected: license_code, SQLSTATE 23502.
INSERT INTO portfolio."caregiver" ("caregiver_id", "display_name", "license_code", "active")
VALUES (106, 'Drew Kim', NULL, TRUE);

-- 11. caregiver active not null. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."caregiver" ("caregiver_id", "display_name", "license_code", "active")
VALUES (107, 'Drew Kim', 'HHA-0108', NULL);

-- 12. visit pk violation. Expected: pk_service_visit, SQLSTATE 23505.
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes")
VALUES (5, 2, 4, '2026-11-17T10:00:00Z', 'scheduled', 30);

-- 13. visit client fk violation. Expected: fk_service_visit_0, SQLSTATE 23503.
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes")
VALUES (108, 9998, 3, '2026-11-17T10:00:00Z', 'scheduled', 30);

-- 14. visit caregiver fk violation. Expected: fk_service_visit_1, SQLSTATE 23503.
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes")
VALUES (109, 1, 9999, '2026-11-17T10:00:00Z', 'scheduled', 30);

-- 15. visit id not null. Expected: visit_id, SQLSTATE 23502.
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes")
VALUES (NULL, 1, 3, '2026-11-17T12:00:00Z', 'scheduled', 30);

-- 16. visit client id not null. Expected: client_id, SQLSTATE 23502.
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes")
VALUES (110, NULL, 3, '2026-11-17T12:00:00Z', 'scheduled', 30);

-- 17. visit caregiver id not null. Expected: caregiver_id, SQLSTATE 23502.
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes")
VALUES (111, 1, NULL, '2026-11-17T12:00:00Z', 'scheduled', 30);

-- 18. visit scheduled at not null. Expected: scheduled_at, SQLSTATE 23502.
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes")
VALUES (112, 1, 3, NULL, 'scheduled', 30);

-- 19. visit status not null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes")
VALUES (113, 1, 3, '2026-11-17T12:00:00Z', NULL, 30);

-- 20. visit duration check violation. Expected: visit_duration_positive, SQLSTATE 23514.
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes")
VALUES (114, 1, 3, '2026-11-17T13:00:00Z', 'scheduled', -5);

-- 21. visit slot partial unique violation. Expected: visit_slot_unique, SQLSTATE 23505.
INSERT INTO portfolio."service_visit" ("visit_id", "client_id", "caregiver_id", "scheduled_at", "status", "duration_minutes")
VALUES (115, 2, 3, '2026-11-16T10:00:00Z', 'scheduled', 30);
