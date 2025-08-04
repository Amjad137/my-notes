
## redis.config.ts
```typescript
export const redisConfig = {
	host: process.env.REDIS_HOST ?? 'localhost',
	port: Number(process.env.REDIS_PORT) || 6379,
	password: process.env.REDIS_PASSWORD,
	db: Number(process.env.REDIS_DB) || 0,

	// BullMQ requirements
	maxRetriesPerRequest: null, // Required for BullMQ
	retryDelayOnFailover: 100,
	enableReadyCheck: false,
	lazyConnect: true,

	// More conservative timeout settings to reduce errors
	connectTimeout: 30000,
	commandTimeout: 10000,
	lazyConnectTimeout: 30000,

	// Connection pool settings
	family: 4, // 4 (IPv4) or 6 (IPv6)
	keepAlive: 30000, // 30 seconds

	// More conservative retry strategy
	retryStrategy: (times: number) => {
		if (times > 5) {
			return null; // Stop retrying after 5 attempts
		}
		const delay = Math.min(times * 500, 3000); // Max 3 second delay
		return delay;
	},

	// Reconnection settings
	reconnectOnError: (err: Error) => {
		const targetError = 'READONLY';
		return err.message.includes(targetError);
	},

	// Additional stability settings
	maxLoadingTimeout: 5000,

	// Auto-pipelining: Enable in production for better performance
	enableAutoPipelining: isProduction, // Enable in production, disable in development

	// Auto-pipelining configuration (only applies when enabled)
	...(isProduction && {
		// Maximum number of commands to pipeline together
		autoPipeliningIgnoredCommands: ['ping', 'echo'], // Don't pipeline these
	}),

	// Additional development-friendly settings
	...(process.env.NODE_ENV !== 'production' && {
		showFriendlyErrorStack: true,
		enableOfflineQueue: false, // Disable offline queue in development
	}),
};
```


## redis.ts
```typescript
/* eslint-disable node/prefer-global/process */
import IORedis from 'ioredis';
import { redisConfig } from '@/queues/configs/config';

class RedisManager {
	private static instance: RedisManager;
	private connection: IORedis | null = null;
	private isConnected = false;
	private reconnectAttempts = 0;
	private readonly maxReconnectAttempts = 10;

	private constructor() {}

	public static getInstance(): RedisManager {
		if (!RedisManager.instance) {
			RedisManager.instance = new RedisManager();
		}
		return RedisManager.instance;
	}

	public getConnection(): IORedis {
		if (!this.connection || this.connection.status === 'end') {
			this.createConnection();
		}
		return this.connection!;
	}

	private createConnection(): void {
		try {
			// Close existing connection if any
			if (this.connection) {
				this.connection.disconnect();
			}

			this.connection = new IORedis(redisConfig);
			this.setupEventHandlers();
		}
		catch (error) {
			console.error('❌ Failed to create Redis connection:', error);
			throw error;
		}
	}

	private setupEventHandlers(): void {
		if (!this.connection)
			return;

		this.connection.on('connect', () => {
			console.warn('🔄 Redis connecting...');
		});

		this.connection.on('ready', () => {
			console.warn('✅ Redis connection ready');
			this.isConnected = true;
			this.reconnectAttempts = 0; // Reset on successful connection
		});

		this.connection.on('error', (error) => {
			console.error('❌ Redis connection error:', error.message);
			this.isConnected = false;

			// Handle specific timeout errors
			if (error.message.includes('Command timed out') || error.message.includes('Connection timeout')) {
				// Reduce noise from timeout errors in development
				if (process.env.NODE_ENV !== 'production') {
					// Only log every 10th timeout to reduce console spam
					if (this.reconnectAttempts % 10 === 0) {
						console.warn('⚠️ Redis command/connection timeout - this is often normal in development');
					}
				}
			}
		});

		this.connection.on('close', () => {
			console.warn('🔌 Redis connection closed');
			this.isConnected = false;
		});

		this.connection.on('reconnecting', (delay: number) => {
			this.reconnectAttempts++;
			console.warn(`🔄 Redis reconnecting in ${delay}ms (attempt ${this.reconnectAttempts}/${this.maxReconnectAttempts})`);

			if (this.reconnectAttempts >= this.maxReconnectAttempts) {
				console.error('❌ Max reconnection attempts reached, stopping reconnection');
				this.connection?.disconnect();
			}
		});

		this.connection.on('end', () => {
			console.warn('🔚 Redis connection ended');
			this.isConnected = false;
		});
	}

	public async healthCheck(): Promise<boolean> {
		try {
			if (!this.connection || this.connection.status !== 'ready')
				return false;

			const result = await this.connection.ping();
			return result === 'PONG';
		}
		catch (error) {
			console.error('Redis health check failed:', error);
			return false;
		}
	}

	public isConnectionHealthy(): boolean {
		return this.isConnected && this.connection?.status === 'ready';
	}

	public async disconnect(): Promise<void> {
		if (this.connection) {
			try {
				await this.connection.quit();
			}
			catch (error) {
				console.error('Error during Redis disconnect:', error);
				// Force disconnect if quit fails
				this.connection.disconnect();
			}
			finally {
				this.connection = null;
				this.isConnected = false;
				this.reconnectAttempts = 0;
			}
		}
	}

	public async getMemoryUsage(): Promise<{
		used: string;
		peak: string;
		rss: string;
	} | null> {
		try {
			if (!this.connection || this.connection.status !== 'ready')
				return null;

			const info = await this.connection.info('memory');
			const lines = info.split('\r\n');

			const getMemoryValue = (key: string) => {
				const line = lines.find(l => l.startsWith(`${key}:`));
				return line ? line.split(':')[1] : '0';
			};

			return {
				used: getMemoryValue('used_memory_human'),
				peak: getMemoryValue('used_memory_peak_human'),
				rss: getMemoryValue('used_memory_rss_human'),
			};
		}
		catch (error) {
			console.error('Failed to get Redis memory usage:', error);
			return null;
		}
	}

	// Force reconnection method
	public async forceReconnect(): Promise<void> {
		console.warn('🔄 Forcing Redis reconnection...');
		await this.disconnect();
		this.createConnection();
	}

	// Get connection status
	public getConnectionStatus(): {
		status: string;
		isConnected: boolean;
		reconnectAttempts: number;
	} {
		return {
			status: this.connection?.status || 'not_initialized',
			isConnected: this.isConnected,
			reconnectAttempts: this.reconnectAttempts,
		};
	}
}

// Export singleton instance connection
export const redisConnection = RedisManager.getInstance().getConnection();

// Export manager for advanced operations
export const redisManager = RedisManager.getInstance();

```