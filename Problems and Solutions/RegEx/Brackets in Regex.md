```
Meaning of {}, (), and []
```
Great question! In regular expressions (regex), `[]`, `{}`, and `()` all play different roles — think of them as special tools to match patterns. Here's what each does:

---

### ✅ `[]` — **Character set (aka character class)**

Used to match **one character** from a group.

#### Examples:
- `[abc]` → matches **a**, **b**, or **c**
- `[0-9]` → matches **any digit**
- `[a-zA-Z]` → matches any **letter**
- `[^0-9]` → `^` inside `[]` means **NOT**, so this matches anything **except** digits

```ts
/a[bcd]z/  // matches "abz", "acz", or "adz"
```

---

### ✅ `{}` — **Quantifier**

Specifies how many times the **preceding element** should occur.

#### Examples:
- `a{3}` → matches exactly `aaa`
- `a{2,}` → at least 2 `a`s (e.g., `aa`, `aaa`, `aaaa`)
- `a{1,3}` → between 1 and 3 `a`s (e.g., `a`, `aa`, `aaa`)

```ts
/\d{2}/  // matches any two digits, like "42" or "19"
```

---

### ✅ `()` — **Capturing group**

Groups a part of the pattern. You can:
- Apply quantifiers to the whole group
- Extract values using regex match
- Use them for **backreferences** (like repeating the same pattern)

#### Examples:
- `(abc){2}` → matches `abcabc`
- `(\d{2}-){2}\d{4}` → matches something like `12-34-5678`
- `/(foo|bar)/` → matches either `"foo"` or `"bar"`

---

### 🔄 Summary:

| Syntax | Name             | Meaning / Usage                                  |
|--------|------------------|--------------------------------------------------|
| `[]`   | Character set     | Match **one** character from the set            |
| `{}`   | Quantifier        | Specify **how many times** to repeat something  |
| `()`   | Capturing group   | Group parts together for repetition or reference |

---

Want some visual examples or code snippets to test them out?