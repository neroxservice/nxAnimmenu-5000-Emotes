import type { SizeId, ThemeId } from '../themes';

const STORAGE_KEY = 'um-animations:settings';

interface PersistedSettings {
  theme: ThemeId;
  size: SizeId;
}

const DEFAULTS: PersistedSettings = { theme: 'default', size: 'default' };

function load(): PersistedSettings {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return DEFAULTS;
    const parsed = JSON.parse(raw) as Partial<PersistedSettings>;
    return { ...DEFAULTS, ...parsed };
  } catch {
    return DEFAULTS;
  }
}

function save(value: PersistedSettings) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(value));
  } catch {
    /* ignore — quota / private mode */
  }
}

function applyTheme(theme: ThemeId, size: SizeId) {
  document.documentElement.dataset.theme = theme;
  document.documentElement.dataset.size = size;
}

class SettingsStore {
  #initial = load();

  theme = $state<ThemeId>(this.#initial.theme);
  size = $state<SizeId>(this.#initial.size);
  isOpen = $state<boolean>(false);

  constructor() {
    applyTheme(this.theme, this.size);
  }

  setTheme(theme: ThemeId) {
    this.theme = theme;
    applyTheme(theme, this.size);
    save({ theme, size: this.size });
  }

  setSize(size: SizeId) {
    this.size = size;
    applyTheme(this.theme, size);
    save({ theme: this.theme, size });
  }

  toggle() {
    this.isOpen = !this.isOpen;
  }

  close() {
    this.isOpen = false;
  }
}

export const settingsStore = new SettingsStore();
