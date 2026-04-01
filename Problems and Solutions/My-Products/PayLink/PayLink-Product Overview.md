### PayLink: Complete MVP Description

**Tagline:** “Secure payments. Zero scams. Simple for sellers.”

**Purpose:** PayLink is a mobile platform for **online business sellers** who primarily sell via WhatsApp or social media. The goal is to **prevent fake bank slips, automate payment verification, and provide secure order management**, while keeping the process **fast and simple for busy sellers**.

---

## Solution Overview (How PayLink Works)

PayLink simplifies and secures the common **WhatsApp-based selling workflow** by introducing a structured order and payment verification process.

**Typical flow using PayLink:**

1. **Seller creates an order** in the PayLink app by entering the customer's phone number and the payment amount.
2. PayLink automatically generates:

   * A unique **Order ID**
   * A unique **PayLink ID** (reference code for payment)
   * A **payment link** for the customer.
3. The system sends the customer an **SMS (or optional WhatsApp message)** containing payment instructions and the PayLink ID.
4. The customer makes a **bank transfer** and includes the **PayLink ID in the Reason/Purpose field** of the transaction.
5. The customer uploads the **payment receipt (PDF or image)** through the PayLink payment link.
6. PayLink verifies the transaction by:

   * Extracting the **PayLink ID and amount from the uploaded receipt (OCR)**
   * Reading the **seller's bank SMS notification** to confirm the same reference and amount.
7. If both match, the order is automatically marked **Payment Confirmed**.
8. If any mismatch or suspicious activity is detected, the seller can **review the submitted data and resolve the order manually**.

This process allows sellers to **automate payment verification, reduce fake slips, and keep a structured record of all orders and customers** without interrupting their normal WhatsApp-based selling workflow.

---
## 1️. Target Users

* **Primary:** Small online business sellers
* **Secondary:** Customers of these sellers
* **Edge:** Sellers with multiple employees handling orders, repeat customers

---

## 2️. Seller Features

### 2.1 Profile Settings

* Bank account info saved once
* Business name and optional logo
* Optional preferred SMS template for customer notifications

---

### 2.2 Quick Order Creation

Fields for creating an order:

* **Customer Phone Number** (required)
* **Amount** (required)
* **Customer Name** (optional, helps create human-readable reference code)

**UX:**

* Input/paste manually **or** pick from phone contacts using a button next to input
* **Customer DB Search:** While typing the phone number, if the number exists in the seller-specific Customer DB, the customer's details appear in a dropdown for quick selection. Selecting fills the number and name automatically.
* **Optional:** Review customer history button to view previous orders
* If any fraudulent record exists for the customer (even associated with other sellers), a warning is shown with details.

**Reference Code:**

* Format: `PL-[FIRST3NAME]-[RANDOM]` (PayLink ID)
* Example: `PL-NIM-8K32`
* Must be **included in the “Reason/Purpose” field** when making the payment; verification fails if it does not match.

---

### 2.3 Automatic Customer Notification

* SMS sent automatically to customer after order creation

**Example SMS sent by app:**

```id="5qjc6d"
ABC Stores Payment Request

Amount: Rs 7,500
PayLink ID: PL-NIM-8K32

Upload your payment slip:
paylink.app.lk/ORD-48291
```

* Optional **“Send via WhatsApp”** button to directly share pre-filled message with customer

---

### 2.4 Order Status Tracking

Status progression:

| Status              | Trigger                                                             |
| ------------------- | ------------------------------------------------------------------- |
| Pending Payment     | Order created                                                       |
| PDF/Image Uploaded  | Customer uploads receipt                                            |
| PDF Verified        | PDF content verified via OCR and PayLink ID in Reason/Purpose field |
| SMS Verified        | Bank SMS matches PayLink ID + amount (mandatory for images)         |
| Payment Confirmed   | Verified PDF or image + SMS                                         |
| Manual Confirmation | Seller confirms manually (fallback)                                 |

---

### 2.5 SMS Auto-Reading (Android)

* Reads incoming SMS from seller’s bank
* Matches **PayLink ID + Amount + Timestamp** with order
* Updates **SMS Verified** automatically

**Example Bank SMS (for matching):**

```id="0l2yif"
Commercial Bank Alert

Rs 7,500 credited
Ref: PL-NIM-8K32
Date: 25-Feb-2026
Time: 14:32
```

---

### 2.6 Manual Confirmation & Dispute Handling

* Sellers can **view all data submitted by the customer**: PDF/image, amount, reference (PayLink ID), timestamp
* Useful if:

  * Customer claims payment
  * SMS failed to match
  * OCR fails
* Seller can **mark order manually as paid** or **reject** with reason

---

### 2.7 Scam Reporting

* Sellers can report suspicious activity directly in-app:

  * Fake slips
  * Duplicate orders
  * Customer misuse
