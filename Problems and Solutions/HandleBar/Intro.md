**Handlebars** is a **templating engine** that helps generate dynamic HTML content by inserting variables into templates. It is commonly used for **email templates**, **web pages**, and **server-side rendering**.

### **Why Use Handlebars?**
✅ **Simple Syntax** – Uses `{{variable}}` for dynamic data.  
✅ **Logic Support** – Supports `if`, `each`, and custom helpers.  
✅ **Separation of Concerns** – Keeps HTML templates clean and maintainable.  

---

### **Example 1: Basic Handlebars Template**
#### **Template:**
```handlebars
<h1>Welcome, {{name}}!</h1>
<p>Your order ID is: {{orderId}}</p>
```

#### **Data:**
```json
{
  "name": "John Doe",
  "orderId": "123456"
}
```

#### **Rendered Output:**
```html
<h1>Welcome, John Doe!</h1>
<p>Your order ID is: 123456</p>
```

---

### **Example 2: Handlebars in Your Code (`email.service.ts`)**
In your project, you use Handlebars to dynamically generate **order confirmation emails**:

```typescript
html: Handlebars.compile(orderConfirmationTemplate)({
  orderId: args.orderId.slice(-6),
  lineItems: args.lineItems,
  additionalCharges: args.additionalCharges,
  shippingAddress: args.shippingAddress,
  subTotal: args.subTotal,
  totalDiscount: args.totalDiscount,
  total: args.total,
  storeAddress: args.storeAddress,
  storeName: args.storeName,
  currency: args.currency
})
```

- **`Handlebars.compile(template)(data)`**:
  - Takes an email **template**.
  - Injects dynamic **data** (like order details).
  - Generates a **final HTML email**.

---

### **Example 3: Handlebars with Loops (`each`)**
If you need to **list items dynamically**, use `{{#each}}`:

#### **Template:**
```handlebars
<h1>Order Confirmation</h1>
<ul>
  {{#each lineItems}}
    <li>{{productName}} - {{quantity}} x {{productPrice}} = {{lineTotal}}</li>
  {{/each}}
</ul>
```

#### **Data:**
```json
{
  "lineItems": [
    { "productName": "Laptop", "quantity": 1, "productPrice": 1000, "lineTotal": 1000 },
    { "productName": "Mouse", "quantity": 2, "productPrice": 20, "lineTotal": 40 }
  ]
}
```

#### **Rendered Output:**
```html
<h1>Order Confirmation</h1>
<ul>
  <li>Laptop - 1 x 1000 = 1000</li>
  <li>Mouse - 2 x 20 = 40</li>
</ul>
```

---

### **Where is Handlebars Used?**
- **Email Templates** (like in your Resend integration).
- **Static Site Generation** (Jekyll, Middleman, etc.).
- **Server-Side Rendering** (Express.js with Handlebars).

---

### **Conclusion**
**Handlebars** is a **powerful, easy-to-use** templating engine that helps generate dynamic content, especially for **transactional emails** like your **order confirmation emails**. 🚀