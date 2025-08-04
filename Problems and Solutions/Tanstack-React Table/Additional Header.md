import { Table } from '@tanstack/react-table';
import { AlertCircle, Search, Trash2, XOctagon } from 'lucide-react';
import { STAFF_STATUS } from '../../../constants/staff-status.constants';
import { useStaffManagementStore } from '../../../stores/staff-managemnet-store';
import { Button } from '../../ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTrigger } from '../../ui/dialog';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../../ui/select';
import FilterStaffButton from './filter-staff-button';
import NewMessageBut from './staff-message';

interface DataTablePaginationProps<TData> {
  table: Table<TData>;
}

export function StaffTableHeader<TData>({ table }: DataTablePaginationProps<TData>) {
  const { currentStaffCategory } = useStaffManagementStore((s) => ({
    currentStaffCategory: s.currentStaffCategory,
  }));

  const noOfSelectedRows = table.getSelectedRowModel().rows.length;

  return (
    <div className='my-6 flex h-9 w-full items-center justify-between'>
      <div className='flex h-full gap-4'>
        <div className='flex items-center'>
          <span className='mr-4 whitespace-nowrap text-sm font-medium text-muted'>
            Show Records
          </span>
          <Select
            value={`${table.getState().pagination.pageSize}`}
            onValueChange={(value) => {
              table.setPageSize(Number(value));
            }}
          >
            <SelectTrigger className='h-10 w-full border-border hover:bg-muted/20 focus:border-none focus:ring-0 focus:ring-offset-0'>
              <SelectValue />
            </SelectTrigger>
            <SelectContent side='top' className='w-24'>
              {[10, 20, 30, 40, 50, 100].map((pageSize) => (
                <SelectItem key={pageSize} value={`${pageSize}`}>
                  {pageSize}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div className='relative left-20 flex h-full w-full items-center gap-2 overflow-hidden rounded-lg border border-border px-4'>
          <Search />
          <input
            placeholder="Search 'Staff Name' or 'Email'"
            value={(table.getColumn('name')?.getFilterValue() as string) ?? ''}
            onChange={(event) => table.getColumn('name')?.setFilterValue(event.target.value)}
            className='max-w-sm focus:outline-none'
          />
        </div>
      </div>
      <div className='flex gap-3 items-center justify-center h-full'>
        <FilterStaffButton />
        <NewMessageBut />
        {currentStaffCategory === STAFF_STATUS.ACTIVE && noOfSelectedRows > 1 ? (
          <Dialog>
            <DialogTrigger asChild>
              <Button variant='ghost' className='h-9 gap-2 rounded-lg border border-border'>
                <XOctagon className='text-red-500' />
                Suspend Selected Accounts
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <div className='flex flex-col items-center justify-center gap-10'>
                  <div className='flex flex-col items-center justify-center space-y-2'>
                    <AlertCircle className='text-yellow-400' size={40} />
                    <h2 className='text-xl font-semibold text-foreground'>Are you Sure!</h2>
                  </div>

                  <div className='text-center font-semibold text-foreground'>
                    Do you want to suspend |Staff Name| account?
                  </div>

                  <div className='flex flex-row gap-5'>
                    <Button className='w-[160px]' variant={'outline'}>
                      No
                    </Button>
                    <Button className='w-[160px]'>Yes</Button>
                  </div>
                </div>
              </DialogHeader>
            </DialogContent>
          </Dialog>
        ) : currentStaffCategory === STAFF_STATUS.ONBOARDING && noOfSelectedRows > 1 ? (
          <Dialog>
            <DialogTrigger asChild>
              <Button variant='ghost' className='h-9 gap-2 rounded-lg border border-border'>
                <Trash2 />
                Delete Selected Accounts
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <div className='flex flex-col items-center justify-center gap-10'>
                  <div className='flex flex-col items-center justify-center space-y-2'>
                    <AlertCircle className='text-yellow-400' size={40} />
                    <h2 className='text-xl font-semibold text-foreground'>Are you Sure!</h2>
                  </div>

                  <div className='text-center font-semibold text-foreground'>
                    Do you want to delete |Staff Name| information?
                  </div>

                  <div className='flex flex-row gap-5'>
                    <Button className='w-[160px]' variant={'outline'}>
                      No
                    </Button>
                    <Button className='w-[160px]'>Yes</Button>
                  </div>
                </div>
              </DialogHeader>
            </DialogContent>
          </Dialog>
        ) : currentStaffCategory === STAFF_STATUS.ARCHIVED && noOfSelectedRows > 1 ? (
          <Dialog>
            <DialogTrigger asChild>
              <Button variant='ghost' className='h-9 gap-2 rounded-lg border border-border'>
                {/* @SankhajaH Logo for the button is not provided in the UI */}
                <Trash2 />
                Reinstate Selected Accounts
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <div className='flex flex-col items-center justify-center gap-10'>
                  <div className='flex flex-col items-center justify-center space-y-2'>
                    <AlertCircle className='text-yellow-400' size={40} />
                    <h2 className='text-xl font-semibold text-foreground'>Are you Sure!</h2>
                  </div>

                  <div className='text-center font-semibold text-foreground'>
                    Do you want to reinstate selected accounts?
                  </div>

                  <div className='flex flex-row gap-5'>
                    <Button className='w-[160px]' variant={'outline'}>
                      No
                    </Button>
                    <Button className='w-[160px]'>Yes</Button>
                  </div>
                </div>
              </DialogHeader>
            </DialogContent>
          </Dialog>
        ) : null}
      </div>
    </div>
  );
}
