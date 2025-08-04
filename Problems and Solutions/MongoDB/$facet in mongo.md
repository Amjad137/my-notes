In MongoDB, the `$facet` stage is used in the aggregation pipeline to perform **multiple parallel aggregations** on the same input documents. It allows you to **branch the pipeline** into multiple sub-pipelines (facets), each performing a different transformation or analysis, and then returns the results as a **single document** with each facet's result under a separate field.

This is especially useful when you want to run multiple analyses (e.g., paginated data + total count + histogram) on the same dataset in one query.

---

### 📘 Syntax:

```js
{
  $facet: {
    facet1: [ /* pipeline stages */ ],
    facet2: [ /* pipeline stages */ ],
    ...
  }
}
```

---

### 🔧 Example:

Let's say we have a collection called `products`:

```json
{ "_id": 1, "name": "Pen", "category": "Stationery", "price": 2 }
{ "_id": 2, "name": "Notebook", "category": "Stationery", "price": 5 }
{ "_id": 3, "name": "Mouse", "category": "Electronics", "price": 25 }
{ "_id": 4, "name": "Keyboard", "category": "Electronics", "price": 45 }
{ "_id": 5, "name": "Monitor", "category": "Electronics", "price": 200 }
```

We want to:

* Get products in the `Electronics` category (paged: skip 0, limit 2)
* Count the total number of `Electronics` products
* Group the prices into buckets

Here's how you'd do that using `$facet`:

```js
db.products.aggregate([
  { $match: { category: "Electronics" } },
  {
    $facet: {
      paginatedResults: [
        { $skip: 0 },
        { $limit: 2 }
      ],
      totalCount: [
        { $count: "count" }
      ],
      priceHistogram: [
        {
          $bucket: {
            groupBy: "$price",
            boundaries: [0, 50, 100, 200, 300],
            default: "Other",
            output: {
              count: { $sum: 1 }
            }
          }
        }
      ]
    }
  }
])
```

### 🧾 Output:

```json
{
  "paginatedResults": [
    { "_id": 3, "name": "Mouse", "category": "Electronics", "price": 25 },
    { "_id": 4, "name": "Keyboard", "category": "Electronics", "price": 45 }
  ],
  "totalCount": [
    { "count": 3 }
  ],
  "priceHistogram": [
    { "_id": 0, "count": 2 },
    { "_id": 100, "count": 1 }
  ]
}
```

---

### ✅ Use Cases:

* Pagination + total count in one query
* Filtering + summary stats + histograms
* Multiple types of aggregations (e.g., count, avg, group) at once

Would you like to see how to use `$facet` in a real app or with Mongoose?
