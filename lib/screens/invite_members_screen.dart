import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../colors.dart';

class InviteMembersScreen extends StatefulWidget {
  final String stokvelId;

  const InviteMembersScreen({super.key, required this.stokvelId});

  @override
  // ignore: library_private_types_in_public_api
  _InviteMembersScreenState createState() => _InviteMembersScreenState();
}

class _InviteMembersScreenState extends State<InviteMembersScreen> {
  List<Contact> selectedContacts = [];
  final TextEditingController _messageController = TextEditingController();
  String dynamicLink = ""; // Placeholder for generated link
  final Map<String, String> adminCache = {};
  String? stokvelId;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    generateDynamicLink();
    _fetchStokvelId();
  }

  /// Request Contacts Permission
  Future<void> _requestPermissions() async {
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      print("Contacts permission granted");
    } else {
      print("Contacts permission denied");
    }
  }

  Future<void> _fetchStokvelId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final snapshot = await FirebaseDatabase.instance.ref('stokvels').get();

      if (snapshot.exists) {
        final stokvels = snapshot.value as Map<dynamic, dynamic>;
        final entry = stokvels.entries.firstWhere(
          (e) => e.value['createdBy'] == userId,
          orElse: () => MapEntry(null, null),
        );

        if (entry.key != null) {
          setState(() {
            stokvelId = entry.key.toString();
          });
        }
      }
    }
  }

  Stream<DatabaseEvent> fetchMembersStream() {
    if (stokvelId == null) return const Stream.empty();
    return FirebaseDatabase.instance.ref('stokvels/$stokvelId/members').onValue;
  }

  /// Generate Dynamic Link
  Future<void> generateDynamicLink() async {
    String link = await createDynamicLink(widget.stokvelId);
    setState(() {
      dynamicLink = link;
      _messageController.text = """
Hello there,

I'm excited to invite you to join my Stokvel through this app! It’s a fantastic way for us to save, support each other, and reach our financial goals together. 

Download the app and join me today!  
👉 $dynamicLink  

Best regards,  
[Admin Name]
""";
    });
  }

  /// Create Firebase Dynamic Link
  Future<String> createDynamicLink(String stokvelId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: "https://otelainvestmentclubapp.page.link",
      link: Uri.parse(
          "https://otelainvestmentclubapp.com/invite?stokvelId=$stokvelId"),
      androidParameters: AndroidParameters(
        packageName: "com.example.otela_investment_club_app",
        minimumVersion: 1,
        fallbackUrl: Uri.parse(
            "https://www.dropbox.com/scl/fi/wmkpc2lt2fi5tc6bdazka/app-debug.apk?rlkey=vf5r2umfe5izyw42u9tkjgoq0&st=y0rjt4w4&dl=1"), // ✅ Use fallbackUrl here
      ),
      iosParameters: IOSParameters(
        bundleId: "com.yourapp.bundle",
        minimumVersion: "1.0.0",
      ),
      navigationInfoParameters: NavigationInfoParameters(
        forcedRedirectEnabled:
            true, // Forces redirection if the app is not installed
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "Join My Stokvel!",
        description: "Download the app to join our stokvel community.",
        imageUrl: Uri.parse(
            "https://www.dropbox.com/scl/fi/gxowqk6bbl2lpavtnc2xo/logo_no_text.png?rlkey=hdndljrt4h57sl18ppsaji64j&st=omff8zi3&raw=1"),
      ),
    );

    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return shortLink.shortUrl.toString();
  }

  /// Pick Contact
  void pickContact() async {
    try {
      Contact? contact = await FlutterContacts.openExternalPick();

      if (contact != null) {
        // Fetch full contact details
        Contact? fullContact = await FlutterContacts.getContact(contact.id);

        if (fullContact!.phones.isNotEmpty) {
          String cleanedPhone =
              fullContact.phones.first.number.replaceAll(RegExp(r'\D'), '');
          if (cleanedPhone.isNotEmpty) {
            setState(() => selectedContacts.add(fullContact));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text("Selected contact has an invalid phone number.")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Selected contact has no phone number.")),
          );
        }
      }
    } catch (e) {
      print("Error picking contact: $e");
    }
  }

  /// Remove Contact
  void removeContact(Contact contact) {
    setState(() {
      selectedContacts.remove(contact);
    });
  }

  /// Handle Deep Links
  void handleDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? data) {
      final Uri? deepLink = data?.link;
      if (deepLink != null) {
        String? stokvelId = deepLink.queryParameters['stokvelId'];
        if (stokvelId != null) {
          // Navigate user to join the stokvel
        }
      }
    });
  }

  /// Send Invite via WhatsApp and Update Firestore
  Future<void> sendInvite(Contact contact) async {
    if (contact.phones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This contact has no phone number.")),
      );
      return;
    }

    // Sanitize and normalize phone number
    String rawPhone = contact.phones.first.number
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    String phone;

    if (rawPhone.startsWith("0") && rawPhone.length == 10) {
      phone = "+256${rawPhone.substring(1)}";
    } else if (rawPhone.startsWith("256") && rawPhone.length == 12) {
      phone = "+$rawPhone";
    } else if (rawPhone.startsWith("+256") && rawPhone.length == 13) {
      phone = rawPhone;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid phone number format")),
      );
      return;
    }

    final DatabaseReference membersRef = FirebaseDatabase.instance
        .ref()
        .child('stokvels')
        .child(widget.stokvelId)
        .child('members'); // Using phone as the unique key


   await membersRef.child(phone).set({
  'phone': phone,
  'firstName': contact.displayName,
  'status': 'invited',
  'roboAdvisor': false,
  'role': 'member',
  'amountPaid': 0,
  'invitedAt': ServerValue.timestamp,
});


    // Generate WhatsApp message
    String message = Uri.encodeComponent(_messageController.text);
    final Uri whatsappUrl = Uri.parse("https://wa.me/$phone?text=$message");

    // Send WhatsApp message
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
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
          children:  [
            Text("Invite Members",
                style: Theme.of(context).textTheme.displayLarge),
            SizedBox(height: 4),
            Text("Select a contact to invite",
                style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Select Contacts Button
            GestureDetector(
              onTap: pickContact,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darBlue, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Click to Select Contacts",
                      style: TextStyle(color: AppColors.darBlue, fontSize: 12),
                    ),
                    SizedBox(width: 8),
                    SvgPicture.asset("assets/icons/address_book.svg"),
                  ],
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: ListTile(
                        title: Text(contact.displayName ?? "Unknown",
                        style: TextStyle(fontSize: 12),),
                        subtitle: Text(
                          contact.phones.isNotEmpty
                              ? contact.phones.first.number
                              : "No phone number",
                              style: TextStyle(fontSize: 10),
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
              const SizedBox(height: 10),

              // Editable Invitation Message
              TextField(
                controller: _messageController,
                maxLines: 5,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: "Enter Invitation Message", // Acts as a legend
                  labelStyle: TextStyle(
                    color: Colors.grey, // Matches the design
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 10),

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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
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
