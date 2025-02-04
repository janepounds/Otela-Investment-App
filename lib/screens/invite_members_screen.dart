import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../colors.dart';

class InviteMembersScreen extends StatefulWidget {
  final String stokvelId;

  const InviteMembersScreen({super.key, required this.stokvelId});

  @override
  _InviteMembersScreenState createState() => _InviteMembersScreenState();
}

class _InviteMembersScreenState extends State<InviteMembersScreen> {
  List<Contact> selectedContacts = [];
  String invitationMessage = "Hey! Join my Stokvel on this app. It's a great way to save together!";

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      print("Contacts permission granted");
    } else {
      print("Contacts permission denied");
    }
  }

  void pickContact() async {
    try {
      Contact? contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        setState(() => selectedContacts.add(contact));
      }
    } catch (e) {
      print("Error picking contact: $e");
    }
  }

  void removeContact(Contact contact) {
    setState(() {
      selectedContacts.remove(contact);
    });
  }

Future<void> sendInvite(Contact contact) async {
  if (contact.phones.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("This contact has no phone number.")),
    );
    return;
  }

  String phone = contact.phones.first.number.replaceAll(RegExp(r'\D'), '');
  if (!phone.startsWith("+")) {
    phone = "+$phone"; // Ensure correct country code
  }

  String message = Uri.encodeComponent("Hi, join my Stokvel! 📲");

  // Android-specific WhatsApp intent
  final Uri whatsappAndroid = Uri.parse("whatsapp://send?phone=$phone&text=$message");

  // iOS-specific WhatsApp link
  final Uri whatsappIOS = Uri.parse("https://wa.me/$phone?text=$message");

  if (await canLaunchUrl(whatsappAndroid)) {
    await launchUrl(whatsappAndroid, mode: LaunchMode.externalApplication);
  } else if (await canLaunchUrl(whatsappIOS)) {
    await launchUrl(whatsappIOS, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Couldn't open WhatsApp")),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Invite Members", style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: 4),
            Text("Select a contact to invite", style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Contact Selection Card
            GestureDetector(
              onTap: pickContact,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.blue, width: 1.5),
                ),
                child: const ListTile(
                  leading: Icon(Icons.person_add, color: Colors.blue),
                  title: Text("Select a Contact"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Selected Contacts List
            if (selectedContacts.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: selectedContacts.length,
                  itemBuilder: (context, index) {
                    var contact = selectedContacts[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: ListTile(
                        title: Text(contact.displayName ?? "Unknown"),
                        subtitle: Text(
                          contact.phones.isNotEmpty ? contact.phones.first.number : "No phone number",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeContact(contact),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Editable Invitation Message
              TextField(
                maxLines: 3,
                onChanged: (value) => setState(() => invitationMessage = value),
                decoration: InputDecoration(
                  hintText: "Type your custom message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Invite Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (selectedContacts.isNotEmpty) {
                      sendInvite(selectedContacts.first);
                    }
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text("Send Invite"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDAB669),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
