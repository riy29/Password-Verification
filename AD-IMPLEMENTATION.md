node-adm-examples
===================

This project uses node-adm (or similar LDAP library) for Active Directory integration.

## Implementation Notes

The backend includes placeholder implementations for AD integration. To fully implement Active Directory support:

### Option 1: Using `adm` Library
```typescript
import ADM from 'adm';

const ad = new ADM({
  url: process.env.AD_URL,
  baseDN: process.env.AD_BASE_DN,
  username: process.env.AD_ADMIN_USER,
  password: process.env.AD_ADMIN_PASSWORD
});

// Authenticate user
const user = await ad.authenticate(username, password);

// Get user details
const userDetails = await ad.user(username).fetch();

// Reset password
await ad.user(username).password(newPassword);

// Unlock account
await ad.user(username).unlock();
```

### Option 2: Using `ldapjs` Library
```typescript
import ldap from 'ldapjs';

const client = ldap.createClient({
  url: process.env.AD_URL
});

// Bind with admin credentials
client.bind(adminDN, adminPassword, (err) => {
  // Handle binding
});

// Search for users
client.search(baseDN, options, (err, res) => {
  // Handle search results
});
```

### Option 3: Using `activedirectory2` Library
```typescript
import ActiveDirectory from 'activedirectory2';

const ad = new ActiveDirectory({
  url: process.env.AD_URL,
  baseDN: process.env.AD_BASE_DN,
  username: process.env.AD_ADMIN_USER,
  password: process.env.AD_ADMIN_PASSWORD
});

// Get user
ad.getUser(username, (err, user) => {
  // Handle user data
});
```

## Installation

Choose and install one of the AD libraries:

```bash
# Option 1
npm install adm

# Option 2
npm install ldapjs

# Option 3
npm install activedirectory2
```

## Current Implementation

The current implementation in `src/services/adService.ts` contains placeholder methods that need to be replaced with actual AD operations.

## Files to Modify

1. `backend/src/services/adService.ts` - Replace placeholder AD methods
2. `backend/src/controllers/passwordController.ts` - Verify AD integration
3. `backend/src/utils/auth.ts` - Enhanced security features

## Testing AD Integration

Create a test script:
```typescript
// tests/ad-connection.test.ts
import adService from '../src/services/adService';

async function testADConnection() {
  try {
    const user = await adService.getUserDetails('testuser');
    console.log('AD Connection successful', user);
  } catch (error) {
    console.error('AD Connection failed', error);
  }
}

testADConnection();
```

Run with:
```bash
npx ts-node tests/ad-connection.test.ts
```

## Security Considerations

- Never hardcode AD credentials
- Use service account with minimal permissions
- Enable SSL/TLS for LDAP connections
- Implement connection pooling
- Add timeout configurations
- Use dedicated AD replication domain controller
- Implement rate limiting on password changes
- Log all AD operations for audit trails

## Common Issues

### Connection Refused
- Verify AD server is accessible
- Check port 389 (LDAP) or 636 (LDAPS)
- Verify firewall rules
- Check network connectivity

### Authentication Failed
- Verify admin credentials
- Check account permissions
- Verify domain/baseDN format
- Check SSL certificate (if using LDAPS)

### Password Reset Not Working
- Verify service account has "Reset Password" permission
- Check password complexity requirements
- Verify account is not protected from deletion
- Check domain password policy

## Resources

- [adm Documentation](https://github.com/vdecree/node-adm)
- [ldapjs Documentation](https://ldapjs.org/)
- [activedirectory2 Documentation](https://github.com/gheeres/node-activedirectory)
- [Microsoft AD Scripting Guide](https://docs.microsoft.com/en-us/windows/win32/adsi/active-directory-service-interfaces-adsi)
