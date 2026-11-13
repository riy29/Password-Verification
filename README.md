# Active Directory Password Manager

A comprehensive, enterprise-grade web-based password management tool for Active Directory with support for password reset, account unlock, and multi-factor authentication using OTP and security questions.

## Features

✅ **Password Reset** - Secure password reset with multiple authentication methods
✅ **Account Unlock** - Quick account unlock with verification
✅ **Email OTP** - One-time password via email
✅ **SMS OTP** - One-time password via SMS (Twilio)
✅ **Security Questions** - Custom security question verification
✅ **Multi-Factor Authentication** - Layered security approach
✅ **Audit Logging** - Complete action audit trail
✅ **Rich UI** - Modern, user-friendly interface
✅ **Enterprise Security** - Industry-standard encryption

## Project Structure

```
PMP/
├── backend/                    # Node.js Express API
│   ├── src/
│   │   ├── config/            # Configuration files
│   │   ├── controllers/       # Route controllers
│   │   ├── services/          # Business logic
│   │   ├── middleware/        # Express middleware
│   │   ├── models/            # Data models
│   │   ├── utils/             # Utility functions
│   │   └── server.ts          # Entry point
│   ├── database.sql           # SQL schema
│   └── package.json
│
├── frontend/                   # React TypeScript UI
│   ├── src/
│   │   ├── components/        # Reusable components
│   │   ├── pages/             # Page components
│   │   ├── services/          # API client
│   │   ├── store/             # State management
│   │   ├── styles/            # Global styles
│   │   ├── App.tsx
│   │   └── index.tsx
│   ├── public/
│   ├── tailwind.config.js
│   └── package.json
│
└── .github/
    └── copilot-instructions.md
```

## Tech Stack

### Backend
- **Framework**: Node.js + Express.js
- **Language**: TypeScript
- **Database**: SQL Server / MSSQL
- **Authentication**: JWT
- **Email**: Nodemailer
- **SMS**: Twilio
- **OTP**: Speakeasy
- **Security**: BCryptJS, Helmet

### Frontend
- **Framework**: React 18
- **Language**: TypeScript
- **State**: Zustand
- **Styling**: Tailwind CSS
- **HTTP Client**: Axios
- **Notifications**: React Hot Toast
- **Icons**: Lucide React, React Icons

## Installation

### Prerequisites
- Node.js 16+
- SQL Server 2019+ (or Azure SQL Database)
- Twilio Account (for SMS OTP)
- SMTP Server Access (for Email OTP)

### Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file from `.env.example`:
```bash
cp .env.example .env
```

4. Configure environment variables in `.env`:
```env
PORT=3001
AD_URL=ldap://your-ad-server.com
AD_BASE_DN=dc=company,dc=com
AD_ADMIN_USER=admin@company.com
AD_ADMIN_PASSWORD=your_password

JWT_SECRET=your_jwt_secret
SMTP_HOST=smtp.gmail.com
TWILIO_ACCOUNT_SID=your_twilio_sid
```

5. Setup database schema:
```bash
# Run database.sql in your SQL Server Management Studio or
# Using sqlcmd:
sqlcmd -S your_server -U sa -P your_password -i database.sql
```

6. Start the server:
```bash
npm run dev
```

Server runs on `http://localhost:3001`

### Frontend Setup

1. Navigate to frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file from `.env.example`:
```bash
cp .env.example .env
```

4. Configure API URL if different:
```env
REACT_APP_API_URL=http://localhost:3001/api
```

5. Start the development server:
```bash
npm start
```

Application runs on `http://localhost:3000`

## API Endpoints

### Password Management
- `POST /api/password/initiate-reset` - Initiate password reset
- `POST /api/password/reset` - Reset password with verification
- `POST /api/account/unlock` - Unlock user account

### OTP Management
- `POST /api/otp/request` - Request OTP (email/SMS)
- `POST /api/otp/verify` - Verify OTP code

