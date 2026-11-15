# Home Health Visit Coordination — database design

My case study records client, caregiver, service_visit.

## Users

- Home-care schedulers
- Caregiver coordinators
- Operations analysts

## Main operations

- Register clients and caregivers
- Schedule and update visits
- Review visit assignments and summarize caregiver workloads

## Entities

| Entity | Information stored |
| --- | --- |
| client | Stores basic identifying and contact-area information for a home-care client. |
| caregiver | Stores caregiver identity, license, and availability status. |
| service_visit | Records a scheduled home-care visit and its client, caregiver, status, and duration. |

## client

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| client_id | BIGINT | PK | Yes |
| first_name | TEXT |  | Yes |
| last_name | TEXT |  | Yes |
| birth_date | DATE |  | Yes |
| postal_code | TEXT |  | No |


## caregiver

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| caregiver_id | BIGINT | PK | Yes |
| display_name | TEXT |  | Yes |
| license_code | TEXT | Unique | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (license_code).

## service_visit

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| visit_id | BIGINT | PK | Yes |
| client_id | BIGINT | FK | Yes |
| caregiver_id | BIGINT | FK | Yes |
| scheduled_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| duration_minutes | INTEGER |  | No |
- client_id → client.client_id
- caregiver_id → caregiver.caregiver_id

## Relationships and business rules

- Every caregiver license_code must be unique.
- Every service visit must reference an existing client.
- Every service visit must reference an existing caregiver.
- If duration_minutes is provided, it must be greater than zero.
- A partial unique rule permits at most one visit per caregiver and scheduled_at where status is not cancelled.

## Assumptions

- Each visit has exactly one client and one caregiver; a client or caregiver may have multiple visits.
- A caregiver cannot have two non-cancelled visits at the same scheduled_at value.
- Normalization example: use service_visit as the root, with client_id and caregiver_id foreign keys. Keep client attributes in client and caregiver attributes in caregiver rather than repeating them in each visit; these are distinct parent roles.
- The event model records visit lifecycle changes and uses synthetic identifiers and payloads only.

