<script lang="ts">
  import { Search, Settings, UsersRound } from '@lucide/svelte';
  import { emoteStore } from '../stores/emotes.svelte';
  import { settingsStore } from '../stores/settings.svelte';
  import { groupStore } from '../stores/group.svelte';
  import { nui } from '../bridge';

  // Flips SetNuiFocusKeepInput so typing here doesn't reach the game.
  function setSearchFocus(focused: boolean) {
    void nui.fetch('SEARCH_FOCUS', { focused });
  }
</script>

<div class="flex items-center gap-2 px-3 pt-3 pb-2">
  <label
    class="flex h-9 flex-1 items-center gap-2 rounded-md bg-[var(--color-row)] px-3 ring-1 ring-inset ring-[var(--color-border)] focus-within:ring-[var(--color-accent)]"
  >
    <Search size={14} class="text-[var(--color-accent)]" />
    <input
      type="text"
      value={emoteStore.searchInput}
      oninput={(e) => emoteStore.setSearch(e.currentTarget.value)}
      onfocus={() => setSearchFocus(true)}
      onblur={() => setSearchFocus(false)}
      placeholder="Search..."
      class="flex-1 bg-transparent text-[12.5px] text-[var(--color-text)] placeholder:text-[var(--color-text-muted)] focus:outline-none"
    />
  </label>

  <button
    type="button"
    aria-label="Group emote"
    onclick={() => groupStore.openPanel()}
    class={[
      'relative flex h-9 w-9 items-center justify-center rounded-md ring-1 ring-inset transition-colors',
      groupStore.state
        ? 'bg-[var(--color-accent-soft)] text-[var(--color-accent)] ring-[var(--color-accent)]'
        : 'bg-[var(--color-row)] text-[var(--color-accent)] ring-[var(--color-border)] hover:bg-[var(--color-row-hover)]',
    ]}
  >
    <UsersRound size={14} />
    {#if groupStore.state}
      <span
        class="absolute -top-1 -right-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-[var(--color-accent)] px-1 text-[9px] font-bold text-black"
      >
        {groupStore.state.members.length}
      </span>
    {/if}
  </button>

  <button
    type="button"
    aria-label="Settings"
    onclick={() => settingsStore.toggle()}
    class={[
      'flex h-9 w-9 items-center justify-center rounded-md ring-1 ring-inset transition-colors',
      settingsStore.isOpen
        ? 'bg-[var(--color-accent-soft)] text-[var(--color-accent)] ring-[var(--color-accent)]'
        : 'bg-[var(--color-row)] text-[var(--color-accent)] ring-[var(--color-border)] hover:bg-[var(--color-row-hover)]',
    ]}
  >
    <Settings size={14} />
  </button>
</div>
