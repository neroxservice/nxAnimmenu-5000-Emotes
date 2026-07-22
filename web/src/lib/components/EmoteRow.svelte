<script lang="ts">
  import { PersonStanding, Star } from '@lucide/svelte';
  import type { Emote } from '../types';
  import { emoteStore } from '../stores/emotes.svelte';

  interface Props {
    emote: Emote;
  }
  let { emote }: Props = $props();

  function play() {
    emoteStore.play(emote);
  }
</script>

<div class="px-3 pb-1.5">
  <div
    class="group flex h-12 w-full items-center gap-3 overflow-hidden rounded-md bg-[var(--color-row)] ring-1 ring-inset ring-[var(--color-border)] transition-colors hover:bg-[var(--color-row-hover)]"
  >
    <button
      type="button"
      onclick={play}
      class="flex flex-1 items-center gap-3 px-2 py-2 text-left"
    >
      <span
        class="flex h-9 w-9 shrink-0 items-center justify-center rounded-md bg-black/30"
      >
        <PersonStanding size={18} class="text-[var(--color-text)]" />
      </span>

      <span class="flex min-w-0 flex-1 flex-col leading-tight">
        <span class="truncate text-[13px] font-bold text-[var(--color-accent)]">
          {emote.label}
        </span>
        <span class="truncate text-[11px] text-[var(--color-text-muted)]">
          /e {emote.name}
        </span>
      </span>
    </button>

    <button
      type="button"
      aria-label={emote.isFavorite ? 'Unfavorite' : 'Favorite'}
      onclick={() => emoteStore.toggleFavorite(emote)}
      class="mr-2 flex h-7 w-7 shrink-0 items-center justify-center rounded transition-colors"
    >
      <Star
        size={16}
        fill={emote.isFavorite ? 'currentColor' : 'none'}
        class={emote.isFavorite
          ? 'text-[var(--color-accent)]'
          : 'text-[var(--color-text-muted)] hover:text-[var(--color-text-dim)]'}
      />
    </button>
  </div>
</div>