### Security Questions
- `GET /api/security/questions` - Get security questions
- `POST /api/security/verify-answers` - Verify security answers
- `POST /api/security/setup` - Setup user security questions

## Authentication Flow

### Password Reset Flow
1. User enters username and email
2. System verifies user existence in AD
3. System sends verification code (email/SMS)
4. User verifies identity with security questions or OTP
5. User sets new password
6. Password updated in Active Directory

### Account Unlock Flow
1. User initiates unlock request
2. System verifies user identity
3. Verification via email OTP or security questions
4. Account unlocked in Active Directory
5. Confirmation sent to registered email

## Security Features

✓ **Password Encryption** - BCryptJS with salt rounds
✓ **JWT Tokens** - Secure session management
✓ **OTP Validation** - Time-based TOTP with window verification
✓ **Rate Limiting** - Prevent brute force attacks
✓ **Audit Logging** - Track all actions with timestamp and IP
✓ **HTTPS** - SSL/TLS encryption support
✓ **Helmet** - HTTP security headers
✓ **Input Validation** - Express validator for all inputs
✓ **CORS** - Configurable cross-origin requests

## Configuration

### Active Directory Integration

The application uses LDAP/LDAPS to connect to Active Directory:

```typescript
// src/config/config.ts
ad: {
  url: 'ldap://your-ad-server.com',
  baseDN: 'dc=company,dc=com',
  adminUser: 'admin@company.com',
  adminPassword: 'password'
}
```

### Email Configuration

Configure SMTP for password reset emails:

```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=app-password
```

### SMS Configuration

Setup Twilio for OTP delivery:

```env
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=+1234567890
```

## Database Schema

The application includes tables for:
- `audit_logs` - Action audit trail
- `password_reset_sessions` - Reset session management
- `otp_sessions` - OTP verification tracking
- `security_questions` - Predefined security questions
- `user_security_answers` - User-specific answers
- `mfa_settings` - Multi-factor authentication settings

## Customization

### Adding Security Questions

Edit `backend/database.sql` to add custom questions:

```sql
INSERT INTO security_questions (questionId, question, isActive)
VALUES (NEWID(), 'Your custom question?', 1)
```

### Styling

Frontend uses Tailwind CSS. Customize theme in:
- `frontend/tailwind.config.js` - Theme configuration
- `frontend/src/styles/globals.css` - Global styles

### API Response Format

All API responses follow consistent format:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

## Error Handling

- **400** - Bad Request (validation errors)
- **401** - Unauthorized (auth required)
- **404** - Not Found (user not found)
- **500** - Server Error

## Logging

Backend logs all significant actions:
- User authentication attempts
- Password resets
- Account unlocks
- OTP generation and verification
- Failed operations

## Monitoring

Monitor application health:
- `GET /api/health` - Health check endpoint
- Database audit logs for compliance
- Application logs in console/file

## Troubleshooting

### Connection Issues
- Verify AD server URL and credentials
- Check firewall rules for LDAP port (389/636)
- Test LDAP connectivity using ldp.exe

### Email Not Sending
- Verify SMTP credentials
- Check CORS settings for frontend
- Enable "Less secure app access" if using Gmail

### SMS OTP Not Working
- Verify Twilio account is active
- Check phone number format (E.164)
- Verify Twilio phone number configuration

## Production Deployment

### Backend Deployment

1. Build TypeScript:
```bash
npm run build
```

2. Set production environment variables
3. Use process manager (PM2, systemd)
4. Enable HTTPS/SSL
5. Configure firewall
6. Setup log rotation

### Frontend Deployment

1. Build production bundle:
```bash
npm run build
```

2. Deploy to CDN (AWS S3, Azure Blob, etc.)
3. Configure web server (nginx, IIS)
4. Enable compression and caching
5. Setup HTTPS
6. Configure CORS headers

## License

MIT License

## Support

For issues or questions, contact your IT administrator.

## Version

- Current Version: 1.0.0
- Last Updated: May 2024
