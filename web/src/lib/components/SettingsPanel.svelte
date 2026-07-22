<script lang="ts">
  import { Check, X } from '@lucide/svelte';
  import { THEMES, SIZES } from '../themes';
  import { settingsStore } from '../stores/settings.svelte';
</script>

<div
  class="pointer-events-auto flex w-[260px] flex-col overflow-hidden rounded-xl bg-[var(--color-panel)] shadow-2xl ring-1 ring-[var(--color-border-strong)] backdrop-blur-md"
>
  <header class="flex items-center justify-between px-4 pt-4 pb-3">
    <h2
      class="text-[12px] font-extrabold uppercase tracking-[0.18em] text-[var(--color-accent)]"
    >
      Settings
    </h2>
    <button
      type="button"
      aria-label="Close settings"
      onclick={() => settingsStore.close()}
      class="flex h-7 w-7 items-center justify-center rounded-md text-[var(--color-text-dim)] transition-colors hover:bg-[var(--color-row)] hover:text-[var(--color-text)]"
    >
      <X size={14} />
    </button>
  </header>

  <div class="flex flex-col gap-5 px-4 pb-5">
    <!-- ─── Theme ──────────────────────────────────────────────────── -->
    <section>
      <h3
        class="mb-2 text-[10px] font-semibold uppercase tracking-[0.14em] text-[var(--color-text-dim)]"
      >
        Theme
      </h3>
      <div class="grid grid-cols-5 gap-2">
        {#each THEMES as theme (theme.id)}
          {@const active = settingsStore.theme === theme.id}
          <button
            type="button"
            aria-label={theme.label}
            title={theme.label}
            onclick={() => settingsStore.setTheme(theme.id)}
            class={[
              'group relative flex h-10 items-center justify-center rounded-md ring-2 transition-all',
              active
                ? 'ring-[var(--color-text)]'
                : 'ring-transparent hover:ring-[var(--color-border-strong)]',
            ]}
            style:background-color={theme.swatch}
          >
            {#if active}
              <Check size={16} class="text-black/80" strokeWidth={3} />
            {/if}
          </button>
        {/each}
      </div>
    </section>

    <!-- ─── Size ───────────────────────────────────────────────────── -->
    <section>
      <h3
        class="mb-2 text-[10px] font-semibold uppercase tracking-[0.14em] text-[var(--color-text-dim)]"
      >
        Size
      </h3>
      <div class="flex flex-col gap-1.5">
        {#each SIZES as size (size.id)}
          {@const active = settingsStore.size === size.id}
          <button
            type="button"
            onclick={() => settingsStore.setSize(size.id)}
            class={[
              'flex flex-col items-start rounded-md border px-3 py-2 text-left transition-colors',
              active
                ? 'border-[var(--color-accent)] bg-[var(--color-accent-soft)]'
                : 'border-transparent bg-[var(--color-row)] hover:bg-[var(--color-row-hover)]',
            ]}
          >
            <span
              class={[
                'text-[12px] font-bold',
                active
                  ? 'text-[var(--color-accent)]'
                  : 'text-[var(--color-text)]',
              ]}
            >
              {size.label}
            </span>
            <span class="mt-0.5 text-[10px] text-[var(--color-text-muted)]">
              {size.description}
            </span>
          </button>
        {/each}
      </div>
    </section>
  </div>
</div>
