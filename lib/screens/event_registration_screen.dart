import 'package:flutter/material.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';

class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;
  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _nimC = TextEditingController();
  final _emailC = TextEditingController();
  final _waC = TextEditingController();

  String _type = 'Mahasiswa';
  DateTime? _date;
  String _kit = 'Reguler';
  int _donation = 0;
  bool _agree = false;
  bool _showAgreeError = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameC.dispose();
    _nimC.dispose();
    _emailC.dispose();
    _waC.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 11, 10),
      firstDate: DateTime(2026, 11, 1),
      lastDate: DateTime(2026, 12, 31),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState!.validate();
    setState(() => _showAgreeError = !_agree);
    if (!valid || _date == null || !_agree) {
      if (_date == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pilih tanggal kehadiran')));
      }
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pop(
      context,
      RegistrationTicket(
        event: widget.event,
        name: _nameC.text.trim(),
        nim: _nimC.text.trim(),
        email: _emailC.text.trim(),
        whatsapp: _waC.text.trim(),
        participantType: _type,
        attendDate: _date!,
        kit: _kit,
        donation: _donation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar: ${widget.event.title}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameC,
                      decoration: const InputDecoration(
                          labelText: 'Nama', border: OutlineInputBorder()),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Nama wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nimC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'NIM', border: OutlineInputBorder()),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'NIM wajib diisi';
                        }
                        if (!RegExp(r'^\d{8,12}$').hasMatch(v.trim())) {
                          return 'NIM harus 8-12 digit angka';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email', border: OutlineInputBorder()),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email wajib diisi';
                        }
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(v.trim())) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _waC,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: 'Nomor WhatsApp',
                          border: OutlineInputBorder()),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nomor WhatsApp wajib diisi';
                        }
                        if (!RegExp(r'^(08|\+628)\d{8,12}$')
                            .hasMatch(v.trim())) {
                          return 'Gunakan format 08xxx atau +628xxx';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Tipe Peserta'),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final t in ['Mahasiswa', 'Umum', 'Dosen'])
                          ChoiceChip(
                            label: Text(t),
                            selected: _type == t,
                            onSelected: (_) => setState(() => _type = t),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(_date == null
                              ? 'Tanggal kehadiran: belum dipilih'
                              : 'Tanggal kehadiran: ${_date!.day}/${_date!.month}/${_date!.year}'),
                        ),
                        FilledButton(
                            onPressed: _pickDate, child: const Text('Pilih')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _kit,
                      decoration: const InputDecoration(
                          labelText: 'Paket Seminar Kit',
                          border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(
                            value: 'Reguler', child: Text('Reguler')),
                        DropdownMenuItem(
                            value: 'Premium', child: Text('Premium')),
                        DropdownMenuItem(
                            value: 'Tanpa Kit', child: Text('Tanpa Kit')),
                      ],
                      onChanged: (v) => setState(() => _kit = v!),
                    ),
                    const SizedBox(height: 16),
                    Text('Donasi: Rp $_donation'),
                    Slider(
                      value: _donation.toDouble(),
                      min: 0,
                      max: 100000,
                      divisions: 10,
                      label: 'Rp $_donation',
                      onChanged: (v) => setState(() => _donation = v.round()),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _agree,
                      title: const Text('Saya menyetujui tata tertib acara'),
                      onChanged: (v) => setState(() {
                        _agree = v ?? false;
                        _showAgreeError = !_agree;
                      }),
                    ),
                    if (_showAgreeError)
                      Text('Anda harus menyetujui tata tertib',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: _submit, child: const Text('Daftar')),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}