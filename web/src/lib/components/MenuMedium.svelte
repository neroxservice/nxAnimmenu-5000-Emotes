<script lang="ts">
  import { Search, Settings, Maximize2 } from '@lucide/svelte';
  import { VList } from 'virtua/svelte';
  import { TABS } from '../tabs';
  import { emoteStore } from '../stores/emotes.svelte';
  import { settingsStore } from '../stores/settings.svelte';
  import type { Emote } from '../types';
  import SidebarTab from './medium/SidebarTab.svelte';
  import EmoteCard from './medium/EmoteCard.svelte';
  import QuickAnimations from './medium/QuickAnimations.svelte';

  /** Medium variant only shows the most-used categories in the sidebar. */
  const MEDIUM_TAB_IDS = [
    'all',
    'favorites',
    'general',
    'dances',
    'expressions',
    'walks',
  ] as const;
  const SIDEBAR_TABS = TABS.filter((t) =>
    MEDIUM_TAB_IDS.includes(t.id as (typeof MEDIUM_TAB_IDS)[number]),
  );

  /** virtua only does vertical lists — pair the cards into rows of 2. */
  let rows = $derived.by(() => {
    const out: [Emote, Emote | null][] = [];
    const items = emoteStore.filtered;
    for (let i = 0; i < items.length; i += 2) {
      out.push([items[i], items[i + 1] ?? null]);
    }
    return out;
  });
</script>

<div
  class="pointer-events-auto flex w-[660px] flex-col overflow-hidden rounded-2xl bg-[var(--color-panel)] shadow-2xl ring-1 ring-[var(--color-border-strong)] backdrop-blur-md"
>
  <!-- ─── Header bar ─────────────────────────────────────────────── -->
  <header class="flex items-center gap-3 px-5 pt-5 pb-3">
    <div class="flex-1">
      <h1
        class="text-[15px] font-extrabold uppercase tracking-[0.18em] text-[var(--color-accent)]"
      >
        UM Animation Menu
      </h1>
      <p
        class="mt-0.5 text-[10px] font-semibold uppercase tracking-[0.14em] text-[var(--color-text-dim)]"
      >
        Click on the button to see the animation
      </p>
    </div>

    <label
      class="flex h-9 w-[200px] items-center gap-2 rounded-md bg-[var(--color-row)] px-3 ring-1 ring-inset ring-[var(--color-border)] focus-within:ring-[var(--color-accent)]"
    >
      <input
        type="text"
        value={emoteStore.searchInput}
        oninput={(e) => emoteStore.setSearch(e.currentTarget.value)}
        placeholder="Search..."
        class="flex-1 bg-transparent text-[12.5px] text-[var(--color-text)] placeholder:text-[var(--color-text-muted)] focus:outline-none"
      />
      <Search size={14} class="text-[var(--color-accent)]" />
    </label>

    <button
      type="button"
      aria-label="Settings"
      onclick={() => settingsStore.toggle()}
      class="flex h-9 w-9 items-center justify-center rounded-md text-[var(--color-accent)] transition-colors hover:bg-[var(--color-row)]"
    >
      <Settings size={16} />
    </button>
    <button
      type="button"
      aria-label="Switch to default size"
      onclick={() => settingsStore.setSize('default')}
      class="flex h-9 w-9 items-center justify-center rounded-md text-[var(--color-accent)] transition-colors hover:bg-[var(--color-row)]"
    >
      <Maximize2 size={16} />
    </button>
  </header>

  <!-- ─── Sidebar + grid ─────────────────────────────────────────── -->
  <div class="flex gap-3 px-4">
    <aside class="flex w-[180px] shrink-0 flex-col gap-1.5">
      {#each SIDEBAR_TABS as tab (tab.id)}
        <SidebarTab {tab} count={emoteStore.counts[tab.id] ?? 0} />
      {/each}
    </aside>

    <div class="flex h-[360px] min-w-0 flex-1 flex-col">
      {#if rows.length === 0}
        <div
          class="flex h-full items-center justify-center text-[12px] text-[var(--color-text-muted)]"
        >
          No emotes found.
        </div>
      {:else}
        <VList
          data={rows}
          style="height: 100%;"
          getKey={(_row, index) => index}
        >
          {#snippet children(row)}
            <div class="grid grid-cols-2 gap-2 pb-2">
              <EmoteCard emote={row[0]} />
              {#if row[1]}
                <EmoteCard emote={row[1]} />
              {:else}
                <div></div>
              {/if}
            </div>
          {/snippet}
        </VList>
      {/if}
    </div>
  </div>

  <!-- ─── Quick animations ───────────────────────────────────────── -->
  <QuickAnimations />
</div>
