// Изоляция страницы (cross-origin isolation) без доступа к заголовкам сервера.
//
// SQLite в браузере хранит базу в OPFS только при доступном
// SharedArrayBuffer, а он есть лишь у страницы с заголовками COOP и COEP.
// GitHub Pages свои заголовки ставить не даёт — их проставляет этот воркер
// на каждый ответ своего источника. Без изоляции drift откатывается на
// IndexedDB: работает, но медленнее.
//
// COEP — `credentialless`, а не `require-corp`: сторонние ресурсы (CanvasKit
// и шрифты с gstatic, pdf.js для предпросмотра) грузятся без cookies и не
// обязаны присылать Cross-Origin-Resource-Policy. Safari `credentialless`
// не знает — там страница остаётся без изоляции, и база живёт в IndexedDB.

self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', (event) => event.waitUntil(self.clients.claim()));

self.addEventListener('fetch', (event) => {
  const request = event.request;
  // Кэш-режим only-if-cached разрешён только для same-origin; иначе fetch
  // бросает, и страница остаётся без ресурса.
  if (request.cache === 'only-if-cached' && request.mode !== 'same-origin') return;

  event.respondWith(
    fetch(request).then((response) => {
      // Непрозрачный ответ (сторонний no-cors) переписать нельзя — и не нужно:
      // заголовки изоляции нужны документу и воркерам, а не картинкам.
      if (response.status === 0) return response;

      const headers = new Headers(response.headers);
      headers.set('Cross-Origin-Opener-Policy', 'same-origin');
      headers.set('Cross-Origin-Embedder-Policy', 'credentialless');
      return new Response(response.body, {
        status: response.status,
        statusText: response.statusText,
        headers,
      });
    }),
  );
});
