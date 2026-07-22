<script lang="ts">
  import TabGrid from './TabGrid.svelte';
</script>

<header class="px-5 pt-5 pb-4">
  <h1
    class="text-center text-[15px] font-extrabold uppercase tracking-[0.18em] text-[var(--color-accent)]"
  >
    UM Animation Menu
  </h1>
  <p
    class="mt-1 text-center text-[10px] font-semibold uppercase tracking-[0.14em] text-[var(--color-text-dim)]"
  >
    Click on the button to see the animation
  </p>

  <div class="mt-4">
    <TabGrid />
  </div>
</header>
