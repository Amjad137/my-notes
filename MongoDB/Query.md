```javascript

const mongoose = require('mongoose'); 
const { Schema } = mongoose; 

const userSchema = new Schema({ name: String, age: Number, status: String }); 

const User = mongoose.model('User', userSchema); 
async function findActiveAdults() { 
const adults = await User.find({ age: { $gte: 18 }, status: 'active' }); 

return adults; }

```

In the code sample above, we’re filtering documents that represent adult users with an ‘active’ status. The `$gte` operator is used to match all users who are 18 or older. This is a straightforward query that uses MongoDB’s comparison query operators.

## Complex Queries with Logical Operators

```javascript
async function complexQuery() { 
const users = await User.find({ 
$and: [ 
		{ age: { $gte: 18 } }, 
	    { $or: [{ status: 'active' },{ status: 'pending'}] } 
	    ] 
	   }); 
	   
return users; }
```

Logical operators such as `$and`, `$or`, and `$not` enable the combination of multiple query conditions. As shown, we are looking for users who are at least 18 years old and have a status of either ‘active’ or ‘pending’.

For more: [Mongoose: How to filter documents by multiple fields - Sling Academy](https://www.slingacademy.com/article/mongoose-how-to-filter-documents-by-multiple-fields/#Basic_Query_Filtering)