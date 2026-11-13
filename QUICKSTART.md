# QUICK START GUIDE

## Getting Started with AD Password Manager

### 1. Backend Setup (5 minutes)

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Edit .env with your configuration
# - Active Directory server details
# - SQL Server connection
# - Email SMTP settings
# - Twilio SMS settings

# Start backend server
npm run dev
```

Backend will be available at `http://localhost:3001`

### 2. Frontend Setup (5 minutes)

```bash
# Navigate to frontend (in new terminal)
cd frontend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Start development server
npm start
```

Frontend will open at `http://localhost:3000`

### 3. Database Setup

1. Create SQL Server database `ad_password_manager`
2. Run the SQL script:
   ```bash
   # Using SQL Server Management Studio:
   # Open backend/database.sql and execute
   ```

### 4. Test the Application

1. Navigate to http://localhost:3000
2. Click "Password Reset"
3. Enter test credentials
4. Follow the reset workflow

## Configuration Checklist

- [ ] SQL Server instance running
- [ ] Active Directory credentials configured
- [ ] SMTP email settings configured
- [ ] Twilio account setup (optional, for SMS)
- [ ] Database schema initialized
- [ ] Backend environment variables set
- [ ] Frontend API URL configured

## Useful Commands

### Backend
```bash
npm run dev      # Start in development mode
npm run build    # Compile TypeScript
npm run start    # Run compiled version
npm run lint     # Check code style
npm test         # Run tests
```

### Frontend
```bash
npm start        # Start dev server
npm run build    # Create production build
npm test         # Run tests
npm run eject    # Eject from create-react-app (irreversible)
```

## Troubleshooting

### Backend won't start
- Check if port 3001 is available
- Verify Node.js version (16+)
- Run `npm install` again
- Check .env file configuration

### Frontend won't connect to backend
- Ensure backend is running on port 3001
- Check REACT_APP_API_URL in .env
- Verify CORS settings in backend config
- Check browser console for errors

### Database connection fails
- Verify SQL Server is running
- Check connection string in .env
- Ensure database exists
- Verify user permissions

## Next Steps

1. Read [README.md](README.md) for complete documentation
2. Review [.github/copilot-instructions.md](.github/copilot-instructions.md) for code guidelines
3. Check [backend/database.sql](backend/database.sql) for schema details
4. Explore backend controllers for API implementation details

## File Structure Overview

```
PMP/
├── backend/              # REST API
│   ├── src/
│   │   ├── config/       # Database & configuration
│   │   ├── controllers/  # Route handlers
│   │   ├── services/     # Business logic
│   │   ├── middleware/   # Auth & error handling
│   │   └── server.ts     # Entry point
│   └── database.sql      # Database schema
│
├── frontend/             # React UI
│   ├── src/
│   │   ├── components/   # Reusable components
│   │   ├── pages/        # Page layouts
│   │   ├── services/     # API integration
│   │   └── App.tsx       # Main app
│   └── tailwind.config.js
│
├── README.md             # Full documentation
└── QUICKSTART.md         # This file
```

## Key Features

✅ **Password Reset** - Email/SMS verification
✅ **Account Unlock** - Multi-factor verification
✅ **OTP Authentication** - Email or SMS delivery
✅ **Security Questions** - Customizable verification
✅ **Audit Logging** - Complete action history
✅ **Rich UI** - Modern React interface
✅ **Enterprise Ready** - Production-grade security

## Support

For issues or questions:
1. Check [README.md](README.md) troubleshooting section
2. Review environment variable configuration
3. Check application logs
4. Contact your IT administrator

## Production Deployment

Before deploying to production:
1. Set `NODE_ENV=production` in backend .env
2. Build frontend: `npm run build`
3. Configure HTTPS/SSL
4. Set strong JWT_SECRET
5. Enable rate limiting
6. Setup monitoring and logging
7. Configure automated backups
8. Test all authentication flows

---

**Happy password managing! 🔐**
