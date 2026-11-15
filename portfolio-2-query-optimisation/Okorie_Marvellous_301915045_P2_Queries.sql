-- Show related service_visit, client, caregiver records (up to 20).
SELECT t0."visit_id" AS "service_visit_visit_id",
       t0."scheduled_at" AS "service_visit_scheduled_at",
       t1."client_id" AS "client_client_id",
       t1."first_name" AS "client_first_name",
       t2."caregiver_id" AS "caregiver_caregiver_id",
       t2."display_name" AS "caregiver_display_name"
FROM portfolio."service_visit" t0
JOIN portfolio."client" t1 ON t0."client_id" = t1."client_id"
JOIN portfolio."caregiver" t2 ON t0."caregiver_id" = t2."caregiver_id"
ORDER BY t0."visit_id", t1."client_id", t2."caregiver_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."visit_id" AS "service_visit_visit_id",
       t0."scheduled_at" AS "service_visit_scheduled_at",
       t1."client_id" AS "client_client_id",
       t1."first_name" AS "client_first_name",
       t2."caregiver_id" AS "caregiver_caregiver_id",
       t2."display_name" AS "caregiver_display_name"
FROM portfolio."service_visit" t0
JOIN portfolio."client" t1 ON t0."client_id" = t1."client_id"
JOIN portfolio."caregiver" t2 ON t0."caregiver_id" = t2."caregiver_id"
ORDER BY t0."visit_id", t1."client_id", t2."caregiver_id"
LIMIT 20;

-- Find service_visit records where scheduled_at matches "2026-11-16T10:00:00Z" (up to 20).
SELECT * FROM portfolio."service_visit"
WHERE "scheduled_at" IS NOT DISTINCT FROM '2026-11-16T10:00:00Z'
ORDER BY "visit_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."service_visit"
WHERE "scheduled_at" IS NOT DISTINCT FROM '2026-11-16T10:00:00Z'
ORDER BY "visit_id"
LIMIT 20;

-- Count service_visit records for each client_id (up to 20 groups).
SELECT "client_id", count(*) AS record_count
FROM portfolio."service_visit"
GROUP BY "client_id"
ORDER BY record_count DESC, "client_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "client_id", count(*) AS record_count
FROM portfolio."service_visit"
GROUP BY "client_id"
ORDER BY record_count DESC, "client_id" NULLS LAST
LIMIT 20;
