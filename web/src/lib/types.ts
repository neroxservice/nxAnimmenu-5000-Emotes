export type EmoteType =
  | "Emotes"
  | "Dances"
  | "PropEmotes"
  | "AnimalEmotes"
  | "Walks"
  | "Expressions"
  | "SharedEmotes"
  | "Exits"
  | "Emojis"
  | "White2do"
  | "White3ro"
  | "White5to";

export type CategoryId =
  | "all"
  | "favorites"
  | "sequences"
  | "general"
  | "dances"
  | "expressions"
  | "walks"
  | "custom"
  | "animal"
  | "prop"
  | "shared";

export interface Emote {
  id: string;
  name: string;
  label: string;
  emoteType: EmoteType;
  categoryId?: CategoryId | string;
  isFavorite?: boolean;
  hasPermission?: boolean;
}

import type { Icon as LucideIcon } from "@lucide/svelte";

export interface Tab {
  id: CategoryId;
  label: string;
  icon: typeof LucideIcon;
}
