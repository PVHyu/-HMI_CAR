import 'package:flutter/material.dart';
import '../../viewmodels/phone_viewmodel.dart';

class ContactList extends StatelessWidget {
  final PhoneViewModel viewModel;

  const ContactList({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: viewModel.contacts.length,
      itemBuilder: (_, i) {
        final contact = viewModel.contacts[i];
        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey.shade700.withOpacity(0.9),
            child: Text(
              contact.name[0],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(contact.name, style: const TextStyle(fontSize: 18)),
          subtitle: Text(
            contact.number,
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.call, color: Colors.green),
            iconSize: 30,
            onPressed: () => viewModel.callFromContact(contact.number),
          ),
        );
      },
    );
  }
}
