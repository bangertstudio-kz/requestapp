import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:request/feature/catalog/domain/entities/item_unit.dart';
import 'package:request/feature/requests/data/request_documents.dart';
import 'package:request/feature/requests/data/request_pdf.dart';
import 'package:request/feature/requests/data/request_xlsx.dart';
import 'package:request/feature/requests/domain/entities/material_request.dart';
import 'package:request/feature/requests/domain/entities/request_document.dart';
import 'package:request/feature/requests/domain/entities/request_item.dart';
import 'package:request/feature/requests/domain/entities/request_status.dart';
import 'package:request/feature/requests/domain/entities/send_format.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final request = MaterialRequest(
    id: '7',
    name: 'Склад №3, расходники',
    createdAt: DateTime(2026, 9, 6),
    status: RequestStatus.draft,
    folderId: null,
    items: const [
      RequestItem(
        id: '1',
        itemId: '42',
        // Настоящее название из прайса заказчика: с кавычкой и слешами.
        // Склейка строк сломалась бы ровно здесь.
        name: 'Кран ⌀½" н.р./в.р.',
        path: ['Металлический фитинг', 'Кран'],
        quantity: 4,
        unit: ItemUnit.piece,
      ),
      RequestItem(
        id: '2',
        name: '',
        path: ['', ''],
        quantity: 45,
        unit: ItemUnit.meter,
      ),
    ],
  );

  group('Excel', () {
    test('лист называется как заявка, а не Sheet1', () {
      final rows = readXlsxRows(requestToXlsx(request));

      // Книга с «Sheet1» не подсказывает, что в ней, когда таких файлов
      // в почте десяток.
      expect(rows, isNotEmpty);
      expect(rows.first, ['№', 'Материал', 'Кол-во', 'Ед.']);
    });

    test('название с кавычкой доезжает посимвольно', () {
      final rows = readXlsxRows(requestToXlsx(request));

      // Настоящее название из прайса: с кавычкой и слешами.
      expect(rows[1][1], 'Кран ⌀½" н.р./в.р.');
    });

    test('позиция удалённого материала остаётся, но с подписью', () {
      final rows = readXlsxRows(requestToXlsx(request));

      // Позиция — часть документа: количество и её место в нём не исчезают
      // оттого, что материал убрали из справочника. Пустая клетка
      // у получателя заметнее, чем на экране.
      expect(rows, hasLength(3));
      expect(rows[2][1], 'Материал удалён');
      expect(rows[2][2], '45');
      expect(rows[2][3], 'м.п.');
    });

    test('количества и единицы совпадают с заявкой', () {
      final rows = readXlsxRows(requestToXlsx(request));

      expect(rows.skip(1).map((row) => row[2]), ['4', '45']);
      expect(rows.skip(1).map((row) => row[3]), ['шт.', 'м.п.']);
    });

    test('нумерация позиций сквозная и начинается с единицы', () {
      final rows = readXlsxRows(requestToXlsx(request));

      expect(rows.skip(1).map((row) => row[0]), ['1', '2']);
    });
  });

  group('PDF', () {
    test('документ собирается и не пуст', () async {
      final fonts = await RequestPdfFonts.fromBundle();
      final bytes = await requestToPdf(request, fonts);

      expect(bytes.length, greaterThan(1000));
      // %PDF — иначе это не PDF, чем бы оно ни было.
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('знак диаметра заменяется на тот, что есть в шрифте', () {
      // В прайсе диаметр записан двумя разными знаками, и ни одного из них
      // нет в IBM Plex: на экране их дорисовывает система, а в PDF пакет
      // молча выбросил бы символ. «Труба 100/2000» у поставщика читается
      // как другая позиция.
      expect(pdfSafeText('Труба ⌀100/2000'), 'Труба Ø100/2000');
      expect(pdfSafeText('Труба ∅25'), 'Труба Ø25');
      // Остальное не трогаем: стрелка, «№» и кавычки в шрифте есть.
      expect(pdfSafeText('Склад №3 → «Бур»'), 'Склад №3 → «Бур»');
    });

    test('в таблицу уезжает исходное название, без подстановки', () {
      // Подстановка — обход дырки в шрифте PDF. В Excel шрифт свой,
      // и менять там символ значит менять содержимое документа.
      expect(readXlsxRows(requestToXlsx(request))[1][1], contains('⌀'));
    });

    test('кириллический шрифт доезжает из дизайн-системы', () async {
      final fonts = await RequestPdfFonts.fromBundle();
      // Без встроенного шрифта пакет напечатал бы квадраты, а документ
      // собрался бы без единой ошибки — проверять больше негде.
      expect(fonts.regular.fontName, contains('IBMPlex'));
    });
  });

  group('файлы', () {
    late Directory temporary;
    late Directory documents;
    late FileRequestDocuments builder;

    setUp(() async {
      temporary = await Directory.systemTemp.createTemp('request-temp');
      documents = await Directory.systemTemp.createTemp('request-docs');
      builder = FileRequestDocuments(
        temporaryDirectory: () async => temporary,
        documentsDirectory: () async => documents,
      );
    });

    tearDown(() async {
      await temporary.delete(recursive: true);
      await documents.delete(recursive: true);
    });

    test('формат решает, сколько файлов собрать', () async {
      expect(await builder.build(request, SendFormat.xlsx), hasLength(1));
      expect(await builder.build(request, SendFormat.pdf), hasLength(1));
      expect(await builder.build(request, SendFormat.both), hasLength(2));
    });

    test('отправка кладёт во временный каталог, сохранение — в документы',
        () async {
      final forSending = await builder.build(request, SendFormat.both);
      final forKeeping = await builder.save(request);

      expect(forSending.every((d) => d.path.startsWith(temporary.path)), isTrue);
      expect(forKeeping.every((d) => d.path.startsWith(documents.path)), isTrue);
      // «Сохранить на устройство» кладёт оба формата независимо от того,
      // чем в прошлый раз отправляли.
      expect(forKeeping.map((d) => d.format), DocumentFormat.values);
    });

    test('имя файла латиницей, с датой и без мусора', () async {
      final document = (await builder.build(request, SendFormat.xlsx)).single;

      // «Склад №3, расходники» на чужом компьютере не должно превратиться
      // в «%D0%A1%D0%BA...» — такие файлы ищут потом по дате изменения.
      expect(document.name, 'zayavka-2026-09-06-sklad-3-rashodniki.xlsx');
      expect(document.sizeBytes, greaterThan(0));
      expect(await File(document.path).exists(), isTrue);
    });

    test('файлы пересобираются, а не берутся из прошлого раза', () async {
      await builder.build(request, SendFormat.xlsx);
      final renamed = request.withName('Другое название');

      final document = (await builder.build(renamed, SendFormat.xlsx)).single;

      expect(document.name, contains('drugoe-nazvanie'));
      expect(await File(document.path).exists(), isTrue);
    });
  });
}
