<script lang="ts">
  import {
    Crown,
    LogOut,
    RefreshCcw,
    Trash2,
    User,
    UserPlus,
    UsersRound,
    X,
  } from '@lucide/svelte';
  import { groupStore } from '../stores/group.svelte';

  let group = $derived(groupStore.state);
  let isOwner = $derived(groupStore.isOwner);
  let nearby = $derived(groupStore.nearby);
</script>

<div
  class="pointer-events-auto flex w-[720px] flex-col overflow-hidden rounded-xl bg-[var(--color-panel)] shadow-2xl ring-1 ring-[var(--color-border-strong)] backdrop-blur-md"
>
  <header class="flex items-start justify-between px-5 pt-5 pb-4">
    <div>
      <h2
        class="text-[15px] font-extrabold uppercase tracking-[0.18em] text-[var(--color-accent)]"
      >
        Group Emote
      </h2>
      <p
        class="mt-1 text-[10px] font-semibold uppercase tracking-[0.14em] text-[var(--color-text-dim)]"
      >
        Create a group to sync emotes with nearby players
      </p>
    </div>

    <button
      type="button"
      aria-label="Close"
      onclick={() => groupStore.closePanel()}
      class="flex h-7 w-7 items-center justify-center rounded-md text-[var(--color-text-dim)] transition-colors hover:bg-[var(--color-row)] hover:text-[var(--color-text)]"
    >
      <X size={14} />
    </button>
  </header>

  {#if !group}
    <div
      class="flex flex-col items-center justify-center gap-4 px-5 pt-2 pb-8 text-center"
    >
      <div
        class="flex h-14 w-14 items-center justify-center rounded-full bg-[var(--color-accent-soft)] text-[var(--color-accent)]"
      >
        <UsersRound size={26} />
      </div>
      <div>
        <p class="text-[13px] font-bold text-[var(--color-text)]">
          You aren't in a group yet
        </p>
        <p class="mt-1 text-[11px] text-[var(--color-text-muted)]">
          Create one to invite nearby players and sync emotes together.
        </p>
      </div>
      <button
        type="button"
        onclick={() => groupStore.create()}
        class="inline-flex h-9 items-center gap-2 rounded-md bg-[var(--color-accent)] px-4 text-[12px] font-bold uppercase tracking-wider text-black transition-colors hover:bg-[var(--color-accent-strong)]"
      >
        <UsersRound size={14} />
        Create Group
      </button>
    </div>
  {:else}
    <div class="grid grid-cols-2 gap-4 px-5 pb-5">
      <section class="flex flex-col">
        <h3
          class="mb-1 text-[12px] font-bold uppercase tracking-[0.14em] text-[var(--color-text)]"
        >
          Group Members
        </h3>
        <p
          class="mb-3 text-[10px] font-semibold uppercase tracking-[0.12em] text-[var(--color-text-dim)]"
        >
          Click any emote to sync with your group
        </p>

        <div
          class="flex h-[260px] flex-col gap-1.5 overflow-y-auto rounded-lg bg-[var(--color-card)] p-2 ring-1 ring-[var(--color-border)]"
        >
          {#each group.members as member (member.id)}
            {@const isMemberOwner = member.id === group.ownerId}
            <div
              class={[
                'flex h-11 items-center gap-2 rounded-md px-3 ring-1 ring-inset transition-colors',
                isMemberOwner
                  ? 'bg-[var(--color-accent-soft)] ring-[var(--color-accent)]'
                  : 'bg-[var(--color-row)] ring-[var(--color-border)]',
              ]}
            >
              <span
                class={[
                  'flex h-6 w-6 shrink-0 items-center justify-center rounded',
                  isMemberOwner
                    ? 'bg-[var(--color-accent)] text-black'
                    : 'bg-black/30 text-[var(--color-text-dim)]',
                ]}
              >
                {#if isMemberOwner}
                  <Crown size={12} strokeWidth={2.5} />
                {:else}
                  <User size={12} strokeWidth={2.5} />
                {/if}
              </span>

              <span
                class={[
                  'flex-1 truncate text-[12.5px] font-bold',
                  isMemberOwner
                    ? 'text-[var(--color-accent)]'
                    : 'text-[var(--color-text)]',
                ]}
              >
                {member.name}
                {#if isMemberOwner}
                  <span
                    class="ml-1 text-[10px] font-semibold text-[var(--color-text-muted)]"
                    >(Owner)</span
                  >
                {/if}
              </span>

              {#if isOwner && !isMemberOwner}
                <button
                  type="button"
                  aria-label="Kick member"
                  onclick={() => groupStore.kick(member.id)}
                  class="flex h-7 w-7 items-center justify-center rounded text-[var(--color-text-muted)] transition-colors hover:bg-[var(--color-row-hover)] hover:text-red-400"
                >
                  <Trash2 size={12} />
                </button>
              {/if}
            </div>
          {/each}

          {#if group.members.length === 1}
            <div
              class="flex flex-1 flex-col items-center justify-center gap-2 text-center text-[var(--color-text-muted)]"
            >
              <UsersRound size={22} class="opacity-40" />
              <p class="text-[11px] font-semibold uppercase tracking-wider">
                No members in group
              </p>
            </div>
          {/if}
        </div>

        <div class="mt-3">
          {#if isOwner}
            <button
              type="button"
              onclick={() => groupStore.disband()}
              class="inline-flex h-9 items-center gap-2 rounded-md bg-red-500/15 px-3 text-[11px] font-bold uppercase tracking-wider text-red-400 ring-1 ring-inset ring-red-500/40 transition-colors hover:bg-red-500/25"
            >
              <Trash2 size={13} />
              Disband Group
            </button>
          {:else}
            <button
              type="button"
              onclick={() => groupStore.leave()}
              class="inline-flex h-9 items-center gap-2 rounded-md bg-red-500/15 px-3 text-[11px] font-bold uppercase tracking-wider text-red-400 ring-1 ring-inset ring-red-500/40 transition-colors hover:bg-red-500/25"
            >
              <LogOut size={13} />
              Leave Group
            </button>
          {/if}
        </div>
      </section>

      <section class="flex flex-col">
        <h3
          class="mb-1 text-[12px] font-bold uppercase tracking-[0.14em] text-[var(--color-text)]"
        >
          Nearby Players
        </h3>
        <p
          class="mb-3 text-[10px] font-semibold uppercase tracking-[0.12em] text-[var(--color-text-dim)]"
        >
          Invite players within 10 meters
        </p>

        <div
          class="flex h-[260px] flex-col gap-1.5 overflow-y-auto rounded-lg bg-[var(--color-card)] p-2 ring-1 ring-[var(--color-border)]"
        >
          <button
            type="button"
            disabled={!isOwner || groupStore.isRefreshing}
            onclick={() => groupStore.refreshNearby()}
            class="inline-flex h-9 shrink-0 items-center justify-center gap-2 rounded-md bg-[var(--color-row)] text-[11px] font-bold uppercase tracking-wider text-[var(--color-text)] transition-colors hover:bg-[var(--color-row-hover)] disabled:cursor-not-allowed disabled:opacity-50"
          >
            <RefreshCcw
              size={12}
              class={groupStore.isRefreshing ? 'animate-spin' : ''}
            />
            Refresh
          </button>

          {#each nearby as player (player.id)}
            <div
              class="flex h-11 items-center gap-2 rounded-md bg-[var(--color-row)] px-3 ring-1 ring-inset ring-[var(--color-border)]"
            >
              <span
                class="flex h-6 w-6 shrink-0 items-center justify-center rounded bg-black/30 text-[var(--color-text-dim)]"
              >
                <User size={12} strokeWidth={2.5} />
              </span>
              <span
                class="flex-1 truncate text-[12px] font-bold text-[var(--color-text)]"
              >
                ID: {player.id}
                <span class="ml-1 text-[10px] text-[var(--color-text-muted)]">
                  {player.distance.toFixed(1)}m
                </span>
              </span>
              {#if isOwner}
                <button
                  type="button"
                  aria-label="Invite to group"
                  onclick={() => groupStore.invitePlayer(player.id)}
                  class="flex h-7 w-7 items-center justify-center rounded bg-[var(--color-accent)] text-black transition-colors hover:bg-[var(--color-accent-strong)]"
                >
                  <UserPlus size={13} strokeWidth={2.5} />
                </button>
              {/if}
            </div>
          {/each}

          {#if nearby.length === 0 && !groupStore.isRefreshing}
            <div
              class="flex flex-1 flex-col items-center justify-center gap-2 text-center text-[var(--color-text-muted)]"
            >
              <User size={22} class="opacity-40" />
              <p class="text-[11px] font-semibold uppercase tracking-wider">
                No players nearby
              </p>
            </div>
          {/if}
        </div>
      </section>
    </div>
  {/if}
</div>
