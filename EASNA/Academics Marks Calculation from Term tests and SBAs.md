
### Calculate Academic Score (A)**

Let’s assume a student is evaluated on **10 subjects**, and each subject has:
- **Term Test marks** (e.g., out of 100)
- **Assignment/SBA marks** (e.g., out of 25 or 50)

We'll normalize both components to a **100-point scale**, then calculate a weighted average for each subject.

---

### 🎯 **Academic Score Formula:**

$$
\text{A} = \frac{1}{N} \sum_{i=1}^{N} \left( (T_i \times wt_1) + (S_i \times wt_2) \right)
$$

Where:
- **A** = Final Academic Score (out of 100)
- **N** = Total number of subjects
- **Tᵢ** = Term test score for subject *i* (normalized to 100)
- **Sᵢ** = SBA/assignment score for subject *i* (normalized to 100)
- **wt₁, wt₂** = Weights (e.g., 70% test, 30% assignment)

---

### 📘 **Example:**

Let’s say the student has the following for **3 subjects** (to keep it short):

| Subject | Term Test (out of 100) | SBA (out of 25) |
|---------|------------------------|-----------------|
| Math    | 92                     | 20              |
| Science | 80                     | 18              |
| English | 87                     | 22              |

**Step 1: Normalize SBA to 100**
- Math SBA: $( \frac{20}{25} \times 100 = 80 )$
- Science SBA: $( \frac{18}{25} \times 100 = 72 )$
- English SBA: $( \frac{22}{25} \times 100 = 88 )$

**Step 2: Apply Weights (70% test, 30% SBA)**

- Math: $( 92 \times 0.7 + 80 \times 0.3 = 88.4 )$
- Science: $( 80 \times 0.7 + 72 \times 0.3 = 77.6 )$
- English: $( 87 \times 0.7 + 88 \times 0.3 = 87.3 )$

**Step 3: Average Across Subjects**

$$
\text{A} = \frac{88.4 + 77.6 + 87.3}{3} = 84.43
$$

> Final **Academic Score = 84.43/100**

---

### 💡 Notes:
- You can make **weights dynamic** (editable by admin) based on school policy.
- SBA marks may differ in full marks (some out of 50, others out of 20) — so normalization is important.
- This logic can be automated per student and recalculated after every term.

---

Would you like me to help write a sample JavaScript function or database structure to implement this calculation in EASNA?