* Reports stored in **centralized database** to improve fraud detection and app intelligence
* Optionally, suspicious users are flagged across multiple sellers

---

### 2.8 Feedback Collection

* Sellers can provide feedback on:

  * App usability
  * Order verification process
  * Feature requests
* Feedback stored for **future app improvements**

---

## 3️. Customer Features

### 3.1 Payment Link Access

* Receives link via SMS, WhatsApp, or copy-paste
* Displays:

  * Seller name
  * Amount
  * PayLink ID
  * Upload instructions

### 3.2 Payment Slip Upload

* **PDF (preferred):** automatically verified via OCR
* **Image:** allowed for customers unable to download PDF

  * **Mandatory SMS verification** required
* **PayLink ID in Reason/Purpose** is required; verification fails if missing

### 3.3 Reference Code Enforcement

* Customers must include system-provided **PayLink ID** in the slip’s Reason/Purpose field
* Ensures uniqueness and reduces fraud
* Verification fails with clear error message: **“PayLink ID not matched. Please check the ID in Reason/Purpose field.”**

---

## 4️. Verification Flow (MVP)

1. **Seller creates order** → system generates Order ID + PayLink ID + payment link
2. **Customer receives link** → uploads PDF or image
3. **System extracts info from PDF/image** → verifies PayLink ID + amount
4. **Bank SMS auto-read** → matches PayLink ID + amount
5. **Status updates automatically** → **Payment Confirmed** if all checks pass
6. **Fallback/manual handling** if OCR/SMS fails

---

## Layers of Security in PayLink

PayLink is designed with **multiple verification layers** so that scammers cannot easily bypass the system. Instead of relying on a single validation method, PayLink combines several checks to reduce fraud risks.

### 1. PayLink ID Verification

Every order generates a **unique PayLink ID** (example: `PL-NIM-8K32`).

Customers are instructed to place this ID in the **Reason / Purpose field** when making the bank transfer.

Verification checks:

* PayLink ID exists
* PayLink ID matches the correct order
* PayLink ID appears in the uploaded slip

If the ID is missing or mismatched, verification fails with:

"PayLink ID not matched. Please ensure the correct ID is entered in the Reason/Purpose field."

---

### 2. Slip Data Extraction (OCR Validation)

PayLink extracts information from the uploaded PDF or image:

* Amount
* Reference / Reason field
* Transaction date and time

The extracted values are compared with the order details. Any mismatch triggers a **verification failure or manual review**.

---

### 3. Seller Bank SMS Verification

The seller's phone receives the bank notification SMS for incoming transfers. PayLink automatically reads these messages and matches:

* PayLink ID
* Amount
* Approximate timestamp

If these values match the order, the payment status moves to **SMS Verified**.

---

### 4. Slip Reference Number Registry

Many bank receipts include a **transaction reference number** generated by the bank.

PayLink stores these reference numbers in a **global registry** to detect reuse.

Security benefits:

* Prevents scammers from reusing the same receipt for multiple orders
* Prevents the same slip being submitted across different sellers
* Enables detection of suspicious duplicate transactions

If a duplicate reference number is detected, the system flags the order as:

**Potential Fraud – Duplicate Transaction Reference**

---

### 5. Cross-Seller Fraud Intelligence

When sellers report scams, the system records:

* Phone numbers
* Payment patterns
* Suspicious slips

If the same customer attempts transactions with other sellers, PayLink can display a **fraud warning alert** before the seller proceeds.

---

### 6. Customer History Monitoring

Each seller maintains a **private customer history database**.

This allows sellers to see:

* Previous orders
* Payment behavior
* Any past disputes

This improves decision-making when accepting new orders.

---

### 7. Manual Review Fallback

In edge cases where automation fails, sellers can access:

* Uploaded receipt
* Extracted OCR data
* Bank SMS logs

This ensures **legitimate customers are not wrongly rejected while still preventing scams**.

---

These layered protections ensure PayLink is **far more secure than traditional WhatsApp-based payment confirmation**, where sellers rely only on screenshots.

---

## 5️. Notifications

* **Customer:** SMS/WhatsApp with payment instructions
* **Seller:** Push notification when:

  * Slip uploaded
  * Slip verified
  * Payment confirmed

---

## 6️. Future Enhancements

* **Version 2:** Payment Gateway integration (PayHere/OnePay) for instant confirmation
* **Premium Features:**

  * NIC verification for high-value orders
  * Advanced fraud detection (patterns + PDF metadata)
* **Multi-seller support** for marketplaces

---

## 7️. MVP Design Principles

* Minimal effort for busy sellers → 2–3 fields to create order
* Customer flexibility → PDF preferred, image allowed (with SMS verification)
* Automatic verification → OCR + SMS
* Manual fallback → for disputes and edge cases
* Fraud prevention built-in → PayLink ID + SMS verification + customer history flag
