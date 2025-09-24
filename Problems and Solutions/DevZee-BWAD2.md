
# Day 1 – Introduction to Web Development & HTML Basics

### Goals of the Day

* Understand what web development is.
* Learn what HTML is and its role in building web pages.
* Write your very first simple HTML page.

---

### Topics to Cover

#### 1. What is Web Development?

* Explain that websites are made of **frontend** (what users see) and **backend** (how data is stored/processed).
* Browsers (Chrome, Firefox, Edge) display web pages.
* HTML, CSS, JS are the core of frontend.

#### 2. What is HTML?

* HTML = HyperText Markup Language.
* It gives **structure** to a webpage.
* Analogy: Like the “skeleton” of a human body.

#### 3. Basic HTML Document Structure

* `<!DOCTYPE html>` – tells the browser this is HTML5.
* `<html>` – wraps the whole page.
* `<head>` – contains page info (title, links to CSS/JS).
* `<body>` – contains the visible content.

#### 4. Essential Tags

* Headings: `<h1>` to `<h6>` (importance levels).
* Paragraph: `<p>`.
* Links: `<a href="">`.
* Images: `<img src="" alt="">`.
* Lists: `<ul>` / `<ol>` with `<li>` items.

#### 5. Live Demo (Step-by-Step)

* Create a new HTML file: `index.html`.
* Add the following template:

```html
<!DOCTYPE html>
<html>
<head>
  <title>My First Webpage</title>
</head>
<body>
  <h1>My Name</h1>
  <p>This is a paragraph about me.</p>
  <img src="profile.jpg" alt="My Picture">
  <a href="https://example.com">My Favorite Website</a>
</body>
</html>
```

* Save and open in the browser to see the page.

#### 6. Practice Exercise

* Students create their own “About Me” page using the template:

  * Replace heading with their name.
  * Write a short paragraph about themselves.
  * Add an image (any picture).
  * Add a link to their favorite website.

#### 7. Recap

* HTML is just **structure**.
* Tomorrow we’ll learn how to make it look **beautiful** using CSS.

---

### Homework

* Add another heading (smaller, like `<h3>`).
* Add a list of 3 favorite things (foods, hobbies, songs).




# Day 2 – CSS Basics (Styling Websites)

### Goals of the Day

* Understand what CSS is and its purpose.
* Learn how to style HTML elements using colors, fonts, and layout.
* Apply simple CSS to yesterday’s HTML page.

---

### Topics to Cover

#### 1. What is CSS?

* CSS = Cascading Style Sheets.
* Adds **style** to HTML (colors, fonts, spacing).
* Analogy: HTML is the skeleton, CSS is the clothing and skin.

#### 2. Ways to Apply CSS

* **Inline CSS:** directly in the tag.
* **Internal CSS:** in `<style>` tag in `<head>`.
* **External CSS:** separate `.css` file linked with `<link>`.

#### 3. CSS Properties to Teach

* **Colors:** `color`, `background-color`.
* **Text:** `font-family`, `font-size`, `text-align`.
* **Spacing:** `margin`, `padding`.
* **Borders:** `border`, `border-radius`.
* **Simple layout:** `width`, `height`, `display: block/inline`.

#### 4. Live Demo (Step-by-Step)

* Create a new CSS file: `style.css`.
* Link it in `index.html`:

```html
<link rel="stylesheet" href="style.css">
```

* Add the following basic styles:

```css
body {
  font-family: Arial, sans-serif;
  background-color: #f0f8ff;
  color: #333;
  padding: 20px;
}
h1 {
  color: #0066cc;
  text-align: center;
}
p {
  font-size: 16px;
}
a {
  color: #ff6600;
}
img {
  width: 200px;
  display: block;
  margin: 10px auto;
}
```

* Save and refresh the browser to see changes.

#### 5. Practice Exercise

* Students style their “About Me” page:

  * Change heading color.
  * Center-align text.
  * Add background color to page.
  * Resize image.

#### 6. Recap

* CSS controls **how** things look.
* Tomorrow we will learn how to make the page interactive with **JavaScript**.

---

### Homework

* Add another paragraph and style it with a different color.
* Experiment with font sizes and text alignment.




# Day 3 – Introduction to JavaScript (Making Websites Interactive)

### Goals of the Day

* Understand what JavaScript is and why it's used.
* Learn basic JS syntax and how to run JS on a webpage.
* Make the HTML page interactive with simple actions.

---

### Topics to Cover

#### 1. What is JavaScript?

* JS is a programming language for the web.
* Adds **interactivity** to static HTML/CSS pages.
* Analogy: HTML is skeleton, CSS is clothing, JS is muscles moving.

