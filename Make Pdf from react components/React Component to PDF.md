# Required Packages

1. jspdf : A library for generating PDFs in JavaScript.
2. html2canvas : A library for capturing the content of an HTML element as a canvas.

# steps:
### 1. wrap the component with forwardRef

- Use `forwardRef` to wrap the component, allowing it to forward the ref to its child DOM element.
- Define the component's props and access them within the component definition.
- Return the JSX with the parent container `<div>` having the `ref` passed to it.
- Assign a `displayName` to the component for easier debugging.

	 `const ComponentName =  forwardRef<HTMLDivElement, Props>((Props,ref)=>{`
	 
	 `//component definitions here`
	 
	 return `<div id={ref}> </div>`; `//pass the ref to the parent container`
	 
	 `});`
	 
	 `ComponentName.displayName= 'ComponentName';`

	 `export default ComponentName;`

### 2. Create a Ref Using useRef in the Parent Component and Pass it to the Component

- Use `useRef` hook to create a ref in the parent component where your component is being rendered.
- Pass this ref to your component as a prop.

	 `const myComponentRef = useRef<HTMLDivElement>(null);`

	  `<myComponent ref={myComponentRef} />`

### 3. create a method in the parent component for capture the component's output and print it into a pdf.

- Create a method (`generatePDF`) to capture the component's output and print it into a PDF.
- Initialize a new instance of `jsPDF`.
- Define `currentY` to track the current Y position in the PDF.
- Use `html2canvas` to capture the component's content as a canvas and convert it to a data URL.
- Add the captured image to the PDF, handling page breaks if necessary.
- Save the PDF.

    `const generatePDF = async () => {`
    `const doc = new jsPDF();`

    `let currentY = 20;`
    `const pageHeight = doc.internal.pageSize.getHeight();`
    
    `const addCanvasToPDF = async (ref: RefObject<HTMLDivElement>) => {`
      `if (ref.current) {`
        `const canvas = await html2canvas(ref.current);`
        `const imgData = canvas.toDataURL('image/jpeg', 1.0);`
        `const height = (canvas.height * 180) / canvas.width;`
        
        `if (currentY + height > pageHeight) {`
          `doc.addPage();`
          `currentY = 10;`
        `}`
        `doc.addImage(imgData, 'PNG', 10, currentY, 180, height);`
        `currentY += height + 10;`
      `}`
    `};`
    `doc.text('My Component', 85, 10);`
    `await addCanvasToPDF(myComponentRef);`

    `doc.save('myComponent.pdf');`
  `};` 

### 4. Pass the method to a button

- Create a button and attach the `generatePDF` method to its `onClick` event.

	`<Button onclick={generatePDF} />`