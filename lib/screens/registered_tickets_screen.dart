import 'package:flutter/material.dart';
import '../models/registration_ticket.dart';
import '../widgets/event_card.dart';

/// Memotong sisi bawah dengan dua lekukan setengah lingkaran (kiri & kanan).
class _TopTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    const r = 12.0;
    final p = Path()..addRRect(RRect.fromLTRBAndCorners(0, 0, s.width, s.height,
        topLeft: const Radius.circular(24), topRight: const Radius.circular(24)));
    final cut = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, s.height), radius: r))
      ..addOval(Rect.fromCircle(center: Offset(s.width, s.height), radius: r));
    return Path.combine(PathOperation.difference, p, cut);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}

/// Memotong sisi atas dengan dua lekukan setengah lingkaran (kiri & kanan).
class _BottomTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    const r = 12.0;
    final p = Path()..addRRect(RRect.fromLTRBAndCorners(0, 0, s.width, s.height,
        bottomLeft: const Radius.circular(24),
        bottomRight: const Radius.circular(24)));
    final cut = Path()
      ..addOval(Rect.fromCircle(center: const Offset(0, 0), radius: r))
      ..addOval(Rect.fromCircle(center: Offset(s.width, 0), radius: r));
    return Path.combine(PathOperation.difference, p, cut);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      final n = (c.maxWidth / 6).floor();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          n,
          (_) => const SizedBox(
            width: 3,
            height: 1.5,
            child: DecoratedBox(decoration: BoxDecoration(color: Colors.white54)),
          ),
        ),
      );
    });
  }
}

class _TicketCard extends StatelessWidget {
  final RegistrationTicket t;
  const _TicketCard(this.t);

  @override
  Widget build(BuildContext context) {
    final mid = Color.lerp(t.event.color, t.event.colorEnd, 0.5)!;
    BoxDecoration grad(Color a, Color b) => BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [a, b],
          ),
        );
    return Column(
      children: [
        ClipPath(
          clipper: _TopTicketClipper(),
          child: Container(
            width: double.infinity,
            decoration: grad(t.event.color, mid),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20, color: Colors.white)),
                const SizedBox(height: 2),
                Text('${t.event.category} | ${t.participantType}',
                    style: const TextStyle(color: Colors.white70)),
                Text('${t.name} (${t.nim})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
        ClipPath(
          clipper: _BottomTicketClipper(),
          child: Container(
            width: double.infinity,
            decoration: grad(mid, t.event.colorEnd),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: _DashedLine(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          InfoPill(t.attendDateText),
                          InfoPill(t.kit),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(child: InfoPill(t.event.venue)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RegisteredTicketsScreen extends StatelessWidget {
  final List<RegistrationTicket> tickets;
  final void Function(RegistrationTicket) onCancel;

  const RegisteredTicketsScreen(
      {super.key, required this.tickets, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return const Center(child: Text('Belum ada tiket terdaftar'));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: tickets.length,
      itemBuilder: (context, i) {
        final t = tickets[i];
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Dismissible(
            key: ObjectKey(t),
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red.shade300,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (_) async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Batalkan Tiket?'),
                  content: Text('Batalkan pendaftaran ${t.event.title}?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Tidak')),
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Ya')),
                  ],
                ),
              );
              return ok ?? false;
            },
            onDismissed: (_) {
              onCancel(t);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tiket dibatalkan')),
              );
            },
            child: _TicketCard(t),
          ),
        );
      },
    );
  }
}