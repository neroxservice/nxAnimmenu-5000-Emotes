<script lang="ts">
  import type { Tab } from '../../types';
  import { emoteStore } from '../../stores/emotes.svelte';

  interface Props {
    tab: Tab;
    count: number;
  }
  let { tab, count }: Props = $props();

  let active = $derived(emoteStore.activeTab === tab.id);
  let TabIcon = $derived(tab.icon);
</script>

<button
  type="button"
  onclick={() => (emoteStore.activeTab = tab.id)}
  class={[
    'flex w-full items-center gap-3 rounded-lg border px-3 py-2.5 text-left transition-colors',
    active
      ? 'border-[var(--color-accent)] bg-[var(--color-accent-soft)]'
      : 'border-transparent bg-[var(--color-row)]/40 hover:bg-[var(--color-row-hover)]',
  ]}
>
  <span
    class={[
      'flex h-8 w-8 shrink-0 items-center justify-center rounded-md',
      active
        ? 'bg-[var(--color-accent)] text-black'
        : 'bg-black/30 text-[var(--color-text-dim)]',
    ]}
  >
    <TabIcon size={16} strokeWidth={2.25} />
  </span>
  <span class="flex min-w-0 flex-col leading-tight">
    <span
      class={[
        'truncate text-[14px] font-bold',
        active ? 'text-[var(--color-accent)]' : 'text-[var(--color-text)]',
      ]}
    >
      {tab.label}
    </span>
    <span class="truncate text-[10px] text-[var(--color-text-muted)]">
      {count.toLocaleString()} Animations
    </span>
  </span>
</button>
