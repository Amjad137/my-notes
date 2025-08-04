
Wrapper:
```typescript
import {
	closestCenter,
	DndContext,
	KeyboardSensor,
	PointerSensor,
	useSensor,
	useSensors,
} from '@dnd-kit/core';
import {
	closestCenter,
	DndContext,
	KeyboardSensor,
	PointerSensor,
	useSensor,
	useSensors,
} from '@dnd-kit/core';
import type {
	DragEndEvent,
} from '@dnd-kit/core';
import {
	SortableContext,
	sortableKeyboardCoordinates,
	verticalListSortingStrategy,
} from '@dnd-kit/sortable';

const sensors = useSensors(
		useSensor(PointerSensor),
		useSensor(KeyboardSensor, {
			coordinateGetter: sortableKeyboardCoordinates,
		}),
	);

	const handleDragEnd = (event: DragEndEvent) => {
		const { active, over } = event;

		if (over && active.id !== over.id) {
			const oldIndex = selectedContents.findIndex(item => item.id === active.id);
			const newIndex = selectedContents.findIndex(item => item.id === over.id);

			const newContents = [...selectedContents];
			const [movedItem] = newContents.splice(oldIndex, 1);
			newContents.splice(newIndex, 0, movedItem);

			setSelectedContents(newContents);
			onChange(newContents.map(item => item.id.toString()));
		}
	};



<DndContext
							sensors={sensors}
							collisionDetection={closestCenter}
							onDragEnd={handleDragEnd}
						>
							<SortableContext
								items={selectedContents.map(item => item.id)}
								strategy={verticalListSortingStrategy}
							>
								<div className="flex flex-col justify-center">
									{selectedContents.map(item => (
										<SortableItem
											key={item.id}
											item={item}
											onRemove={handleRemoveItem}
										/>
									))}
								</div>
							</SortableContext>
						</DndContext>
```

```typescript
import type { ContentItem } from '@/types/content.types';

import type { FILE_TYPES } from '@/types/fileTypes';
import { useSortable } from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';
import { AlignJustify } from 'lucide-react';
import FileTypeChip from '../dashboard/fileTypeChip';
import { Button } from '../ui/button';

const SortableItem = ({ item, onRemove }: { item: ContentItem; onRemove: (item: ContentItem) => void }) => {
	const {
		attributes,
		listeners,
		setNodeRef,
		transform,
		transition,
	} = useSortable({ id: item.id });

	const style = {
		transform: CSS.Transform.toString(transform),
		transition,
	};

	return (
		<div
			ref={setNodeRef}
			style={style}
			className="flex justify-between items-center bg-secondary/20 rounded border-b p-2"
		>
			<div className="flex items-center gap-2">
				<button
					{...attributes}
					{...listeners}
					className="cursor-grab active:cursor-grabbing"
				>
					<AlignJustify className="h-4 w-4" />
				</button>
				<FileTypeChip
					type={item.type.toString().toLowerCase() as FILE_TYPES}
					label={item.type}
				/>
				<span className="text-sm font-medium">{item.title}</span>
			</div>
			<Button
				type="button"
				variant="outline"
				className="border-primary text-primary"
				onClick={() => onRemove(item)}
			>
				삭제
			</Button>
		</div>
	);
};

export default SortableItem;



```