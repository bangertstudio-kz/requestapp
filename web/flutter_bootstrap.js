{{flutter_js}}
{{flutter_build_config}}

// Без serviceWorkerSettings: воркер Flutter устарел и кэширует старые
// сборки, а область сайта занимает coi-serviceworker.js — на одной
// области браузер держит только один воркер.
_flutter.loader.load();
