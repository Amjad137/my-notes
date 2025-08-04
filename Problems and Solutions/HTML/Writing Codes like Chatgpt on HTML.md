In HTML, you can format code snippets for different languages using the `<pre>` and `<code>` tags, often including a class attribute for syntax highlighting. Here's an example:

### HTML Example:
```html
<pre><code class="language-javascript">
// JavaScript example
function helloWorld() {
    console.log("Hello, world!");
}
</code></pre>

<pre><code class="language-python">
# Python example
def hello_world():
    print("Hello, world!")
</code></pre>
```

For the syntax highlighting to work, you'll need a library like [Prism.js](https://prismjs.com/) or [Highlight.js](https://highlightjs.org/).

### In Obsidian:

Obsidian uses Markdown with support for code blocks. To create code blocks for specific languages, you simply wrap the code in triple backticks (```` ``` ````) and specify the language:

````markdown
```javascript
// JavaScript example
function helloWorld() {
    console.log("Hello, world!");
}
```

```python
# Python example
def hello_world():
    print("Hello, world!")
```
````

In Obsidian, the language identifier after the triple backticks automatically applies syntax highlighting for that language. This is a built-in feature, so you don't need extra libraries.