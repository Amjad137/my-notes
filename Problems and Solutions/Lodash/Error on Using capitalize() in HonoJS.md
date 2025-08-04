```typescript
import { capitalize } from "lodash";

capitalize(status)
```

Error: SyntaxError: Named export 'capitalize' not found. The requested module 'lodash' is a CommonJS module, which may not support all module.exports as named exports.
CommonJS modules can always be imported via the default export, for example using:

Solution:

```typescript
import pkg from 'lodash';

pkg.capitalize(status)
```