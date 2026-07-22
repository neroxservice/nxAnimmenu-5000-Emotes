<script lang="ts">
  import { Check, UsersRound, X } from '@lucide/svelte';
  import { groupStore } from '../stores/group.svelte';

  let invite = $derived(groupStore.invite);
</script>

{#if invite}
  <div
    class="pointer-events-auto flex w-[340px] flex-col gap-2 rounded-xl bg-[var(--color-panel)] px-4 py-3 shadow-2xl ring-1 ring-[var(--color-border-strong)] backdrop-blur-md"
  >
    <div class="flex items-center gap-3">
      <span
        class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[var(--color-accent-soft)] text-[var(--color-accent)]"
      >
        <UsersRound size={18} />
      </span>

      <div class="min-w-0 flex-1">
        <p class="text-[12px] font-bold text-[var(--color-text)]">
          Group invite
        </p>
        <p class="truncate text-[11px] text-[var(--color-text-muted)]">
          <span class="font-bold text-[var(--color-accent)]"
            >{invite.ownerName}</span
          >
          invited you to their emote group
        </p>
      </div>

      <button
        type="button"
        aria-label="Accept invite"
        onclick={() => groupStore.acceptInvite()}
        class="flex h-8 w-8 shrink-0 items-center justify-center rounded-md bg-[var(--color-accent)] text-black transition-colors hover:bg-[var(--color-accent-strong)]"
      >
        <Check size={14} strokeWidth={3} />
      </button>
      <button
        type="button"
        aria-label="Decline invite"
        onclick={() => groupStore.declineInvite()}
        class="flex h-8 w-8 shrink-0 items-center justify-center rounded-md bg-red-500/15 text-red-400 ring-1 ring-inset ring-red-500/40 transition-colors hover:bg-red-500/25"
      >
        <X size={14} strokeWidth={3} />
      </button>
    </div>

    <p
      class="border-t border-[var(--color-border)] pt-1.5 text-center text-[10px] font-semibold uppercase tracking-[0.14em] text-[var(--color-text-muted)]"
    >
      Press
      <kbd
        class="mx-0.5 rounded bg-[var(--color-row)] px-1.5 py-0.5 text-[var(--color-accent)]"
        >Y</kbd
      >
      to accept ·
      <kbd
        class="mx-0.5 rounded bg-[var(--color-row)] px-1.5 py-0.5 text-red-400"
        >N</kbd
      >
      to decline
    </p>
  </div>
{/if}
