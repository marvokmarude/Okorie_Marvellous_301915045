# Home Health Visit Coordination — ER diagram

```mermaid
erDiagram
    direction LR
    client {
        bigint client_id PK
        text first_name
        text last_name
        date birth_date
        text postal_code "Optional"
    }
    caregiver {
        bigint caregiver_id PK
        text display_name
        text license_code UK
        boolean active
    }
    service_visit {
        bigint visit_id PK
        bigint client_id FK
        bigint caregiver_id FK
        timestamptz scheduled_at
        text status
        integer duration_minutes "Optional"
    }
    client ||--o{ service_visit : "client_id"
    caregiver ||--o{ service_visit : "caregiver_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Okorie_Marvellous_301915045_ERDiagram.png)
