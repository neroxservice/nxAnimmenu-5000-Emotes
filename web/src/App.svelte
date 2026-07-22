<script lang="ts">
  import { onMount } from "svelte";
  import { fly, fade, scale } from "svelte/transition";
  import MenuDefault from "./lib/components/MenuDefault.svelte";
  import MenuMedium from "./lib/components/MenuMedium.svelte";
  import SettingsPanel from "./lib/components/SettingsPanel.svelte";
  import GroupPanel from "./lib/components/GroupPanel.svelte";
  import GroupInvitePopup from "./lib/components/GroupInvitePopup.svelte";
  import { settingsStore } from "./lib/stores/settings.svelte";
  import { groupStore } from "./lib/stores/group.svelte";
  import { isFiveM, nui } from "./lib/bridge";

  let visible = $state(!isFiveM);

  onMount(() => {
    if (!isFiveM) return;
    return nui.on("OPEN_MENU", ({ value }) => {
      visible = value;
      if (!value) {
        settingsStore.close();
        groupStore.closePanel();
      }
    });
  });

  function close() {
    if (groupStore.isPanelOpen) {
      groupStore.closePanel();
      return;
    }
    if (settingsStore.isOpen) {
      settingsStore.close();
      return;
    }
    if (isFiveM) {
      void nui.fetch("CLOSE_MENU");
    } else {
      visible = false;
    }
  }

  function isTyping(target: EventTarget | null) {
    const el = target as HTMLElement | null;
    if (!el) return false;
    const tag = el.tagName;
    return tag === "INPUT" || tag === "TEXTAREA" || el.isContentEditable;
  }

  function onKeydown(e: KeyboardEvent) {
    if (!visible) return;

    if (e.key === "Tab") {
      e.preventDefault();
      return;
    }

    if ((e.key === " " || e.key === "Enter") && !isTyping(e.target)) {
      e.preventDefault();
      return;
    }

    if (e.key === "Escape") {
      e.preventDefault();
      close();
    }
  }
</script>

<svelte:window onkeydown={onKeydown} />

{#if visible}
  <main class="pointer-events-none relative h-full w-full">
    {#if settingsStore.size === "medium"}
      <div
        class="absolute top-1/2 left-1/2 z-0 -translate-x-1/2 -translate-y-1/2"
      >
        <MenuMedium />
      </div>
    {:else}
      <div class="absolute top-24 right-6 z-0">
        <MenuDefault />
      </div>
    {/if}

    {#if settingsStore.isOpen}
      <button
        type="button"
        aria-label="Close settings"
        onclick={() => settingsStore.close()}
        transition:fade={{ duration: 120 }}
        class="pointer-events-auto absolute inset-0 z-10 cursor-default bg-black/40"
      ></button>

      <div class="absolute top-1/2 left-6 z-20 -translate-y-1/2">
        <div transition:fly={{ x: -20, duration: 200, opacity: 0 }}>
          <SettingsPanel />
        </div>
      </div>
    {/if}

    {#if groupStore.isPanelOpen}
      <button
        type="button"
        aria-label="Close group panel"
        onclick={() => groupStore.closePanel()}
        transition:fade={{ duration: 120 }}
        class="pointer-events-auto absolute inset-0 z-30 cursor-default bg-black/50"
      ></button>

      <div
        class="absolute top-1/2 left-1/2 z-40 -translate-x-1/2 -translate-y-1/2"
      >
        <div transition:scale={{ duration: 180, start: 0.95, opacity: 0 }}>
          <GroupPanel />
        </div>
      </div>
    {/if}
  </main>
{/if}

<!-- Invite popup lives outside `visible` so it shows even with the menu closed. -->
<div class="pointer-events-none fixed top-6 left-1/2 z-50 -translate-x-1/2">
  {#if groupStore.invite}
    <div transition:fly={{ y: -20, duration: 200, opacity: 0 }}>
      <GroupInvitePopup />
    </div>
  {/if}
</div>
