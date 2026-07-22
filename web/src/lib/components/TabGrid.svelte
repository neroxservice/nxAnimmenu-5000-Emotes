<script lang="ts">
  import { TABS } from '../tabs';
  import { emoteStore } from '../stores/emotes.svelte';
</script>

<div class="grid grid-cols-3 gap-1.5">
  {#each TABS as tab (tab.id)}
    {@const active = emoteStore.activeTab === tab.id}
    {@const TabIcon = tab.icon}
    <button
      type="button"
      onclick={() => (emoteStore.activeTab = tab.id)}
      class={[
        'group flex h-9 items-center justify-center gap-1.5 rounded-md border px-2 text-[11px] font-semibold uppercase tracking-wider transition-colors',
        active
          ? 'border-[var(--color-accent)] bg-[var(--color-accent-soft)] text-[var(--color-accent)]'
          : 'border-transparent bg-[var(--color-row)] text-[var(--color-text-dim)] hover:bg-[var(--color-row-hover)] hover:text-[var(--color-text)]',
      ]}
    >
      <TabIcon size={13} strokeWidth={2.25} />
      <span class="truncate">{tab.label}</span>
    </button>
  {/each}
</div>
