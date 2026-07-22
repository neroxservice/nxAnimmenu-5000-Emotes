import type { CategoryId, Emote, EmoteType } from '../types';
import { MOCK_EMOTES } from '../mock';
import { debounce } from '../utils/debounce';
import { isFiveM, nui } from '../bridge';

const SEARCH_DEBOUNCE_MS = 150;

class EmoteStore {
  emotes = $state<Emote[]>(isFiveM ? [] : MOCK_EMOTES);
  activeTab = $state<CategoryId>('all');

  searchInput = $state<string>('');

  search = $state<string>('');

  filtered = $derived.by(() => {
    const q = this.search.trim().toLowerCase();
    return this.emotes.filter((e) => {
      if (this.activeTab === 'favorites') {
        if (!e.isFavorite) return false;
      } else if (this.activeTab !== 'all' && e.categoryId !== this.activeTab) {
        return false;
      }
      if (!q) return true;
      return (
        e.name.toLowerCase().includes(q) || e.label.toLowerCase().includes(q)
      );
    });
  });

  counts = $derived.by(() => {
    const map: Record<string, number> = { all: this.emotes.length, favorites: 0 };
    for (const e of this.emotes) {
      if (e.isFavorite) map.favorites += 1;
      const k = e.categoryId;
      if (k) map[k] = (map[k] ?? 0) + 1;
    }
    return map;
  });

  #commitSearch = debounce((value: string) => {
    this.search = value;
  }, SEARCH_DEBOUNCE_MS);

  setSearch(value: string) {
    this.searchInput = value;
    if (value === '') {
      this.#commitSearch.cancel();
      this.search = '';
      return;
    }
    this.#commitSearch(value);
  }

  setAll(next: Emote[]) {
    this.emotes = next;
  }

  toggleFavorite(emote: Emote) {
    const i = this.emotes.findIndex((e) => e.id === emote.id);
    if (i === -1) return;
    this.emotes[i] = { ...this.emotes[i], isFavorite: !this.emotes[i].isFavorite };

    void nui.fetch('FAVORITE_EMOTE', {
      id: emote.id,
      name: emote.name,
      label: emote.label,
      emoteType: emote.emoteType,
    });
  }

  play(emote: Emote) {
    void nui.fetch('ROUTE_EMOTE', {
      type: 'emote',
      emoteName: emote.name,
      emoteType: emote.emoteType as EmoteType,
    });
  }
}

export const emoteStore = new EmoteStore();

// Hydrate from Lua when running inside FiveM CEF.
if (isFiveM) {
  nui.on('LOAD_EMOTE_DATA', ({ emotes }) => {
    emoteStore.setAll(emotes);
  });
  // Tell Lua we're mounted so it can push initial data.
  void nui.fetch('NUI_READY', {});
}
