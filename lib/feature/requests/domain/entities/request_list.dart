import 'material_request.dart';

/// Отобранные заявки вместе с общим числом заявок.
///
/// Общее число приезжает тем же запросом, а не отдельным: подзаголовок
/// «3 заявки» считает все, а список под фильтром — только подходящие,
/// и два независимых запроса ради одного экрана рано или поздно разъедутся.
class RequestList {
  const RequestList({required this.items, required this.total});

  final List<MaterialRequest> items;
  final int total;
}
