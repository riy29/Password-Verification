# Project Structure - Complete

```
PMP/                                          # Root directory
│
├── 📄 README.md                             # Project overview & documentation
├── 📄 QUICKSTART.md                         # Quick start guide
├── 📄 API.md                                # API endpoint documentation
├── 📄 AD-IMPLEMENTATION.md                  # Active Directory integration guide
├── 📄 .gitignore                            # Git ignore rules
│
├── 🐳 DOCKER FILES & COMPOSE
│   ├── 📄 DOCKER.md                         # Complete Docker guide
│   ├── 📄 DOCKER-ARCHITECTURE.md            # Architecture diagrams
│   ├── 📄 DOCKER-QUICK-REF.md              # Quick reference
│   ├── 📄 DOCKER-SETUP-SUMMARY.md          # Setup summary
│   ├── docker-compose.yml                   # Production compose
│   ├── docker-compose.dev.yml              # Development compose
│   ├── docker-setup.bat                     # Windows setup script
│   ├── docker-setup.sh                      # Linux/Mac setup script
│   ├── docker-manager.bat                   # Windows manager menu
│   └── docker-manager.sh                    # Linux/Mac manager menu
│
├── 📁 .github/
│   └── copilot-instructions.md              # Copilot customization
│
├── 📁 backend/                              # Backend API
│   │
│   ├── 🐳 Docker Files
│   │   ├── Dockerfile                       # Production image
│   │   ├── Dockerfile.dev                   # Development image
│   │   └── .dockerignore                    # Docker ignore
│   │
│   ├── package.json                         # Dependencies
│   ├── tsconfig.json                        # TypeScript config
│   ├── .env.example                         # Environment example
│   ├── database.sql                         # Database schema
│   ├── README.md                            # Backend README
│   │
│   └── 📁 src/                              # Source code
│       ├── server.ts                        # Entry point
│       │
│       ├── 📁 config/
│       │   ├── config.ts                    # Configuration
│       │   └── database.ts                  # Database connection
│       │
│       ├── 📁 controllers/
│       │   ├── passwordController.ts        # Password management
│       │   ├── otpController.ts             # OTP handling
│       │   └── securityController.ts        # Security questions
│       │
│       ├── 📁 services/
│       │   ├── adService.ts                 # AD/LDAP integration
│       │   ├── emailService.ts              # Email sending
│       │   ├── smsService.ts                # SMS via Twilio
│       │   └── auditService.ts              # Audit logging
│       │
│       ├── 📁 middleware/
│       │   └── auth.ts                      # Auth & error handling
│       │
│       ├── 📁 routes/
│       │   └── index.ts                     # API routes
│       │
│       ├── 📁 models/
│       │   └── (TypeScript types)           # Data models
│       │
│       └── 📁 utils/
│           ├── otp.ts                       # OTP utilities
│           └── auth.ts                      # Auth utilities
│
├── 📁 frontend/                             # Frontend UI
│   │
│   ├── 🐳 Docker Files
│   │   ├── Dockerfile                       # Production image (Nginx)
│   │   ├── Dockerfile.dev                   # Development image
│   │   ├── nginx.conf                       # Nginx configuration
│   │   └── .dockerignore                    # Docker ignore
│   │
│   ├── package.json                         # Dependencies
│   ├── tsconfig.json                        # TypeScript config
│   ├── tailwind.config.js                   # Tailwind config
│   ├── postcss.config.js                    # PostCSS config
│   ├── .env.example                         # Environment example
│   │
│   └── 📁 src/                              # Source code
│       ├── index.tsx                        # React entry
│       ├── App.tsx                          # Main App component
│       │
│       ├── 📁 components/                   # Reusable components
│       │   ├── FeatureCard.tsx              # Feature display
│       │   ├── OTPInput.tsx                 # OTP input form
│       │   ├── SecurityQuestions.tsx        # Security Q&A
│       │   └── PasswordResetForm.tsx        # Password reset form
│       │
│       ├── 📁 pages/                        # Page components
│       │   ├── HomePage.tsx                 # Home page
│       │   └── PasswordResetPage.tsx        # Reset page
│       │
│       ├── 📁 services/
│       │   └── api.ts                       # API client
│       │
│       ├── 📁 store/
│       │   └── auth.ts                      # Zustand stores
│       │
│       ├── 📁 styles/
│       │   └── globals.css                  # Global styles
│       │
│       ├── 📁 hooks/                        # Custom hooks
│       │
│       └── 📁 public/
│           └── index.html                   # HTML template
│
├── 📁 backup/                               # Backups (auto-created)
│   └── (database backups)
│
└── .env                                     # Environment config (auto-created)


## Technology Stack by Directory

### Backend (Node.js)
```
backend/src/
├── Express.js (Web Framework)
├── TypeScript (Language)
├── MSSQL (Database Driver)
├── JWT (Authentication)
├── Nodemailer (Email)
├── Twilio (SMS)
├── Speakeasy (OTP)
├── BCryptJS (Password Hashing)
└── Helmet (Security)
```

### Frontend (React)
```
frontend/src/
├── React 18 (UI Framework)
├── TypeScript (Language)
├── Tailwind CSS (Styling)
├── Zustand (State Management)
├── Axios (HTTP Client)
├── React Hot Toast (Notifications)
├── Lucide React (Icons)
└── Framer Motion (Animations)
```

### Database (SQL Server)
```
database.sql
├── audit_logs (Action tracking)
├── password_reset_sessions (Reset tracking)
├── otp_sessions (OTP validation)
├── security_questions (Q&A questions)
├── user_security_answers (User answers)
└── mfa_settings (MFA configuration)
```

### Docker Architecture
```
docker-compose.yml
├── Frontend Service (Nginx)
├── Backend Service (Node.js)
├── Database Service (SQL Server)
├── ad-network (Internal Network)
└── mssql_data (Persistent Volume)
```


## File Categories

### Configuration Files
- `package.json` (Dependencies)
- `tsconfig.json` (TypeScript)
- `docker-compose.yml` (Docker)
- `tailwind.config.js` (CSS)
- `.env` (Environment)
- `.gitignore` (Git)

### Documentation Files
- `README.md` (Overview)
- `QUICKSTART.md` (Getting Started)
- `API.md` (API Reference)
- `DOCKER.md` (Docker Guide)
- `DOCKER-ARCHITECTURE.md` (Architecture)
- `DOCKER-QUICK-REF.md` (Quick Ref)
- `AD-IMPLEMENTATION.md` (AD Integration)

### Docker Files
- `Dockerfile` (Production Image)
- `Dockerfile.dev` (Development Image)
- `docker-compose.yml` (Orchestration)
- `nginx.conf` (Nginx Config)
- `.dockerignore` (Build Context)

### Source Code
- `*.ts` (TypeScript Backend)
- `*.tsx` (React Components)
- `*.sql` (Database Schema)
- `*.css` (Styles)

### Helper Scripts
- `docker-setup.bat` (Windows Setup)
- `docker-setup.sh` (Linux/Mac Setup)
- `docker-manager.bat` (Windows Manager)
- `docker-manager.sh` (Linux/Mac Manager)


## Environment-Specific Files

### Development Environment
- `docker-compose.dev.yml`
- `backend/Dockerfile.dev`
- `frontend/Dockerfile.dev`
- Hot reload enabled
- Source volumes mounted
- Debug ports available

### Production Environment
- `docker-compose.yml`
- `backend/Dockerfile`
- `frontend/Dockerfile`
- Optimized builds
- Health checks
- Security hardened


## Database Schema

```sql
ad_password_manager
├── audit_logs
│   ├── logId (PK)
│   ├── action
│   ├── username
│   ├── ipAddress
│   ├── details
│   ├── success
│   └── timestamp
│
├── password_reset_sessions
│   ├── sessionId (PK)
│   ├── username
│   ├── resetToken
│   ├── method
│   ├── createdAt
│   ├── expiresAt
│   └── isUsed
│
├── otp_sessions
│   ├── otpId (PK)
│   ├── username
│   ├── otp
│   ├── method
│   ├── expiryTime
│   ├── createdAt
│   └── isUsed
│
├── security_questions
│   ├── questionId (PK)
│   ├── question
│   ├── isActive
│   └── createdAt
│
├── user_security_answers
│   ├── answerId (PK)
│   ├── username
│   ├── questionId (FK)
│   ├── answer
│   └── createdAt
│
└── mfa_settings
    ├── settingId (PK)
    ├── username (UNIQUE)
    ├── mfaEnabled
    ├── method
    ├── secret
    ├── backupCodes
    ├── createdAt
    └── updatedAt