#### 2. How to Add JS to a Webpage

* Inline: inside a tag using `onclick` (basic example).
* Internal: using `<script>` in HTML `<head>` or `<body>`.
* External: separate `.js` file linked with `<script src="script.js"></script>`.

#### 3. Basic JS Syntax

* Variables: `let`, `const`.
* Simple operations: addition, string concatenation.
* Functions: small reusable blocks.
* `console.log()` to see output.

#### 4. Live Demo (Step-by-Step)

* Create a new JS file: `script.js`.
* Link it in `index.html` before `</body>`:

```html
<script src="script.js"></script>
```

* Add this simple JS code:

```js
// Example: Alert on button click
let btn = document.createElement('button');
btn.textContent = 'Click Me';
document.body.appendChild(btn);

btn.addEventListener('click', function() {
  alert('Hello! You clicked the button.');
});
```

* Save and refresh browser to see button and interaction.

#### 5. Practice Exercise

* Students add a new button to their page:

  * Change the text of a paragraph when clicked.
  * Log a message in console when clicked.

#### 6. Recap

* JS makes web pages interactive.
* Tomorrow, we will use JS to manipulate page elements and style dynamically.

---

### Homework

* Add another button that changes heading color.
* Experiment with different alert messages.


# Day 4 – JavaScript DOM Basics & Mini Interaction

### Goals of the Day

* Learn how to select and manipulate HTML elements using JavaScript.
* Understand events and how to respond to user actions.
* Build a small interactive feature on the page.

---

### Topics to Cover

#### 1. DOM (Document Object Model) Basics

* DOM represents the webpage structure in JS.
* Elements can be selected and modified.
* Common selection methods: `getElementById`, `querySelector`, `querySelectorAll`.

#### 2. Events & Event Listeners

* Events are actions by the user (click, input, hover).
* Attach actions to elements using `addEventListener`.
* Example events: `click`, `input`, `mouseover`.

#### 3. Changing Page Content & Style

* Change text: `element.textContent = 'new text';`
* Change color/style: `element.style.color = 'red';`
* Show how JS can dynamically update the page without refreshing.

#### 4. Live Demo (Step-by-Step)

* Create a button and paragraph in `index.html`:

```html
<p id="demoText">This text will change.</p>
<button id="changeBtn">Change Text</button>
```

* Add JS in `script.js`:

```js
let btn = document.getElementById('changeBtn');
let para = document.getElementById('demoText');

btn.addEventListener('click', function() {
  para.textContent = 'Text has changed!';
  para.style.color = 'blue';
});
```

* Save and refresh to see interaction.

#### 5. Practice Exercise

* Students add another button that:

  * Changes the background color of the page.
  * Logs a message in the console.

#### 6. Recap

* DOM allows JS to interact with the page.
* Events let the page respond to user actions.
* These basics set the stage for building small projects.

---

### Homework

* Add a button that changes the heading text.
* Experiment with changing font size and text color via JS.


# Day 5 – Mini Project & Wrap Up

### Goals of the Day

* Combine HTML, CSS, and JavaScript learned in previous days.
* Build a small interactive project.
* Present and review student projects briefly.

---

### Topics to Cover

#### 1. Review Key Concepts

* HTML structure: headings, paragraphs, images, links.
* CSS styling: colors, fonts, alignment, spacing.
* JS basics: variables, functions, events, DOM manipulation.

#### 2. Mini Project: Personal Info Card

* Create a simple card displaying name, picture, and short info.
* Add a button to change background color or text color.
* Live Demo Template:

```html
<div id="card" style="border:1px solid #ccc; padding:20px; width:300px;">
  <h2 id="name">Your Name</h2>
  <p id="info">A short description about yourself.</p>
  <img src="profile.jpg" alt="Profile" style="width:100%;">
  <button id="colorBtn">Change Background</button>
</div>
```

* JS to add interactivity:

```js
let btn = document.getElementById('colorBtn');
let card = document.getElementById('card');

btn.addEventListener('click', function() {
  card.style.backgroundColor = '#f9c2ff';
});
```

#### 3. Practice Exercise

* Students customize their card:

  * Add another button to change text color.
  * Modify styling using CSS.

#### 4. Presentation & Feedback

* Each student shows their card briefly (1-2 min).
* Encourage peer feedback and positive comments.

#### 5. Recap & Next Steps

* HTML, CSS, and JS basics covered.
* Preview of what learning **MERN stack** would allow (databases, dynamic apps, backend).
* Encourage students to continue practicing and exploring.

---

### Homework

* Try adding another interactive element (like an alert on button click).
* Play with different CSS styles on the card.
* Prepare to join the full MERN course for more advanced projects.
