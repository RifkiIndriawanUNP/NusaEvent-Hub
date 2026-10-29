import 'package:flutter/material.dart';
import '../data/sample_events.dart';

Future<String?> showFilterBottomSheet(BuildContext context, String selected) {
  return showModalBottomSheet<String>(
    context: context,
    builder: (ctx) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Filter Kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          for (final c in categories)
            ListTile(
              title: Text(c),
              trailing: c == selected ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(ctx, c),
            ),
        ],
      ),
    ),
  );
}
