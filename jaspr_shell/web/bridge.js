// The page half of the pipe. Two one-way channels; an event emitted while nobody
// listens is held, and the first such event boots Flutter (lazy boot).
(function () {
  function channel(onUnheard) {
    const listeners = [], pending = [];
    return {
      emit(type, payload) {
        const event = { id: Math.random().toString(36).slice(2), type, payload: payload || {} };
        if (listeners.length === 0) { pending.push(event); onUnheard && onUnheard(); return; }
        listeners.slice().forEach((l) => l(event));
      },
      on(listener) {
        listeners.push(listener);
        pending.splice(0).forEach(listener);
        return () => listeners.splice(listeners.indexOf(listener), 1);
      },
    };
  }

  let booted = false;
  function bootFlutter() {
    if (booted) return;
    booted = true;
    const script = document.createElement('script');
    script.src = '/flutter/flutter_bootstrap.js';
    script.async = true;
    document.body.appendChild(script);
  }

  window.pocBridge = { toFlutter: channel(bootFlutter), toPage: channel() };
})();
