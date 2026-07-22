<script lang="ts">
  import { VList } from 'virtua/svelte';
  import { emoteStore } from '../stores/emotes.svelte';
  import EmoteRow from './EmoteRow.svelte';
</script>

<div class="min-h-0 flex-1">
  {#if emoteStore.filtered.length === 0}
    <div
      class="flex h-full items-center justify-center text-[12px] text-[var(--color-text-muted)]"
    >
      No emotes found.
    </div>
  {:else}
    <VList
      data={emoteStore.filtered}
      style="height: 100%;"
      getKey={(item) => item.id}
    >
      {#snippet children(item)}
        <EmoteRow emote={item} />
      {/snippet}
    </VList>
  {/if}
</div>
