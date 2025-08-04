Ah got it! You're asking **how to write and render mathematical equations in an `.md` file** (like in **Obsidian** or any Markdown editor that supports **LaTeX/MathJax**).

Here’s exactly how to do it:

---

## ✅ **1. Inline Equations**

Use **single dollar signs (`$`)** to write inline math:

```markdown
This is an inline equation: $E = mc^2$
```

It will render as:  
**This is an inline equation:** _E = mc²_

---

## ✅ **2. Block Equations**

Use **double dollar signs (`$$`)** before and after the equation to display it as a centered block:

```markdown
$$
SPS = (A \times w_1) + (AT \times w_2) + (EC \times w_3)
$$
```

This will render like:

$$
SPS = (A \times w_1) + (AT \times w_2) + (EC \times w_3)
$$

---

## ✅ **3. Summations, Fractions, Subscripts**

More advanced MathJax syntax works too:

```markdown
$$
A = \frac{1}{N} \sum_{i=1}^{N} \left( T_i \cdot w_t + S_i \cdot w_s \right)
$$
```

Renders as:

$$
A = \frac{1}{N} \sum_{i=1}^{N} \left( T_i \cdot w_t + S_i \cdot w_s \right)
$$

---

## ⚙️ Obsidian Tip:
If it's not rendering in Obsidian:
1. Go to **Settings → Editor**
2. Make sure **“Render LaTeX”** is enabled.

---

Let me know if you'd like me to convert your full academic calculation answer into an `.md` file you can copy into Obsidian!