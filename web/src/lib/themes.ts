/**
 * Theme palettes — only the accent colors change between themes. The base
 * surface/text tokens stay constant so the menu silhouette is identical
 * across themes (and shows up properly over any GTA scene).
 *
 * The actual colors live in `app.css` under `[data-theme="..."]` blocks; we
 * just keep ids/labels/swatches here for the settings UI.
 */
export type ThemeId = 'default' | 'blue' | 'purple' | 'pink' | 'orange';

export interface ThemeOption {
  id: ThemeId;
  label: string;
  /** Color shown in the settings swatch and used as a CSS-var preview. */
  swatch: string;
}

export const THEMES: ThemeOption[] = [
  { id: 'default', label: 'Mint', swatch: '#2bf2b6' },
  { id: 'blue', label: 'Blue', swatch: '#3b9eff' },
  { id: 'purple', label: 'Purple', swatch: '#a855f7' },
  { id: 'pink', label: 'Pink', swatch: '#ec4899' },
  { id: 'orange', label: 'Orange', swatch: '#fb923c' },
];

export type SizeId = 'default' | 'medium';

export interface SizeOption {
  id: SizeId;
  label: string;
  description: string;
}

export const SIZES: SizeOption[] = [
  {
    id: 'default',
    label: 'Default',
    description: 'Compact list, anchored to the right',
  },
  {
    id: 'medium',
    label: 'Medium',
    description: 'Wide grid with category sidebar',
  },
];
