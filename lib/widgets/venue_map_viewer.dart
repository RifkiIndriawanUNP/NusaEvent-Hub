import 'package:flutter/material.dart';

/// Gambar denah (400x300), dipakai di preview dan di layar penuh.
class VenueMap extends StatelessWidget {
  const VenueMap({super.key});

  Widget _room(String label, double l, double t, double w, double h, Color c) {
    return Positioned(
      left: l,
      top: t,
      width: w,
      height: h,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.55),
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 300,
      child: Stack(
        children: [
          _room('Auditorium', 0, 0, 250, 150, const Color(0xFF9B4DFF)),
          _room('Ruang Seminar A', 250, 0, 150, 75, const Color(0xFF2979FF)),
          _room('Ruang Seminar B', 250, 75, 150, 75, const Color(0xFFFF6A1A)),
          _room('Lab Komputer 1', 0, 150, 130, 150, const Color(0xFFFF4F8B)),
          _room('Lab IoT', 130, 150, 120, 150, const Color(0xFF1FAE4B)),
          _room('Lobi / Registrasi', 250, 150, 150, 150,
              const Color(0xFFE59A1A)),
        ],
      ),
    );
  }
}

/// Kartu denah di tab Gallery. Ketuk untuk membuka layar penuh.
class VenueMapViewer extends StatelessWidget {
  const VenueMapViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF111827),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(color: Colors.white24),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => const VenueMapFullscreen(),
          ),
        ),
        child: const SizedBox(
          height: 210,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: IgnorePointer(
                    child: FittedBox(fit: BoxFit.contain, child: VenueMap()),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Chip(
                  avatar: Icon(Icons.fullscreen, size: 18),
                  label: Text('Layar penuh'),
                  backgroundColor: Colors.white12,
                  side: BorderSide(color: Colors.white24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Halaman denah fullscreen: bisa digeser dan di-zoom.
class VenueMapFullscreen extends StatelessWidget {
  const VenueMapFullscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5,
              boundaryMargin: const EdgeInsets.all(200),
              child: const Center(child: VenueMap()),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Tutup'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}