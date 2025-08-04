- The `.test()` method is a built-in function for regular expressions in JavaScript.
- It takes a string as an argument and returns `true` if the string contains at least one match for the regular expression. Otherwise, it returns `false`.

example: 
const regex = /[A-Z]/;
const value = "HelloWorld";  // Example string
const result = regex.test(value);
Output : true
