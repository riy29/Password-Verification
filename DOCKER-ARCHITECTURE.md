# Docker Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER'S MACHINE                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────┐        ┌──────────────────┐             │
│  │   Web Browser    │        │   SQL Manager    │             │
│  │  localhost:3000  │        │   localhost:1433 │             │
│  └────────┬─────────┘        └──────────────────┘             │
│           │                                                    │
│           │ HTTP                                               │
│           ▼                                                    │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │             Docker Desktop                               │ │
│  │  ┌──────────────────────────────────────────────────┐   │ │
│  │  │        AD-Network (Bridge)                       │   │ │
│  │  │                                                  │   │ │
│  │  │  ┌────────────────┐  ┌────────────────────┐    │   │ │
│  │  │  │   Frontend     │  │   Backend API      │    │   │ │
│  │  │  │   (Nginx)      │  │   (Node.js)        │    │   │ │
│  │  │  │                │  │                    │    │   │ │
│  │  │  │  :3000         │  │  :3001             │    │   │ │
│  │  │  │                │  │  ┌────────────────┤    │   │ │
│  │  │  │                │  │  │  Async OTP     │    │   │ │
│  │  │  │  ┌──────────┐  │  │  │  Service       │    │   │ │
│  │  │  │  │ React    │  │  │  │  - Speakeasy   │    │   │ │
│  │  │  │  │ App      │  │  │  └────────────────┤    │   │ │
│  │  │  │  └──────────┘  │  │                    │    │   │ │
│  │  │  │                │  │  ┌────────────────┤    │   │ │
│  │  │  │                │  │  │ AD Service     │    │   │ │
│  │  │  │                │  │  │ - LDAP/LDAPS   │    │   │ │
│  │  │  │                │  │  └────────────────┤    │   │ │
│  │  │  │  Proxy:        │  │                    │    │   │ │
│  │  │  │  /api/* ──────┐│  │                    │    │   │ │
│  │  │  │             ││  │  ┌────────────────┤    │   │ │
│  │  │  │             │└─►   │ Email Service  │    │   │ │
│  │  │  │                │  │ - Nodemailer   │    │   │ │
│  │  │  └────────────────┘  │ - SMTP         │    │   │ │
│  │  │                       └────────────────┤    │   │ │
│  │  │  ┌────────────────────┐                │    │   │ │
│  │  │  │  SQL Server        │  ┌────────────┤    │   │ │
│  │  │  │  (MSSQL 2019)      │  │ SMS Svc    │    │   │ │
│  │  │  │                    │  │ - Twilio   │    │   │ │
│  │  │  │  :1433 ◄───────────┼──┘            │    │   │ │
│  │  │  │                    │   ┌──────────┐    │   │ │
│  │  │  │ Databases:         │   │ Logger   │    │   │ │
│  │  │  │ - audit_logs       │   │ - Winston│    │   │ │
│  │  │  │ - password_resets  │   └──────────┘    │   │ │
│  │  │  │ - otp_sessions     │                    │   │ │
│  │  │  │ - user_answers     │                    │   │ │
│  │  │  │ - mfa_settings     │                    │   │ │
│  │  │  │                    │   ┌──────────────┐ │   │ │
│  │  │  │ Volumes:           │   │ JWT & Auth   │ │   │ │
│  │  │  │ - mssql_data       │   │ - bcryptjs   │ │   │ │
│  │  │  │   (persistent)     │   │ - jsonwt     │ │   │ │
│  │  │  │                    │   └──────────────┘ │   │ │
│  │  │  └────────────────────┘                    │   │ │
│  │  │                                            │   │ │
│  │  └─────────────────┬──────────────────────────┘   │ │
│  │                   │                               │ │
│  └───────────────────┼───────────────────────────────┘ │
│                      │                                 │
│  Exposed Ports:      │                                 │
│  - 3000 (Frontend)   │                                 │
│  - 3001 (Backend)    │                                 │
│  - 1433 (Database)   │                                 │
│                                                       │
└─────────────────────────────────────────────────────────────────┘
```

## Container Dependencies

```
    ┌─────────────────────────────┐
    │   Docker Compose Network    │
    └────────────────┬────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
    ┌────────┐  ┌────────┐  ┌──────────┐
    │Frontend│  │Backend │  │   MSSQL  │
    │:3000  │  │:3001   │  │ :1433    │
    └────────┘  └───┬────┘  └──────────┘
                    │
                    │
         ┌──────────┼──────────┐
         │          │          │
         ▼          ▼          ▼
      ┌──────┐  ┌──────┐  ┌────────┐
      │ LDAP │  │Email │  │Twilio  │
      │(ext) │  │(ext) │  │ (ext)  │
      └──────┘  └──────┘  └────────┘
```

## Data Flow

### Password Reset Flow

```
User Browser (Frontend)
    │
    ├─ 1. Initiate Reset ──► Backend API
    │                           │
    │                           ├─ 2. Verify in AD (LDAP)
    │                           │
    │                           ├─ 3. Generate OTP & Store in DB
    │                           │
    │                           └─ 4. Send via Email/SMS
    │
    ├─ 5. User receives OTP
    │
    ├─ 6. Verify OTP ──► Backend API
    │                       │
    │                       └─ 7. Check DB & Update Status
    │
    ├─ 8. Reset Password ──► Backend API
    │                           │
    │                           ├─ 9. Validate Password Strength
    │                           │
    │                           ├─ 10. Hash & Update in AD
    │                           │
    │                           └─ 11. Log Audit Event
    │
    └─ 12. Success Response ◄── Backend API
```

## Environment Isolation

### Development Setup
```
docker-compose.dev.yml
├─ Hot reload enabled
├─ Source code volumes
├─ Debug ports exposed
├─ Verbose logging
└─ Development passwords
```

### Production Setup
```
docker-compose.yml
├─ Multi-stage builds
├─ Optimized images
├─ No source volumes
├─ Health checks
├─ Security hardened
└─ Strong passwords
```

## Network Architecture

```
┌─────────────────────────────────────────┐
│      Host Machine Network                │
│  192.168.x.x                            │
└────────────────────┬────────────────────┘
                     │
                     │ :3000 (HTTP)
                     │ :3001 (HTTP)
                     │ :1433 (TCP)
                     │
┌────────────────────▼────────────────────┐
│   Docker Bridge Network: ad-network      │
│   Network: 172.20.0.0/16                │
│                                          │
│   ┌─────────────────────────────────┐  │
│   │  Frontend Container             │  │
│   │  IP: 172.20.0.2:3000           │  │
│   └──┬───────────────────────────┬──┘  │
│      │                           │      │
│      │ DNS: frontend             │      │
│      │                           │      │
│   ┌──▼──────────────────────────▼──┐  │
│   │  Backend Container              │  │
│   │  IP: 172.20.0.3:3001           │  │
│   └──┬──────────────────┬───────┬──┘  │
│      │                  │       │      │
│      │ DNS: backend     │       │      │
│      │                  │       │      │
│   ┌──▼───────────────┐  │       │      │
│   │ SQL Server       │  │       │      │
│   │ IP: 172.20.0.4   │  │       │      │
│   │ :1433            │  │       │      │
│   └──────────────────┘  │       │      │
│                         │       │      │
│                    External    │      │
│                    Services    │      │
│                    (Internet)  │      │
│                                │      │
│         SMTP ◄─────────────────┘      │
│         Twilio ◄────────────────────┘  │
└────────────────────────────────────────┘
```

## Volume Management

### Persistent Volumes

```
Host System                  Container
────────────────────────────────────────

mssql_data:
/var/lib/docker/
  volumes/
    mssql_data/      ◄────► /var/opt/mssql
      database files
      backups
      transaction logs
```

### Temporary Volumes

```
Container Memory
────────────────────────────────────────

Frontend:
  /app/node_modules   (installed dependencies)
  /app/build          (compiled React)

Backend:
  /app/node_modules   (installed dependencies)
  /app/dist           (compiled TypeScript)
```

## Security Layers

```
┌─────────────────────────────────────────┐
│  External Access Control                 │
│  - Firewall                              │
│  - Rate Limiting                         │
│  - HTTPS/TLS (Production)                │
└────────┬────────────────────────────────┘
         │
┌────────▼─────────────────────────────────┐
│  Container Network Security               │
│  - Isolated Bridge Network                │
│  - Service-to-Service Auth                │
│  - Environment Variable Secrets           │
└────────┬─────────────────────────────────┘
         │
┌────────▼─────────────────────────────────┐
│  Application Security                    │
│  - JWT Tokens                            │
│  - Password Hashing (bcryptjs)           │
│  - SQL Prepared Statements               │
│  - LDAP Connection Security              │
│  - OTP Time-Windows                      │
└────────┬─────────────────────────────────┘
         │
┌────────▼─────────────────────────────────┐
│  Database Security                       │
│  - User Permissions                      │
│  - Encrypted Connections                 │
│  - Audit Logging                         │
│  - Backups                               │
└─────────────────────────────────────────┘
```

## Deployment Scenarios

### Scenario 1: Local Development
```
docker-compose.dev.yml
├─ All services in one network
├─ Hot reload on file changes
├─ Direct localhost access
├─ Debug ports enabled
└─ Easy troubleshooting
```

### Scenario 2: Local Testing
```
docker-compose.yml
├─ Production-like configuration
├─ All services in one network
├─ Health checks enabled
├─ No source code volumes
└─ Simulates production
```

### Scenario 3: Staging
```
Multiple docker-compose files
├─ Separate frontend/backend networks
├─ Load balancer (Traefik/nginx)
├─ SSL certificates
├─ Environment configuration
└─ Database backups
```

### Scenario 4: Production (Cloud)
```
Kubernetes / Docker Swarm
├─ Distributed across nodes
├─ High availability
├─ Auto-scaling
├─ Service mesh (Istio)
├─ Centralized logging
├─ Monitoring & alerting
└─ Disaster recovery
```

## Performance Characteristics

```
Container          Memory    CPU    Network
────────────────────────────────────────────
Frontend (Nginx)   ~50MB     Low    Medium
Backend (Node.js)  ~200MB    Medium Medium
SQL Server         ~512MB    Medium Low
────────────────────────────────────────────
Total              ~762MB    Medium Medium
```

## Recovery Scenarios

```
Failure Mode        Action                Recovery Time
─────────────────────────────────────────────────────────
Container Crash     Auto-restart          < 5 seconds
Database Down       Restore from backup   < 2 minutes
Network Issue       Reconnect via DNS     < 10 seconds
Disk Full           Cleanup & restart     < 5 minutes
Memory Leak         Container restart     < 5 seconds
```

---

This architecture provides:
✓ Isolation & Security
✓ Easy Development
✓ Simple Deployment
✓ Scalability Path
✓ High Availability (with orchestration)
