![[Mermaid Chart - Create complex, visual diagrams with text. A smarter way of creating diagrams.-2025-09-17-135800.png]]

Perfect 👍 You’ve shared an **ERD-style (Entity–Relationship Diagram)** made with Mermaid.
Let’s go step by step — I’ll teach you all the **notations, concepts, and background** (even those not shown in your diagram).

---

## 1. **Core ERD Concepts**

Entity–Relationship Diagrams (ERD) are used to **visualize database schemas**.

* **Entity** → A table (rectangle box).
* **Attribute** → A column (fields listed inside the entity).
* **Relationship** → How entities are linked.

---

## 2. **Notation inside Entities**

In your diagram, each entity box lists **attributes** with type and role.

Example from `Patient`:

```
string id PK
string firstName
string lastName
int age
Gender gender
string organizationId FK
datetime lastVisit
datetime createdAt
datetime updatedAt
```

* **Data type** → `string`, `int`, `datetime`, `boolean`, `float`, `enum`.
* **PK** → **Primary Key** (unique identifier).
* **FK** → **Foreign Key** (reference to another table).
* **Nullable?** (not shown, but often indicated by `?` → means optional).
* **Enum** (like `Gender` or `VisitStatus`) → A fixed set of values.

---

## 3. **Relationship Notations**

The lines between tables show **cardinality** (how many of each side can exist).

Symbols used here:

* **"1" |—O** → **One-to-Many**
  Example: `Patient has many Visit`.
  Meaning: One patient can have many visits.
* **"1" |—||** → **One-to-One**
* **"O—O"** → **Many-to-Many** (not shown here).

Other notations you might see:

* **Crows Foot Notation** (common alternative):

  * `|` → one
  * `O` → zero or one
  * `{}` or crow’s foot (like `<=<`) → many

---

## 4. **Relationship Roles (Labels)**

Your diagram labels the relationships for clarity:

* `assigned doctor`
* `created by`
* `recorded by`
* `has many`

These help explain **the business meaning** of the relationship.

---

## 5. **General Concepts Not in the Diagram**

To fully understand ERDs, you also need these:

### a) **Keys**

* **Primary Key (PK)** → uniquely identifies a row.
* **Foreign Key (FK)** → points to PK in another table.
* **Composite Key** → multiple columns combined as PK.

### b) **Relationships**

* **One-to-One**: Each entity in A has max one in B. (e.g., Passport–Person).
* **One-to-Many**: One entity in A can link to many in B. (e.g., Patient–Visits).
* **Many-to-Many**: Requires a **junction table** (e.g., Students–Courses).

### c) **Constraints**

* **NOT NULL** → column must have a value.
* **UNIQUE** → no duplicate values allowed.
* **DEFAULT** → auto value if not supplied.
* **CHECK** → rule constraint (e.g., `age > 0`).

### d) **Normalization**

Process of structuring DB to avoid redundancy:

1. **1NF** → no repeating groups, atomic values.
2. **2NF** → no partial dependency on part of a composite key.
3. **3NF** → no transitive dependency (non-key depending on non-key).

### e) **Data Types**

Typical DB data types:

* **String/Text** → `CHAR`, `VARCHAR`, `TEXT`.
* **Numbers** → `INT`, `BIGINT`, `DECIMAL`, `FLOAT`.
* **Date/Time** → `DATE`, `DATETIME`, `TIMESTAMP`.
* **Boolean** → true/false.
* **JSON** → structured data.

### f) **Indexes**

* **Primary Index** → created by PK.
* **Secondary Index** → for faster search.
* **Composite Index** → multiple columns together.

### g) **Special Entities**

* **Weak Entities** → cannot exist without parent entity (e.g., OrderLine needs Order).
* **Associative Entities** → resolve many-to-many (e.g., Enrollment for Student–Course).

---

## 6. **Bringing It Back to Your Diagram**

Using your diagram as example:

* **Visit** is the **central entity** (hub).
* `Patient`, `Organization`, `Member` connect to `Visit`.
* `Condition`, `Prescription`, `Vitals` are dependent on `Visit`.
* Roles clarify meaning:

  * `assignedDoctorId` links Visit → Member.
  * `recordedById` links Vitals → Member.

---

✅ That covers **all notations in your diagram + extra ERD concepts** you might see elsewhere.

Would you like me to **redraw your diagram in Crow’s Foot Notation** (the most standard one for interviews/academics), so you can compare styles?
