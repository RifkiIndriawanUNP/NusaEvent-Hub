import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/venue_map_viewer.dart';
import 'event_registration_screen.dart';
import 'registered_tickets_screen.dart';

class HomeEventsScreen extends StatefulWidget {
  const HomeEventsScreen({super.key});

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  String _category = 'Semua';
  final List<RegistrationTicket> _tickets = [];

  Future<void> _openRegistration(EventItem event) async {
    final ticket = await Navigator.push<RegistrationTicket>(
      context,
      MaterialPageRoute(builder: (_) => EventRegistrationScreen(event: event)),
    );
    if (ticket != null && mounted) {
      setState(() => _tickets.add(ticket));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pendaftaran ${event.title} berhasil!')),
      );
    }
  }

  Widget _eventTab() {
    final list = _category == 'Semua'
        ? sampleEvents
        : sampleEvents.where((e) => e.category == _category).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              Expanded(child: Text('Kategori: $_category')),
              FilledButton.icon(
                icon: const Icon(Icons.filter_list),
                label: const Text('Filter'),
                onPressed: () async {
                  final c = await showFilterBottomSheet(context, _category);
                  if (c != null) setState(() => _category = c);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) => EventCard(
              event: list[i],
              onTap: () => _openRegistration(list[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _galleryTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      children: [
        const VenueMapViewer(),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: sampleEvents.length,
          itemBuilder: (_, i) {
            final e = sampleEvents[i];
            return ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                e.poster,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: e.color,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: Text(e.title, textAlign: TextAlign.center),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final teal = Theme.of(context).colorScheme.primary;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -1.1),
              radius: 1.0,
              colors: [Color(0xFF4A2FB0), Color(0xFF0B1022), Color(0xFF070B14)],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('NusaEvent Hub', style: TextStyle(fontSize: 22)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: teal,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: 'Event', height: 36),
                      Tab(text: 'Gallery', height: 36),
                      Tab(text: 'Ticket', height: 36),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _eventTab(),
                      _galleryTab(),
                      RegisteredTicketsScreen(
                        tickets: _tickets,
                        onCancel: (t) => setState(() => _tickets.remove(t)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}