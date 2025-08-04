```typescript

type Data = {
  profile: string;
  name: string;
  id: string;
  status: string;
  role: string;
  location: string;
  dateAndTime: string;
  note: string;
};

const multiColumnFilterFn: FilterFn<Data> = (row, columnId, filterValue) => {
  const searchableRowContent = `${row.original.name} ${row.original.location}`;
  return searchableRowContent.toLowerCase().includes(filterValue.toLowerCase());
};

const columns: ColumnDef<Data>[] = [
  {
    id: 'select',
    header: ({ table }) => (
      <Checkbox
        checked={
          table.getIsAllPageRowsSelected() || (table.getIsSomePageRowsSelected() && 'indeterminate')
        }
        onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
        aria-label='Select all'
      />
    ),
    cell: ({ row }) => (
      <Checkbox
        checked={row.getIsSelected()}
        onCheckedChange={(value) => row.toggleSelected(!!value)}
        aria-label='Select row'
      />
    ),
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: 'name',
    header: ({ column }) => {
      return <DataTableColumnHeader column={column} title='Name' />;
    },
    cell: ({ row }) => {
      return (
        <div className='flex items-center gap-2 text-sm font-medium text-right whitespace-nowrap text-foreground'>
          <Avatar>
            <AvatarImage src={row.original.profile} alt='Profile Picture' />
            <AvatarFallback>
              <User2 />
            </AvatarFallback>
          </Avatar>
          {row.getValue('name')}
        </div>
      );
    },
    filterFn: multiColumnFilterFn,
  },
  {
    accessorKey: 'id',
    header: ({ column }) => {
      return <DataTableColumnHeader column={column} title='Staff ID' />;
    },
  },
  {
    accessorKey: 'status',
    header: ({ column }) => {
      return <DataTableColumnHeader column={column} title='Status' />;
    },
    cell: ({ row }) => {
      return (
        <div
          className={`text-2xs flex h-7 w-32 items-center rounded-2xl font-semibold ${
            row.getValue('status') === STAFF_STATUS.ACTIVE
              ? 'bg-[#34C046]/20 text-[#34C046]'
              : row.getValue('status') === STAFF_STATUS.ONBOARDING
                ? 'bg-[#005A9C]/20 text-[#005A9C]'
                : row.getValue('status') === STAFF_STATUS.TO_REVIEW
                  ? 'bg-[#F77E27]/20 text-[#F77E27]'
                  : row.getValue('status') === STAFF_STATUS.IN_PROGRESS
                    ? 'bg-[#FFC421]/20 text-[#FFC421]'
                    : row.getValue('status') === STAFF_STATUS.SENT_FOR_SUBMIT
                      ? 'bg-[#3047EC]/20 text-[#3047EC]'
                      : row.getValue('status') === STAFF_STATUS.INVITED
                        ? 'bg-[#00AFFFBF]/20 text-[#00AFFFBF]'
                        : row.getValue('status') === STAFF_STATUS.REJECTED
                          ? 'bg-[#FF5050]/20 text-[##FF5050]'
                          : row.getValue('status') === STAFF_STATUS.SUSPENDED
                            ? 'bg-[#FF5050CC]/80 text-[#FFFFFF]'
                            : row.getValue('status') === STAFF_STATUS.CLOSED
                              ? 'bg-[#000000]/20 text-[#000000]'
                              : row.getValue('status') === STAFF_STATUS.ARCHIVED
                                ? 'bg-[#A6A6A6]/20 text-[#A6A6A6]'
                                : ''
          }`}
        >
          <span className='w-full text-center'>{toUpper(row.getValue('status'))}</span>
        </div>
      );
    },
  },
  {
    accessorKey: 'role',
    header: ({ column }) => {
      return <DataTableColumnHeader column={column} title='Role of Staff' />;
    },
  },
  {
    accessorKey: 'location',
    header: ({ column }) => {
      return <DataTableColumnHeader column={column} title='Location' />;
    },
  },
  {
    accessorKey: 'dateAndTime',
    header: ({ column }) => {
      return <DataTableColumnHeader column={column} title='Date & Time' />;
    },
    cell: ({ row }) => {
      return (
        <div className='flex items-center justify-center gap-2 text-sm font-medium text-right text-foreground'>
          <Clock4 className='text-muted' />
          {row.getValue('dateAndTime')}
        </div>
      );
    },
  },
  {
    accessorKey: 'note',
    header: ({ column }) => {
      return <DataTableColumnHeader column={column} title='Note' />;
    },
    cell: ({ row }) => {
      return (
        <div className='flex h-7 items-center gap-1 rounded-lg bg-[#3047EC] p-2 text-sm font-semibold text-background'>
          <FileText size={16} />
          {row.getValue('note')}
        </div>
      );
    },
  },
  {
    accessorKey: 'selectedRowsAndActions',
    header: ({ table }) => {
      const noOfSelectedRows = table.getSelectedRowModel().rows.length;
      const { currentStaffCategory } = useStaffManagementStore.getState();
      return (
        <div className='flex items-center w-full gap-2'>
          <span className='flex justify-end w-full text-xs text-end'>
            {table.getFilteredSelectedRowModel().rows.length} Selected
          </span>
          {noOfSelectedRows > 1 && currentStaffCategory === STAFF_STATUS.SUSPENDED ? (
            <div className='flex items-center justify-end text-muted-foreground hover:text-foreground'>
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <MoreVertical />
                </DropdownMenuTrigger>
                <DropdownMenuContent className='mr-7' align='start'>
                  <DropdownMenuItem>Close Selected Accounts</DropdownMenuItem>
                  <DropdownMenuItem>Reinstate Selected Accounts</DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            </div>
          ) : noOfSelectedRows > 1 && currentStaffCategory === STAFF_STATUS.CLOSED ? (
            <div className='flex items-center justify-end text-muted-foreground hover:text-foreground'>
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <MoreVertical />
                </DropdownMenuTrigger>
                <DropdownMenuContent className='mr-7' align='start'>
                  <DropdownMenuItem>Archive Selected Accounts</DropdownMenuItem>
                  <DropdownMenuItem>Reinstate Selected Accounts</DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            </div>
          ) : null}
        </div>
      );
    },
    cell: ({ row }) => {
      return <ActionsColumnComponent row={row} />;
    },
  },
];

```