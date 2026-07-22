<script lang="ts">
  import { PersonStanding, Star } from '@lucide/svelte';
  import type { Emote } from '../../types';
  import { emoteStore } from '../../stores/emotes.svelte';

  interface Props {
    emote: Emote;
  }
  let { emote }: Props = $props();

  function play() {
    emoteStore.play(emote);
  }

  /** Deterministic gradient based on emote id so cards look distinct. */
  let gradientHue = $derived(
    Array.from(emote.id).reduce((a, c) => a + c.charCodeAt(0), 0) % 360,
  );
</script>

<div
  class="group relative h-[160px] overflow-hidden rounded-lg bg-[var(--color-row)] ring-1 ring-inset ring-[var(--color-border)] transition-all hover:ring-[var(--color-accent)]"
>
  <div
    class="pointer-events-none absolute inset-0"
    style:background="linear-gradient(160deg, hsl({gradientHue} 35% 25% / 0.55), hsl({(gradientHue + 80) % 360} 30% 12% / 0.85))"
  ></div>

  <div
    class="pointer-events-none absolute inset-0 flex items-center justify-center opacity-50"
  >
    <PersonStanding size={56} class="text-white/30" strokeWidth={1.4} />
  </div>

  <!-- Click target covers the whole card; sits behind interactive children. -->
  <button
    type="button"
    aria-label={`Play ${emote.label}`}
    onclick={play}
    class="absolute inset-0 z-0 cursor-pointer"
  ></button>

  <!-- Top row — favorite + command badge -->
  <div
    class="pointer-events-none relative z-10 flex items-start justify-between p-2"
  >
    <button
      type="button"
      aria-label={emote.isFavorite ? 'Unfavorite' : 'Favorite'}
      onclick={() => emoteStore.toggleFavorite(emote)}
      class="pointer-events-auto flex h-7 w-7 items-center justify-center rounded-md bg-black/40 backdrop-blur"
    >
      <Star
        size={14}
        fill={emote.isFavorite ? 'currentColor' : 'none'}
        class={emote.isFavorite
          ? 'text-[var(--color-accent)]'
          : 'text-[var(--color-text-muted)]'}
      />
    </button>
    <span
      class="rounded-md bg-[var(--color-accent)]/85 px-2 py-0.5 text-[10px] font-bold text-black"
    >
      /e {emote.name}
    </span>
  </div>

  <!-- Bottom label -->
  <div
    class="pointer-events-none absolute right-0 bottom-0 left-0 z-10 bg-gradient-to-t from-black/85 to-transparent px-3 pt-6 pb-2"
  >
    <span class="block truncate text-[13px] font-bold text-[var(--color-text)]">
      {emote.label}
    </span>
  </div>
</div>
