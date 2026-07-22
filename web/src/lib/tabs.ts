import {
  LayoutGrid,
  Star,
  ListOrdered,
  User,
  Music,
  Smile,
  Footprints,
  Sparkles,
  PawPrint,
  Package,
  Users,
} from '@lucide/svelte';
import type { Tab } from './types';

export const TABS: Tab[] = [
  { id: 'all', label: 'All', icon: LayoutGrid },
  { id: 'favorites', label: 'Favorites', icon: Star },
  { id: 'sequences', label: 'Sequences', icon: ListOrdered },
  { id: 'general', label: 'General', icon: User },
  { id: 'dances', label: 'Dances', icon: Music },
  { id: 'expressions', label: 'Expressions', icon: Smile },
  { id: 'walks', label: 'Walks', icon: Footprints },
  { id: 'custom', label: 'Custom', icon: Sparkles },
  { id: 'animal', label: 'Animal', icon: PawPrint },
  { id: 'prop', label: 'Prop', icon: Package },
  { id: 'shared', label: 'Shared', icon: Users },
];
