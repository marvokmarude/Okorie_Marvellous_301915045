// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("visit_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("visit_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "visit_scheduled",
                    "visit_started"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "service_visit"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "visit_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs as defined.
  printjson(await db.getCollection("visit_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "visit_started",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "service_visit",
                    "key": {
                        "visit_id": 5
                    },
                    "field": "duration_minutes",
                    "value": 60
                }
            ],
            "examples": {
                "event_payload": "illustrative event_payload",
                "reason_code": "illustrative reason_code"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "visit_scheduled",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "service_visit",
            "key": {
                "visit_id": 6
            },
            "snapshot": {
                "visit_id": 6,
                "client_id": 2,
                "caregiver_id": 4,
                "scheduled_at": "2026-11-16T11:00:00Z",
                "status": "completed",
                "duration_minutes": 45
            }
        },
        "embedded": {
            "client": [
                {
                    "key": {
                        "client_id": 2
                    },
                    "snapshot": {
                        "client_id": 2,
                        "first_name": "Riley",
                        "last_name": "Chen",
                        "birth_date": "1955-07-24",
                        "postal_code": "02140"
                    },
                    "via": [
                        "service_visit.client_id → client"
                    ]
                }
            ],
            "caregiver": [
                {
                    "key": {
                        "caregiver_id": 4
                    },
                    "snapshot": {
                        "caregiver_id": 4,
                        "display_name": "Casey Patel",
                        "license_code": "HHA-0004",
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
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "visit_started",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "service_visit",
            "key": {
                "visit_id": 6
            },
            "snapshot": {
                "visit_id": 6,
                "client_id": 2,
                "caregiver_id": 4,
                "scheduled_at": "2026-11-16T11:00:00Z",
                "status": "completed",
                "duration_minutes": 45
            }
        },
        "embedded": {
            "client": [
                {
                    "key": {
                        "client_id": 2
                    },
                    "snapshot": {
                        "client_id": 2,
                        "first_name": "Riley",
                        "last_name": "Chen",
                        "birth_date": "1955-07-24",
                        "postal_code": "02140"
                    },
                    "via": [
                        "service_visit.client_id → client"
                    ]
                }
            ],
            "caregiver": [
                {
                    "key": {
                        "caregiver_id": 4
                    },
                    "snapshot": {
                        "caregiver_id": 4,
                        "display_name": "Casey Patel",
                        "license_code": "HHA-0004",
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "service_visit",
                    "key": {
                        "visit_id": 6
                    },
                    "field": "duration_minutes",
                    "value": 45
                }
            ],
            "examples": {
                "event_payload": "illustrative event_payload",
                "reason_code": "illustrative reason_code"
            }
        }
    }
]));
  await db.getCollection("visit_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("visit_events").find({"eventType":"visit_scheduled"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("visit_events").find({"source.key.visit_id":5}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("visit_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("visit_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("visit_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("visit_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("visit_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
