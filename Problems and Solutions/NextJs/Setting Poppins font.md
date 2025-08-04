
In font.utils.ts:

```typescript
import { Inter, Poppins } from 'next/font/google';

export const poppins = Poppins({
  subsets: ['latin'],
  weight: ['300', '400', '500', '600', '700'],
  variable: '--font-poppins',
  display: 'swap',
});

export const inter = Inter({ subsets: ['latin'] });

```

## Explanation:
This code configures and sets up the Poppins font using Next.js's built-in font optimization system. Here's a breakdown of each part:

### Key Components:

1. **[export const poppins](vscode-file://vscode-app/c:/Users/moham/AppData/Local/Programs/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)**:
    
    - Creates and exports a variable that can be imported in other files
    - Will contain the properly configured Poppins font instance
2. **[subsets: ['latin']](vscode-file://vscode-app/c:/Users/moham/AppData/Local/Programs/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)**:
    
    - Specifies that only Latin character sets should be loaded
    - Reduces font file size by excluding other language character sets
    - Improves performance by downloading only what's needed
3. **[weight: ['300', '400', '500', '600', '700']](vscode-file://vscode-app/c:/Users/moham/AppData/Local/Programs/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)**:
    
    - Defines which font weights to include:
        - 300: Light
        - 400: Regular (normal)
        - 500: Medium
        - 600: Semi-bold
        - 700: Bold
    - Only these specific weights will be downloaded, saving bandwidth
4. **[variable: '--font-poppins'](vscode-file://vscode-app/c:/Users/moham/AppData/Local/Programs/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)**:
    
    - Creates a CSS variable that can be used across your application
    - Allows you to reference the font with `font-family: var(--font-poppins)`
    - Makes it easy to apply the font consistently
5. **[display: 'swap'](vscode-file://vscode-app/c:/Users/moham/AppData/Local/Programs/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)**:
    
    - Controls how the font displays during loading
    - `'swap'` means: show a fallback font immediately, then swap to Poppins when loaded
    - Prevents invisible text while waiting for the font to download

### Benefits:

- **Performance optimization**: Next.js automatically optimizes fonts
- **No external requests**: Fonts are self-hosted instead of loaded from Google
- **Zero layout shift**: Prevents content from jumping when fonts load
- **Type safety**: Provides proper TypeScript support for font configuration

This approach follows best practices for web font implementation in Next.js applications.

### Other Options Than Swap
Besides `'swap'`, there are four other options for the [display](vscode-file://vscode-app/c:/Users/moham/AppData/Local/Programs/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html) property in Next.js font configuration:

### 1. `'block'`

display: 'block'

- **Behavior**: Invisible text for a short period (~3 seconds) while font loads
- **Then**: Text appears when either the custom font loads or the timeout expires
- **Best for**: When the font is critical to your brand and worth waiting for
- **Trade-off**: Users may see nothing for a moment (blank space where text should be)

### 2. `'fallback'`

display: 'fallback'

- **Behavior**: Brief invisible text period (~100ms), then shows fallback font
- **Then**: Switches to custom font only if it loads soon after (~3 seconds)
- **Best for**: Balance between performance and design fidelity
- **Trade-off**: May cause layout shift, but less aggressively than `swap`

### 3. `'optional'`

display: 'optional'

- **Behavior**: Brief invisible text period, then shows fallback font
- **Then**: Only uses custom font if it's already cached locally
- **Best for**: Performance-critical sites where fonts are nice-to-have
- **Trade-off**: Many users may never see your custom font

### 4. `'auto'`

display: 'auto'

- **Behavior**: Lets the browser decide the best strategy
- **Then**: Most browsers use something similar to `block` behavior
- **Best for**: When you want to defer to browser defaults
- **Trade-off**: Less control over font loading behavior

### Comparison

|Option|Invisible Text|Layout Shift|Performance|
|---|---|---|---|
|`swap`|None|High|Good|
|`block`|Long|Low|Poor|
|`fallback`|Short|Medium|Better|
|`optional`|Short|Lowest|Best|
|`auto`|Varies|Varies|Varies|

`'swap'` is the most common choice as it ensures text is always visible, but `'fallback'` or `'optional'` are often better for performance.