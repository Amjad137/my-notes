Here's how to set up a pnpm store in `D:\Program Files` with admin permissions:

## Step 1: Create the Directory with Admin Rights

**Run Command Prompt as Administrator:**
```cmd
mkdir "D:\Program Files\pnpm-store"
```

## Step 2: Set Permissions for the Directory

**In the same admin Command Prompt:**
```cmd
# Give full control to your user account
icacls "D:\Program Files\pnpm-store" /grant "%USERNAME%":F /T

# Give full control to administrators group
icacls "D:\Program Files\pnpm-store" /grant "Administrators":F /T

# Optional: Give read/write to all users
icacls "D:\Program Files\pnpm-store" /grant "Users":M /T
```

## Step 3: Configure pnpm to Use This Store

**In your regular terminal (Git Bash):**
```bash
pnpm config set store-dir "D:\Program Files\pnpm-store"
```

## Step 4: Verify the Configuration

```bash
pnpm config get store-dir
# Should show: D:\Program Files\pnpm-store
```

## Step 5: Test Installation

```bash
cd /d/Amjath/My\ Projects/WEB\ Projects/Unwir/labtwofour/dq_new
pnpm install
```

## Alternative: PowerShell Method (if cmd doesn't work)

**Run PowerShell as Administrator:**
```powershell
# Create directory
New-Item -Path "D:\Program Files\pnpm-store" -ItemType Directory -Force

# Set permissions
$acl = Get-Acl "D:\Program Files\pnpm-store"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($env:USERNAME,"FullControl","ContainerInherit,ObjectInherit","None","Allow")
$acl.SetAccessRule($accessRule)
Set-Acl "D:\Program Files\pnpm-store" $acl
```

This setup will give you a permanent, properly permissioned pnpm store location that should resolve the EPERM errors.
