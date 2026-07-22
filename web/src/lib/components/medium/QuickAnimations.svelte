<script lang="ts">
  import { PersonStanding } from '@lucide/svelte';
  import { emoteStore } from '../../stores/emotes.svelte';

  /** Pull the first 4 favorited emotes — fall back to first 4 of the list. */
  let quick = $derived.by(() => {
    const favs = emoteStore.emotes.filter((e) => e.isFavorite).slice(0, 4);
    if (favs.length === 4) return favs;
    return [
      ...favs,
      ...emoteStore.emotes
        .filter((e) => !e.isFavorite)
        .slice(0, 4 - favs.length),
    ];
  });

  const KEYBINDS = ['SHIFT + NUM1', 'SHIFT + NUM2', 'SHIFT + NUM3', 'SHIFT + NUM4'];
</script>

<section class="px-4 pt-3 pb-4">
  <h3
    class="mb-2 text-[12px] font-bold text-[var(--color-accent)]"
  >
    Quick Animations
  </h3>
  <div class="grid grid-cols-4 gap-2">
    {#each quick as emote, i (emote.id)}
      <button
        type="button"
        class="group flex flex-col overflow-hidden rounded-lg bg-[var(--color-row)] ring-1 ring-inset ring-[var(--color-border)] transition-colors hover:ring-[var(--color-accent)]"
      >
        <div
          class="relative flex h-[88px] items-center justify-center bg-gradient-to-br from-black/30 to-black/60"
        >
          <PersonStanding size={36} class="text-white/30" strokeWidth={1.4} />
        </div>
        <div class="flex flex-col items-center gap-1 px-2 py-2">
          <span
            class="block w-full truncate text-center text-[11px] font-semibold text-[var(--color-text)]"
          >
            {emote.label}
          </span>
          <span
            class="rounded bg-[var(--color-accent)] px-2 py-0.5 text-[9px] font-extrabold tracking-wider text-black"
          >
            {KEYBINDS[i]}
          </span>
        </div>
      </button>
    {/each}
  </div>
</section>
