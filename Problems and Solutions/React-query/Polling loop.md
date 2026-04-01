[3 tools called]

You’re thinking in the right direction, and polling is a good fit here. I’ve wired it into your existing patterns without changing how your components look.

### What I implemented

All the polling logic lives inside `useUpgradeSubscription` in `apps/web/modules/saas/payments/lib/api.ts`, so your UI code stays simple and consistent.

#### 1. Typed payload + minimal purchase shape

```ts
const queryClient = useQueryClient();

type UpgradePayload = InferRequestType<
	(typeof apiClient.payments)["upgrade-subscription"]["$post"]
>["json"];

type BasicPurchase = {
	id: string;
	productId: string;
	type: string;
	isAddon: boolean;
	subscriptionId?: string | null;
};
```

#### 2. Mutation with built-in polling

```ts
export const useUpgradeSubscription = (organizationId?: string) => {
	const queryClient = useQueryClient();

	return useMutation({
		mutationKey: upgradeSubscriptionMutationKey,
		mutationFn: async (json: UpgradePayload) => {
			const response = await apiClient.payments[
				"upgrade-subscription"
			].$post({ json });

			if (!response.ok) {
				throw new Error("Failed to upgrade subscription");
			}

			return response.json();
		},
		onSuccess: (_data, variables) => {
			const queryKey = purchasesQueryKey(organizationId);

			// Initial refetch
			queryClient.invalidateQueries({ queryKey });

			// Short-lived polling loop to catch the webhook update quickly
			let attempts = 0;
			const maxAttempts = 10;
			const intervalMs = 1500;

			const intervalId = setInterval(() => {
				attempts += 1;

				const purchases =
					queryClient.getQueryData<BasicPurchase[]>(queryKey);

				const hasUpdated = purchases?.some(
					(purchase) =>
						purchase.id === variables.purchaseId &&
						purchase.type === "SUBSCRIPTION" &&
						!purchase.isAddon &&
						purchase.productId === variables.productId,
				);

				if (hasUpdated || attempts >= maxAttempts) {
					clearInterval(intervalId);
					return;
				}

				// Trigger another refetch; when webhook lands, UI will flip
				queryClient.invalidateQueries({ queryKey });
			}, intervalMs);
		},
	});
};
```

### How this behaves from the UI’s perspective

In `PricingTable.tsx` you **don’t have to change anything** beyond what you already have:

```ts
await upgradeSubscriptionMutation.mutateAsync({
	purchaseId: activeSubscription.id,
	productId: price.productId,
	updateBehavior: PRORATION_BEHAVIOR.CHARGE_IMMEDIATELY,
});
```

After a successful call:

1. The mutation succeeds immediately (Creem accepted the upgrade).
2. `useUpgradeSubscription`:
   - Invalidates the `purchases` query once.
   - Starts a small polling loop (max ~15s) that:
     - Checks the cached purchases for the **expected purchaseId + productId**.
     - Keeps invalidating the `purchases` query until:
       - The webhook has updated the DB and React Query sees the new data, or
       - We hit `maxAttempts` and stop.

As soon as the webhook lands and the DB row is updated, the next poll cycle sees it and your cards flip with no manual reload or router tricks.

### Why this fits your existing patterns

- Stays in `lib/api.ts` with the other hooks.
- Uses `useMutation` + `useQueryClient` like everything else.
- No `router.refresh`, no SSR hacks, no component-level timers.
- Pure React Query + small polling loop, fully typed, no `any`.

This gives you a “mature” polling solution that respects your architecture and coding style, while making the UI react quickly once Creem’s webhook has done its job.