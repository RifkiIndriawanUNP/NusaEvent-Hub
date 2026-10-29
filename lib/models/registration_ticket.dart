import 'event_item.dart';

class RegistrationTicket {
  final EventItem event;
  final String name;
  final String nim;
  final String email;
  final String whatsapp;
  final String participantType;
  final DateTime attendDate;
  final String kit;
  final int donation;

  RegistrationTicket({
    required this.event,
    required this.name,
    required this.nim,
    required this.email,
    required this.whatsapp,
    required this.participantType,
    required this.attendDate,
    required this.kit,
    required this.donation,
  });

  String get attendDateText {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${attendDate.day} ${m[attendDate.month - 1]} ${attendDate.year}';
  }
}
