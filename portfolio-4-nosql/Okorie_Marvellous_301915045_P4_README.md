# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection visit_events for visit_scheduled and visit_started events. These are fictional event examples based on service_visit, client, caregiver.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related client, caregiver details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "visit_scheduled",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "service_visit",
        "key": {
            "visit_id": 5
        },
        "snapshot": {
            "visit_id": 5,
            "client_id": 1,
            "caregiver_id": 3,
            "scheduled_at": "2026-11-16T10:00:00Z",
            "status": "scheduled",
            "duration_minutes": 60
        }
    },
    "embedded": {
        "client": [
            {
                "key": {
                    "client_id": 1
                },
                "snapshot": {
                    "client_id": 1,
                    "first_name": "Avery",
                    "last_name": "Morgan",
                    "birth_date": "1948-03-12",
                    "postal_code": "02139"
                },
                "via": [
                    "service_visit.client_id → client"
                ]
            }
        ],
        "caregiver": [
            {
                "key": {
                    "caregiver_id": 3
                },
                "snapshot": {
                    "caregiver_id": 3,
                    "display_name": "Jordan Lee",
                    "license_code": "HHA-0003",
                    "active": true
                },
                "via": [
                    "service_visit.caregiver_id → caregiver"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("visit_events").find({"eventType":"visit_scheduled"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "visit_scheduled",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "visit_id": 5
    }
  },
  {
    "_id": "event_000003",
    "eventType": "visit_scheduled",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "visit_id": 6
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("visit_events").find({"source.key.visit_id":5}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "visit_scheduled",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "visit_id": 5
    }
  },
  {
    "_id": "event_000002",
    "eventType": "visit_started",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "visit_id": 5
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("visit_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "visit_scheduled",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "visit_id": 5
    }
  },
  {
    "_id": "event_000002",
    "eventType": "visit_started",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "visit_id": 5
    }
  },
  {
    "_id": "event_000003",
    "eventType": "visit_scheduled",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "visit_id": 6
    }
  },
  {
    "_id": "event_000004",
    "eventType": "visit_started",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "visit_id": 6
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("visit_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| visit_scheduled | 2 |
| visit_started | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Okorie_Marvellous_301915045_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Okorie_Marvellous_301915045_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

