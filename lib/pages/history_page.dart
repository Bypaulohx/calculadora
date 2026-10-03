import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<String> history;

  const HistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Histórico', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'Nenhum cálculo realizado',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  color: Colors.deepPurple[800],
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orangeAccent,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      history[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}