{{flutter_js}}
{{flutter_build_config}}

// Embedded boot: no <body> takeover — Flutter renders inside #flutter-host.
// The Jaspr shell appends this script lazily (see jaspr_shell/web/bridge.js).
_flutter.loader.load({
  config: { entrypointBaseUrl: '/flutter/', canvasKitBaseUrl: '/flutter/canvaskit/' },
  onEntrypointLoaded: async function (engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine({
      hostElement: document.getElementById('flutter-host'),
      assetBase: '/flutter/',
    });
    await appRunner.runApp();
  },
});
