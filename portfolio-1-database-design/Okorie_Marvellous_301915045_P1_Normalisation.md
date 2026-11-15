# Home Health Visit Coordination — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| client_id | service_visit records (list) |
| --- | --- |
| 1 | [5] |
| 2 | [6] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| service_visit.visit_id | service_visit.client_id | service_visit.caregiver_id | service_visit.status | client.client_id | client.first_name | caregiver.caregiver_id | caregiver.display_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5 | 1 | 3 | scheduled | 1 | Avery | 3 | Jordan Lee |
| 6 | 2 | 4 | completed | 2 | Riley | 4 | Casey Patel |

Key: visit_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## service_visit_example

| service_visit.visit_id | service_visit.client_id | service_visit.caregiver_id | service_visit.status | client.client_id | client.first_name | caregiver.caregiver_id | caregiver.display_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5 | 1 | 3 | scheduled | 1 | Avery | 3 | Jordan Lee |
| 6 | 2 | 4 | completed | 2 | Riley | 4 | Casey Patel |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## client

| client_id | first_name | last_name | birth_date | postal_code |
| --- | --- | --- | --- | --- |
| 1 | Avery | Morgan | 1948-03-12 | 02139 |
| 2 | Riley | Chen | 1955-07-24 | 02140 |

## caregiver

| caregiver_id | display_name | license_code | active |
| --- | --- | --- | --- |
| 3 | Jordan Lee | HHA-0003 | true |
| 4 | Casey Patel | HHA-0004 | true |

## service_visit

| visit_id | client_id | caregiver_id | scheduled_at | status | duration_minutes |
| --- | --- | --- | --- | --- | --- |
| 5 | 1 | 3 | 2026-11-16T10:00:00+00:00 | scheduled | 60 |
| 6 | 2 | 4 | 2026-11-16T11:00:00+00:00 | completed | 45 |

## Dependencies

- client: (client_id) → first_name, last_name, birth_date, postal_code
- caregiver: (caregiver_id) → display_name, license_code, active
- service_visit: (visit_id) → client_id, caregiver_id, scheduled_at, status, duration_minutes

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
