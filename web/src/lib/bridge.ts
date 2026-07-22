import type { Emote } from './types';

const RESOURCE_NAME =
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  (globalThis as any).GetParentResourceName?.() ?? 'rpemotes-reborn';

export const isFiveM =
  typeof window !== 'undefined' &&
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  typeof (window as any).invokeNative === 'function';

type Handler<T = unknown> = (payload: T) => void;
const handlers = new Map<string, Set<Handler>>();

if (typeof window !== 'undefined') {
  window.addEventListener('message', (e) => {
    const data = e.data as { type?: string } | null;
    if (!data || typeof data.type !== 'string') return;
    const set = handlers.get(data.type);
    if (!set) return;
    for (const fn of set) fn(data);
  });
}

export interface GroupMember {
  id: number;
  name: string;
}

export interface GroupState {
  ownerId: number;
  ownerName: string;
  members: GroupMember[];
}

export interface NearbyPlayer {
  id: number;
  name: string;
  distance: number;
}

interface NuiMessages {
  LOAD_EMOTE_DATA: { emotes: Emote[] };
  OPEN_MENU: { value: boolean };
  GROUP_STATE: { group: GroupState | null; isOwner: boolean };
  GROUP_INVITE: { ownerId: number; ownerName: string };
  GROUP_INVITE_CLEAR: Record<string, never>;
}

export const nui = {
  on<K extends keyof NuiMessages>(
    type: K,
    handler: (data: NuiMessages[K]) => void,
  ): () => void {
    const set = handlers.get(type) ?? new Set();
    set.add(handler as Handler);
    handlers.set(type, set);
    return () => set.delete(handler as Handler);
  },

  async fetch<T = unknown>(name: string, body: unknown = {}): Promise<T | null> {
    if (!isFiveM) return null;
    try {
      const res = await fetch(`https://${RESOURCE_NAME}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(body),
      });
      return (await res.json()) as T;
    } catch (err) {
      console.error(`[nui] ${name} failed`, err);
      return null;
    }
  },
};
