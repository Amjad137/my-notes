```TypeScript
function findLocalNetworkIP(): string | null {
	try {
		const os = require("node:os");
		const networkInterfaces = os.networkInterfaces();

		// Find the first non-internal IPv4 address
		for (const interfaceName of Object.keys(networkInterfaces)) {
			const addresses = networkInterfaces[interfaceName];
			if (!addresses) {
				continue;
			}

			for (const address of addresses) {
				// Skip internal (loopback) and IPv6 addresses
				if (address.family === "IPv4" && !address.internal) {
					return address.address;
				}
			}
		}
	} catch (error) {
		console.warn("Could not determine network URL dynamically:", error);
	}

	return null;
}
```