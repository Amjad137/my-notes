
## Config:
```typescript
//resend.config.ts

import { Resend } from 'resend';
import environment from './env.config';

const emailClient = new Resend(environment.resendApiKey);

export default emailClient;

```


## Env:
```env
RESEND_API_KEY="re_i8MgZb9k_5eJ8d4TgHqTL2cK8jTeksyuq"
ADMIN_EMAILS=unwirdev@gmail.com,sankhaja.unwir@gmail.com
```

## Template:
```typescript
import { AdminMerchantNotificationPayload } from '@/types/email.types';

export const generateAdminNotificationEmail = (
  data: AdminMerchantNotificationPayload,
  requestDate: string,
) => {
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>New Merchant Request</title>
  <style>
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: linear-gradient(to right, #9747FF, #1E40AF); padding: 20px; color: white; text-align: center; border-radius: 8px 8px 0 0; }
    .content { padding: 20px; background-color: #f9f9f9; border-radius: 0 0 8px 8px; }
    .section { margin-bottom: 20px; }
    .section-title { font-weight: bold; color: #1E40AF; border-bottom: 1px solid #ddd; padding-bottom: 5px; }
    .highlight { font-weight: bold; }
    .footer { text-align: center; margin-top: 20px; font-size: 12px; color: #666; }
    table { width: 100%; border-collapse: collapse; }
    table td { padding: 8px; }
    .label { font-weight: bold; width: 40%; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>New Merchant Request</h1>
    </div>
    <div class="content">
      <p>A new merchant has submitted a request to create a store on Salance.</p>
      
      <div class="section">
        <h2 class="section-title">Business Details</h2>
        <table>
          <tr><td class="label">Business Name:</td><td>${data.businessName}</td></tr>
          <tr><td class="label">Business Category:</td><td>${data.businessCategory}</td></tr>
          <tr><td class="label">Business Email:</td><td>${data.email}</td></tr>
          <tr><td class="label">Business Address:</td><td>${data.address}</td></tr>
          <tr><td class="label">Package Selected:</td><td>${data.packageType}</td></tr>
          <tr><td class="label">Template ID:</td><td>${data.templateId}</td></tr>
        </table>
      </div>
      
      <div class="section">
        <h2 class="section-title">Contact Person</h2>
        <table>
          <tr><td class="label">Name:</td><td>${data.businessRep.name}</td></tr>
          <tr><td class="label">Email:</td><td>${data.businessRep.email}</td></tr>
          <tr><td class="label">Phone:</td><td>${data.businessRep.phoneNumber}</td></tr>
        </table>
      </div>
      
      <div class="section">
        <p>Please follow up with this lead as soon as possible.</p>
        <p>This request was submitted on ${requestDate}</p>
      </div>
    </div>
    <div class="footer">
      <p>© Salance Admin Notification System</p>
    </div>
  </div>
</body>
</html>
  `;
};
```
## Service:
```typescript
import emailClient from '@/config/resend.config';
import { AdminMerchantNotificationPayload } from '@/types/email.types';
import { randomBytes } from 'crypto';
import { generateAdminNotificationEmail } from '../templates/merchant-request-email.template';

export const sendAdminMerchantNotification = async (data: AdminMerchantNotificationPayload) => {
  const requestDate = new Date().toLocaleString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });

  const adminEmails = (process.env.ADMIN_EMAILS ?? 'unwirdev@gmail.com').split(',');
  const html = generateAdminNotificationEmail(data, requestDate);

  return emailClient.emails.send({
    from: `Salance Notifications <notifications@salance.biz>`,
    to: adminEmails,
    subject: `New Merchant Request: ${data.businessName}`,
    text: '',
    html: html,
    headers: {
      'X-Entity-Ref-ID': randomBytes(32).toString('hex'),
    },
  });
};
```
## Usage:
```typescript
    await sendAdminMerchantNotification({
      businessName: body.businessName,
      businessCategory: body.businessCategory,
      email: body.email,
      address: body.address,
      templateId: body.templateId,
      packageType: body.packageType,
      businessRep: {
        name: body.businessRep.name,
        phoneNumber: body.businessRep.phoneNumber,
        email: body.businessRep.email,
      },
    });
```
