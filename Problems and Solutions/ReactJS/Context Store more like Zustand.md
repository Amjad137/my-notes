```typescript
'use client';

import React, {
	createContext,
	useContext,
	useState,
	useMemo,
	Dispatch,
	SetStateAction,
} from 'react';
import type { ContentTableItem } from '@/types/content.types';

interface ContentSelectionContextType {
	contents: ContentTableItem[];
	setContents: (contents: ContentTableItem[]) => void;

	totalContentsCount: number;
	setTotalContentsCount: (contents: number) => void;

	setSelectedContents: Dispatch<SetStateAction<ContentTableItem[]>>;
	selectedContents: ContentTableItem[];

	setLoading: (loading: boolean) => void;
	loading: boolean;

	clearSelection: () => void;
}

const ContentSelectionContext = createContext<
	ContentSelectionContextType | undefined
>(undefined);

export const ContentSelectionProvider = ({
	children,
}: {
	children: React.ReactNode;
}) => {
	const [contents, setContents] = useState<ContentTableItem[]>([]);
	const [totalContentsCount, setTotalContentsCount] = useState<number>(0);
	const [selectedContents, setSelectedContents] = useState<ContentTableItem[]>(
		[],
	);
	const [loading, setLoading] = useState(false);

	const toggleSelection = (content: ContentTableItem) => {
		setSelectedContents((prev) => {
			const isSelected = prev.some((item) => item.id === content.id);
			if (isSelected) {
				return prev.filter((item) => item.id !== content.id);
			}
			return [...prev, content];
		});
	};

	const clearSelection = () => {
		setSelectedContents([]);
	};

	const value = useMemo(
		() => ({
			contents,
			selectedContents,
			loading,
			setContents,
			setSelectedContents,
			setLoading,
			toggleSelection,
			clearSelection,
			totalContentsCount,
			setTotalContentsCount,
		}),
		[contents, selectedContents, loading, totalContentsCount],
	);

	return (
		<ContentSelectionContext.Provider value={value}>
			{children}
		</ContentSelectionContext.Provider>
	);
};

export function useContentSelection() {
	const context = useContext(ContentSelectionContext);
	if (context === undefined) {
		throw new Error(
			'useContentSelection must be used within a ContentSelectionProvider',
		);
	}
	return context;
}

```