```


## API Endpoints Structure

```
/api
├── /password
│   ├── POST /initiate-reset
│   ├── POST /reset
│   └── POST /account/unlock
│
├── /otp
│   ├── POST /request
│   └── POST /verify
│
└── /security
    ├── GET /questions
    ├── POST /verify-answers
    └── POST /setup
```


## Container Relationships

```
┌──────────────┐
│   Frontend   │
│   :3000      │
└──────┬───────┘
       │ API calls via Nginx proxy
       │
┌──────▼────────────────────┐
│   Backend API             │
│   :3001                   │
└──────┬────────────┬───────┘
       │            │
    Queries      External
       │          Services
       │          (SMTP,
┌──────▼────┐      Twilio,
│   MSSQL   │       LDAP)
│  :1433    │
└───────────┘
```


## Build Process

### Backend Build
```
Dockerfile
├── Layer 1: Node 18 Alpine (builder)
│   ├── Copy package.json
│   ├── npm ci
│   ├── Copy src/
│   └── npm run build → dist/
│
└── Layer 2: Node 18 Alpine (production)
    ├── npm ci --only=production
    ├── Copy dist/ from builder
    ├── Create non-root user
    └── ENTRYPOINT: node dist/server.js
```

### Frontend Build
```
Dockerfile
├── Layer 1: Node 18 Alpine (builder)
│   ├── Copy package.json
│   ├── npm ci
│   ├── Copy src/
│   └── npm run build → build/
│
└── Layer 2: Nginx Alpine (production)
    ├── Copy build/ from builder
    ├── Copy nginx.conf
    └── ENTRYPOINT: nginx -g daemon off
