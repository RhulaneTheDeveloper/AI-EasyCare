# AI EasyCare API Documentation

## Base URL
```
http://localhost:8080/api
```

## Authentication
All endpoints (except `/auth/**`) require a JWT token in the Authorization header:
```
Authorization: Bearer <token>
```

## Endpoints

### Authentication

#### Register
```
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "firstName": "John",
  "lastName": "Doe",
  "role": "PATIENT"
}

Response: 201 Created
{
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe"
}
```

#### Login
```
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response: 200 OK
{
  "accessToken": "eyJhbGciOiJIUzUxMiJ9...",
  "tokenType": "Bearer",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe"
}
```

### Medications

#### Get All Medications
```
GET /api/medications

Response: 200 OK
[
  {
    "id": 1,
    "medicationName": "Aspirin",
    "dosage": "500mg",
    "frequency": "Once daily",
    "reminderTime": "09:00",
    "isActive": true
  }
]
```

#### Add Medication
```
POST /api/medications
Content-Type: application/json

{
  "medicationName": "Aspirin",
  "dosage": "500mg",
  "frequency": "Once daily",
  "reminderTime": "09:00",
  "description": "Take with food"
}

Response: 201 Created
```

#### Update Medication
```
PUT /api/medications/{id}
Content-Type: application/json

{
  "medicationName": "Aspirin",
  "dosage": "500mg",
  "frequency": "Twice daily",
  "reminderTime": "09:00",
  "isActive": true
}

Response: 200 OK
```

#### Delete Medication
```
DELETE /api/medications/{id}

Response: 204 No Content
```

### Medication History

#### Get Medication History
```
GET /api/medications/{medicationId}/history

Response: 200 OK
[
  {
    "id": 1,
    "medicationId": 1,
    "status": "TAKEN",
    "scheduledTime": "2024-06-23T09:00:00",
    "takenTime": "2024-06-23T09:15:00",
    "notes": "Taken after breakfast"
  }
]
```

#### Record Medication Taken
```
POST /api/medications/{medicationId}/history
Content-Type: application/json

{
  "status": "TAKEN",
  "takenTime": "2024-06-23T09:15:00",
  "notes": "Taken after breakfast"
}

Response: 201 Created
```

### Caregiver Monitoring

#### Add Patient to Monitor
```
POST /api/caregiver/patients
Content-Type: application/json

{
  "patientId": 2
}

Response: 201 Created
```

#### Get Monitored Patients
```
GET /api/caregiver/patients

Response: 200 OK
[
  {
    "id": 2,
    "email": "patient@example.com",
    "firstName": "Jane",
    "lastName": "Doe"
  }
]
```

## Error Responses

### 400 Bad Request
```json
{
  "status": 400,
  "error": "Bad Request",
  "message": "Invalid input parameters"
}
```

### 401 Unauthorized
```json
{
  "status": 401,
  "error": "Unauthorized",
  "message": "Invalid or expired token"
}
```

### 404 Not Found
```json
{
  "status": 404,
  "error": "Not Found",
  "message": "Resource not found"
}
```

### 500 Internal Server Error
```json
{
  "status": 500,
  "error": "Internal Server Error",
  "message": "An unexpected error occurred"
}
```
