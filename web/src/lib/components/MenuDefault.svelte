<script lang="ts">
  import Header from './Header.svelte';
  import SearchBar from './SearchBar.svelte';
  import EmoteList from './EmoteList.svelte';
</script>

<div
  class="pointer-events-auto flex h-[748px] w-[340px] flex-col overflow-hidden rounded-xl bg-[var(--color-panel)] shadow-2xl ring-1 ring-[var(--color-border-strong)] backdrop-blur-md"
>
  <Header />

  <div
    class="mx-3 flex min-h-0 flex-1 flex-col overflow-hidden rounded-lg bg-[var(--color-card)] ring-1 ring-[var(--color-border)]"
  >
    <SearchBar />
    <EmoteList />
  </div>

  <div class="h-3 shrink-0"></div>
</div>