```


## Directory Size Overview

```
backend/
  src/          ~200 KB   (TypeScript code)
  dist/         ~500 KB   (Compiled JS)
  node_modules/ ~400 MB   (Dependencies)

frontend/
  src/          ~150 KB   (React code)
  build/        ~1 MB     (Compiled React)
  node_modules/ ~500 MB   (Dependencies)

Total (with node_modules): ~900 MB

Docker Images:
  backend:      ~350 MB
  frontend:     ~100 MB
  mssql:        ~400 MB
  ────────────────────
  Total:        ~850 MB
```


## Quick Navigation

| Need | File | Purpose |
|------|------|---------|
| Quick start | QUICKSTART.md | Get running in 5 min |
| Docker help | DOCKER-QUICK-REF.md | Common Docker commands |
| Full guide | DOCKER.md | Complete reference |
| Architecture | DOCKER-ARCHITECTURE.md | How it works |
| API docs | API.md | Endpoint reference |
| Setup | docker-setup.bat/sh | Initialize environment |
| Manager | docker-manager.bat/sh | Interactive menu |
| Config | .env | Environment variables |
| Backend | backend/src/ | Node.js code |
| Frontend | frontend/src/ | React code |
| Database | backend/database.sql | SQL schema |

---

**Total Files**: 80+  
**Total Directories**: 30+  
**Lines of Code**: 5000+  
**Documentation**: 300+ KB
