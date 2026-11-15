# Home Health Visit Coordination — SQL queries

## 1. Show related service_visit, client, caregiver records (up to 20).

```sql
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
```

| service_visit_visit_id | service_visit_scheduled_at | client_client_id | client_first_name | caregiver_caregiver_id | caregiver_display_name |
| --- | --- | --- | --- | --- | --- |
| 5 | 2026-11-16T10:00:00+00:00 | 1 | Avery | 3 | Jordan Lee |
| 6 | 2026-11-16T11:00:00+00:00 | 2 | Riley | 4 | Casey Patel |

## 2. Find service_visit records where scheduled_at matches "2026-11-16T10:00:00Z" (up to 20).

```sql
SELECT * FROM portfolio."service_visit"
WHERE "scheduled_at" IS NOT DISTINCT FROM '2026-11-16T10:00:00Z'
ORDER BY "visit_id"
LIMIT 20;
```

| visit_id | client_id | caregiver_id | scheduled_at | status | duration_minutes |
| --- | --- | --- | --- | --- | --- |
| 5 | 1 | 3 | 2026-11-16T10:00:00+00:00 | scheduled | 60 |

## 3. Count service_visit records for each client_id (up to 20 groups).

```sql
SELECT "client_id", count(*) AS record_count
FROM portfolio."service_visit"
GROUP BY "client_id"
ORDER BY record_count DESC, "client_id" NULLS LAST
LIMIT 20;
```

| client_id | record_count |
| --- | --- |
| 1 | 1 |
| 2 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.438 | 2.209, 1.438, 1.187 | Sort → Seq Scan | 139 |
| After index | 0.187 | 0.183, 0.349, 0.187 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 30 |

The median execution time changed from 1.438 ms to 0.187 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.172..2.174 rows=25 loops=1)
  Seq Scan on service_visit (actual time=0.021..2.122 rows=25 loops=1)
Planning Time: 0.863 ms
Execution Time: 2.209 ms
```

### Before index, run 2

```text
Sort (actual time=1.368..1.369 rows=25 loops=1)
  Seq Scan on service_visit (actual time=0.014..1.328 rows=25 loops=1)
Planning Time: 0.322 ms
Execution Time: 1.438 ms
```

### Before index, run 3

```text
Sort (actual time=1.158..1.16 rows=25 loops=1)
  Seq Scan on service_visit (actual time=0.014..1.124 rows=25 loops=1)
Planning Time: 0.351 ms
Execution Time: 1.187 ms
```

### After index, run 1

```text
Sort (actual time=0.126..0.128 rows=25 loops=1)
  Bitmap Heap Scan on service_visit (actual time=0.026..0.092 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.014 rows=25 loops=1)
Planning Time: 0.519 ms
Execution Time: 0.183 ms
```

### After index, run 2

```text
Sort (actual time=0.288..0.291 rows=25 loops=1)
  Bitmap Heap Scan on service_visit (actual time=0.087..0.251 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.059..0.059 rows=25 loops=1)
Planning Time: 0.526 ms
Execution Time: 0.349 ms
```

### After index, run 3

```text
Sort (actual time=0.127..0.129 rows=25 loops=1)
  Bitmap Heap Scan on service_visit (actual time=0.026..0.092 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=25 loops=1)
Planning Time: 0.538 ms
Execution Time: 0.187 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Okorie_Marvellous_301915045_P2_Queries.sql, then Okorie_Marvellous_301915045_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Okorie_Marvellous_301915045_P2_QueryResults.png) · [Index comparison](screenshots/Okorie_Marvellous_301915045_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

