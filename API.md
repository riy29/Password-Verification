# API Endpoints Documentation

## Base URL
```
http://localhost:3001/api
```

## Password Management

### 1. Initiate Password Reset
Reset a user's password by initiating the reset process.

**Endpoint:** `POST /password/initiate-reset`

**Request Body:**
```json
{
  "username": "john.doe",
  "email": "john.doe@company.com",
  "method": "email" // or "sms", "securityQuestions"
}
```

**Response (Success - 200):**
```json
{
  "message": "Password reset email sent",
  "sessionId": "uuid-here",
  "requiresOTP": true
}
```

**Response (Error - 400/404/500):**
```json
{
  "error": "Error description"
}
```

### 2. Reset Password
Complete the password reset process with new password.

**Endpoint:** `POST /password/reset`

**Request Body:**
```json
{
  "sessionId": "uuid-from-initiate",
  "newPassword": "NewP@ssw0rd123",
  "confirmPassword": "NewP@ssw0rd123"
}
```

**Response (Success - 200):**
```json
{
  "message": "Password reset successfully",
  "success": true
}
```

**Password Requirements:**
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- At least one special character

### 3. Unlock Account
Unlock a locked Active Directory account.

**Endpoint:** `POST /account/unlock`

**Request Body:**
```json
{
  "username": "john.doe",
  "email": "john.doe@company.com"
}
```

**Response (Success - 200):**
```json
{
  "message": "Account unlocked successfully",
  "success": true
}
```

## OTP Management

### 1. Request OTP
Send a one-time password via email or SMS.

**Endpoint:** `POST /otp/request`

**Request Body:**
```json
{
  "username": "john.doe",
  "email": "john.doe@company.com",
  "phoneNumber": "+12025551234",
  "method": "email" // or "sms"
}
```

**Response (Success - 200):**
```json
{
  "message": "OTP sent via email",
  "otpId": "uuid-here",
  "expiresIn": 300
}
```

### 2. Verify OTP
Verify the OTP code sent to user.

**Endpoint:** `POST /otp/verify`

**Request Body:**
```json
{
  "otpId": "uuid-from-request",
  "otp": "123456"
}
```

**Response (Success - 200):**
```json
{
  "message": "OTP verified successfully",
  "username": "john.doe",
  "verified": true
}
```

**OTP Rules:**
- Valid for 5 minutes (300 seconds)
- 6-digit numeric code
- Single use only

## Security Questions

### 1. Get Available Security Questions
Retrieve all available security questions.

**Endpoint:** `GET /security/questions`

**Response (Success - 200):**
```json
{
  "questions": [
    {
      "questionId": "uuid-1",
      "question": "What is your mother's maiden name?"
    },
    {
      "questionId": "uuid-2",
      "question": "What was the name of your first pet?"
    }
  ]
}
```

### 2. Verify Security Answers
Verify user's answers to security questions.

**Endpoint:** `POST /security/verify-answers`

**Request Body:**
```json
{
  "username": "john.doe",
  "answers": [
    {
      "questionId": "uuid-1",
      "answer": "Smith"
    },
    {
      "questionId": "uuid-2",
      "answer": "Fluffy"
    }
  ]
}
```

**Response (Success - 200):**
```json
{
  "message": "Security answers verified successfully",
  "verified": true
}
```

**Response (Error - 400):**
```json
{
  "error": "Security answers are incorrect"
}
```

### 3. Setup Security Questions
Setup or update user's security questions and answers.

**Endpoint:** `POST /security/setup`

**Request Body:**
```json
{
  "username": "john.doe",
  "answers": [
    {
      "questionId": "uuid-1",
      "answer": "Smith"
    },
    {
      "questionId": "uuid-2",
      "answer": "Fluffy"
    }
  ]
}
```

**Response (Success - 200):**
```json
{
  "message": "Security questions set up successfully"
}
```

## Health Check

### Check API Status
**Endpoint:** `GET /api/health`

**Response:**
```json
{
  "status": "AD Password Manager API is running"
}
```

## Error Codes

| Code | Meaning | Solution |
|------|---------|----------|
| 400 | Bad Request | Check request parameters |
| 401 | Unauthorized | Missing or invalid authentication |
| 404 | Not Found | Resource or user not found |
| 500 | Server Error | Contact support |

## Rate Limiting

To prevent abuse:
- OTP requests: 3 per hour per username
- Password resets: 5 per day per username
- Failed OTP attempts: 5 before lockout

## Response Format

All API responses follow this format:

**Success (2xx):**
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { /* response data */ }
}
```

**Error (4xx/5xx):**
```json
{
  "error": "Error message",
  "code": "ERROR_CODE",
  "details": "Additional details if available"
}
```

## Authentication Headers

For protected endpoints requiring authentication:

```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

## CORS Configuration

Allowed origins (configurable in `.env`):
```
CORS_ORIGIN=http://localhost:3000
```

## Example Flow

### Complete Password Reset Flow

1. **Initiate Reset:**
   ```bash
   POST /api/password/initiate-reset
   {
     "username": "john.doe",
     "email": "john.doe@company.com",
     "method": "email"
   }
   ```
   Response: Gets `sessionId`

2. **Request OTP:**
   ```bash
   POST /api/otp/request
   {
     "username": "john.doe",
     "email": "john.doe@company.com",
     "method": "email"
   }
   ```
   Response: Gets `otpId`

3. **Verify OTP:**
   ```bash
   POST /api/otp/verify
   {
     "otpId": "...",
     "otp": "123456"
   }
   ```

4. **Reset Password:**
   ```bash
   POST /api/password/reset
   {
     "sessionId": "...",
     "newPassword": "NewP@ssw0rd123",
     "confirmPassword": "NewP@ssw0rd123"
   }
   ```
   Response: Success message

## Testing with cURL

```bash
# Initiate password reset
curl -X POST http://localhost:3001/api/password/initiate-reset \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john.doe",
    "email": "john.doe@company.com",
    "method": "email"
  }'

# Request OTP
curl -X POST http://localhost:3001/api/otp/request \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john.doe",
    "email": "john.doe@company.com",
    "method": "email"
  }'
```

## Testing with Postman

1. Create new collection "AD Password Manager"
2. Create requests for each endpoint
3. Save environment variables for reuse
4. Use Pre-request Scripts for dynamic values
5. Test complete flows

## Additional Resources

- [Express.js Documentation](https://expressjs.com)
- [REST API Best Practices](https://restfulapi.net/)
- [HTTP Status Codes](https://httpwg.org/specs/rfc7231.html)
