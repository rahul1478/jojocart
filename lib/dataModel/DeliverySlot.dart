import 'package:get/get.dart';


class DeliverySlot {
  final String id;
  final String title;
  final int price;
  final String description;
  final List<TimeSlot> expressSlots;

  DeliverySlot({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.expressSlots,
  });
}

class TimeSlot {
  final int id;
  final String time;

  TimeSlot({required this.id, required this.time});
}



