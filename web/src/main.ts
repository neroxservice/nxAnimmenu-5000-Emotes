import { mount } from 'svelte';
import './app.css';
import App from './App.svelte';

if (import.meta.env.DEV) document.body.classList.add('dev-bg');

// Harmless ResizeObserver loop warning from virtua's VList — already self-recovers.
window.addEventListener('error', (e) => {
  if (e.message?.includes('ResizeObserver loop')) {
    e.stopImmediatePropagation();
    e.preventDefault();
  }
});

const app = mount(App, {
  target: document.getElementById('app')!,
});

export default app;
