Perfect! Here are the **step-by-step instructions** to deploy your EASNA API to Google Cloud Run:

## **🚀 Google Cloud Run Deployment Steps**

### **1. Install Google Cloud CLI**
```bash
# Download and install
curl https://sdk.cloud.google.com | bash

# Restart terminal or run:
exec -l $SHELL

# Verify installation
gcloud --version
```

### **2. Login and Set Project**
```bash
# Login to Google Cloud
gcloud auth login

# List your projects
gcloud projects list

# Set your project (replace with your project ID)
gcloud config set project YOUR_PROJECT_ID
```

### **3. Enable Required APIs**
```bash
# Enable Cloud Run API
gcloud services enable run.googleapis.com

# Enable Cloud Build API
gcloud services enable cloudbuild.googleapis.com
```

### **4. Create Dockerfile for Cloud Run**
Create `Dockerfile.cloudrun` in your `easna-api` directory:

### **5. Create .dockerignore**

### **6. Deploy to Cloud Run**
```bash
# Navigate to your easna-api directory
cd easna-api

# Deploy to Cloud Run
gcloud run deploy easna-api \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8080 \
  --memory 512Mi \
  --cpu 1 \
  --max-instances 10
```

### **7. Set Environment Variables**
```bash
# Set environment variables one by one
gcloud run services update easna-api \
  --region us-central1 \
  --set-env-vars NODE_ENV=production

gcloud run services update easna-api \
  --region us-central1 \
  --set-env-vars MONGODB_UR="your_mongodb_connection_string"

gcloud run services update easna-api \
  --region us-central1 \
  --set-env-vars ACCESS_TOKEN_SECRET="your_access_token_secret"

gcloud run services update easna-api \
  --region us-central1 \
  --set-env-vars REFRESH_TOKEN_SECRET="your_refresh_token_secret"

# Continue for all other environment variables...
```

### **8. Alternative: Set All Variables at Once**
Create a file called `env.yaml`:

Then deploy with environment variables:
```bash
gcloud run deploy easna-api \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8080 \
  --memory 512Mi \
  --cpu 1 \
  --max-instances 10 \
  --env-vars-file env.yaml
```

### **9. Get Your API URL**
```bash
# Get the service URL
gcloud run services describe easna-api \
  --region us-central1 \
  --format="value(status.url)"
```

### **10. Test Your API**
```bash
# Test the health endpoint
curl https://your-service-url/health

# Or test in browser
# Open: https://your-service-url/health
```

## **📋 Complete Deployment Commands**

```bash
# 1. Install Google Cloud CLI (if not already installed)
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# 2. Login and set project
gcloud auth login
gcloud config set project YOUR_PROJECT_ID

# 3. Enable APIs
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com

# 4. Navigate to your project
cd easna-api

# 5. Deploy (replace YOUR_VALUES in env.yaml first)
gcloud run deploy easna-api \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8080 \
  --memory 512Mi \
  --cpu 1 \
  --max-instances 10 \
  --env-vars-file env.yaml

# 6. Get your API URL
gcloud run services describe easna-api \
  --region us-central1 \
  --format="value(status.url)"
```

## **🔧 Important Notes**

### **1. Update env.yaml**
- Replace `your_mongodb_connection_string` with your actual MongoDB Atlas URI
- Replace `your_access_token_secret` with a strong secret
- Replace `your_refresh_token_secret` with another strong secret
- Update `FRONTEND_URL` with your frontend domain

### **2. MongoDB Atlas Setup**
- Create cluster at [mongodb.com](https://mongodb.com)
- Get connection string
- Add your IP to whitelist (or use 0.0.0.0/0 for Cloud Run)

### **3. Free Tier Limits**
- **2 million requests/month**
- **360,000 vCPU-seconds**
- **180,000 GiB-seconds memory**
- **1 GB network egress**

### **4. Custom Domain (Optional)**
```bash
# Map custom domain
gcloud run domain-mappings create \
  --service easna-api \
  --domain api.yourdomain.com \
  --region us-central1
```

**Your API will be live at: `https://easna-api-xxxxx-uc.a.run.app`**

Would you like me to help you with any specific part of this deployment?