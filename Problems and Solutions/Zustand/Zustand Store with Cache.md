```typescript

import { UNIVERSITY_STATUS } from '@/constants/university.constants';
import { IUniversity } from '@/types/universities.type';
import { create } from 'zustand';

interface DomainsManagementStore {
  currentDomainsCategory: UNIVERSITY_STATUS;
  setCurrentDomainsCategory: (currentDomainsCategory: UNIVERSITY_STATUS) => void;

  domainsData: IUniversity[];
  setDomainsData: (data: IUniversity[]) => void;

  domainsCache: Record<
    UNIVERSITY_STATUS,
    {
      data: IUniversity[];
      timestamp: number;
    }
  >;

  updateCache: (category: UNIVERSITY_STATUS, data: IUniversity[]) => void;
  getCachedData: (category: UNIVERSITY_STATUS) => IUniversity[] | null;
  isCacheValid: (category: UNIVERSITY_STATUS) => boolean;
  invalidateCache: () => void;

  refreshTrigger: boolean;
  setRefreshTrigger: (refreshTrigger: boolean) => void;
  isLoading: boolean;
  setIsLoading: (isLoading: boolean) => void;
}

const CACHE_TTL = 5 * 60 * 1000;

export const useDomainsManagementStore = create<DomainsManagementStore>((set, get) => ({
  currentDomainsCategory: UNIVERSITY_STATUS.ALL,
  setCurrentDomainsCategory: (currentDomainsCategory: UNIVERSITY_STATUS) =>
    set({ currentDomainsCategory }),

  domainsData: [],
  setDomainsData: (data: IUniversity[]) => set({ domainsData: data }),

  domainsCache: {} as Record<UNIVERSITY_STATUS, { data: IUniversity[]; timestamp: number }>,

  updateCache: (category: UNIVERSITY_STATUS, data: IUniversity[]) => {
    set((state) => ({
      domainsCache: {
        ...state.domainsCache,
        [category]: {
          data,
          timestamp: Date.now(),
        },
      },
    }));
  },

  getCachedData: (category: UNIVERSITY_STATUS) => {
    const cachedEntry = get().domainsCache[category];
    return cachedEntry?.data || null;
  },

  isCacheValid: (category: UNIVERSITY_STATUS) => {
    const cachedEntry = get().domainsCache[category];
    if (!cachedEntry) return false;

    const now = Date.now();
    return now - cachedEntry.timestamp < CACHE_TTL;
  },

  invalidateCache: () =>
    set({
      domainsCache: {
        [UNIVERSITY_STATUS.ALL]: { data: [], timestamp: 0 },
        [UNIVERSITY_STATUS.PENDING]: { data: [], timestamp: 0 },
        [UNIVERSITY_STATUS.VERIFIED]: { data: [], timestamp: 0 },
        [UNIVERSITY_STATUS.REJECTED]: { data: [], timestamp: 0 },
      },
    }),

  refreshTrigger: false,
  setRefreshTrigger: (refreshTrigger: boolean) => {
    if (refreshTrigger) {
      get().invalidateCache();
    }
    set({ refreshTrigger });
  },

  isLoading: false,
  setIsLoading: (isLoading: boolean) => set({ isLoading }),
}));

```