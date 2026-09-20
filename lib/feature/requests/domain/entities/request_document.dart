/// Один файл заявки — то, что уйдёт поставщику.
///
/// Путь, имя и размер вместе, а не голый `String path`: экран предпросмотра
/// показывает все три, и добывать размер из файловой системы заново в каждом
/// месте — три способа по-разному округлить килобайты.
class RequestDocument {
  const RequestDocument({
    required this.format,
    required this.name,
    required this.path,
    required this.sizeBytes,
  });

  final DocumentFormat format;

  /// Имя, которое увидит получатель: `zayavka-2026-09-06-stoyaki-b2.xlsx`.
  final String name;

  final String path;
  final int sizeBytes;
}

/// Ровно один файл — в отличие от `SendFormat`, где `both` означает два.
enum DocumentFormat { xlsx, pdf }
