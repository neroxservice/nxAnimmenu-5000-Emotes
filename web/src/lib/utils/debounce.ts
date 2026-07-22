/**
 * Returns a debounced wrapper around `fn`. The wrapper exposes a `cancel`
 * method to drop a pending call (useful in component teardown).
 */
export function debounce<A extends unknown[]>(
  fn: (...args: A) => void,
  wait = 150,
): ((...args: A) => void) & { cancel: () => void } {
  let timer: ReturnType<typeof setTimeout> | undefined;

  const debounced = ((...args: A) => {
    if (timer !== undefined) clearTimeout(timer);
    timer = setTimeout(() => {
      timer = undefined;
      fn(...args);
    }, wait);
  }) as ((...args: A) => void) & { cancel: () => void };

  debounced.cancel = () => {
    if (timer !== undefined) {
      clearTimeout(timer);
      timer = undefined;
    }
  };

  return debounced;
}
