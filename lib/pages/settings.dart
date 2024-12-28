import 'package:checkmate/controllers/auth_controller.dart';
import 'package:checkmate/controllers/firestore_controller.dart';
import 'package:checkmate/controllers/user_provider.dart';
import 'package:checkmate/main.dart';
import 'package:checkmate/models/toast.dart';
import 'package:checkmate/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkMode = false;
  bool notifEnabled = true;
  String? selectedLang = "English";
  bool sharingAllowed = true;

  @override
  Widget build(BuildContext context) {
    UserModel user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: appBar(context, "Settings"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              __generalSection(),
              const Divider(),
              __accountManagement(user.name, user.email),
              const Divider(),
              __backup(),
              const Divider(),
              __about(),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Column __about() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("About",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildSettingTile(
          leading: Icons.info_outline,
          title: "App Version",
          subtitle: "Version 1.0.0, Build 100",
        ),
        _buildSettingTile(
          leading: Icons.feedback_outlined,
          title: "Support / Feedback",
          onTap: () {},
        ),
        _buildSettingTile(
          leading: Icons.open_in_new_sharp,
          title: "Credits",
          subtitle: "Redirect to the authors page of the application",
          onTap: () {},
        )
      ],
    );
  }

  Column __backup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Backup and Restore",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildExpansionTile(
          icon: Icons.cloud_upload,
          title: "Backup Data",
          children: [
            _buildSettingTile(
              leading: Icons.backup_outlined,
              title: "Backup Tasks",
              subtitle: "Upload tasks to the cloud",
              onTap: () {},
            ),
            _buildSettingTile(
              leading: Icons.file_upload_outlined,
              title: "Export Tasks",
              subtitle: "Export your tasks to a text file",
              onTap: () {},
            ),
          ],
        ),
        _buildSettingTile(
          title: "Restore Data",
          subtitle:
              "Restore data from the cloud\nNote: This may affect your progress!",
          leading: Icons.restore,
          onTap: () {},
        ),
      ],
    );
  }

  Column __accountManagement(String? name, String? email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Account Management",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildExpansionTile(
          icon: Icons.person,
          title: "Profile Information",
          children: [
            _buildSettingTile(
                title: "Name",
                subtitle: (name != null) ? name : "Your Name",
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Maybe add a 2 hours cooldown before changing the name again
                    // Add a dialog to edit the name
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final TextEditingController _nameController =
                              TextEditingController();
                          return AlertDialog(
                            title: const Text("Edit Name"),
                            content: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: "Enter your new name",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (_nameController.text.isNotEmpty) {
                                    // Update the name in the database
                                    await FirestoreDataSource().updateName(
                                        _nameController.text.trim(), context);
                                    showToast("Name updated successfully",
                                        Colors.blue);
                                    Navigator.pop(context);
                                  } else {
                                    showToast(
                                        "Name cannot be empty", Colors.red);
                                  }
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          );
                        });
                  },
                )),
            _buildSettingTile(
                title: "E-mail",
                subtitle: (email != null) ? email : "email@example.com"),
            _buildSettingTile(title: "Logo"),
          ],
        ),
        _buildExpansionTile(
            icon: Icons.sync, title: "Sync Options", children: []),
        _buildExpansionTile(
          icon: Icons.security,
          title: "Security and Privacy",
          children: [
            _buildSettingTile(
                title: "Reset your Password"), // Maybe Redirect to another page
            _buildSettingTile(
              title: "Allow data sharing",
              subtitle:
                  "Allow Checkmate to collect data and analyics to enhance user experience",
              trailing: Switch(
                  value: sharingAllowed,
                  onChanged: (value) {
                    setState(() {
                      sharingAllowed = value;
                    });
                  }),
            ),
          ],
        ),
        _buildSettingTile(
          leading: Icons.exit_to_app_sharp,
          title: "Sign out",
          subtitle: "Log out from your account",
          // Log out from the session and redirect to the Home page
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Sign Out"),
                  content: const Text("Are you sure you want to sign out?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await AuthController().signOut();
                        AuthController().signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/login",
                          (Route<dynamic> route) =>
                              false, // Removes all routes in the stack
                        );
                      },
                      child: const Text("Sign Out"),
                    ),
                  ],
                );
              },
            );
          },
        ),
        _buildSettingTile(
          leading: Icons.delete_forever_outlined,
          title: "Delete Account Forever",
          subtitle: "This action is irreversible!",
          onTap: () async {
            final User? user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              showToast("No user is signed in!", Colors.red);
              return;
            }

            final List<UserInfo> providerData = user.providerData;
            final bool isEmailUser =
                providerData.any((info) => info.providerId == "password");
            final bool isGoogleUser =
                providerData.any((info) => info.providerId == "google.com");
            final bool isGithubUser =
                providerData.any((info) => info.providerId == "github.com");

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Delete Account"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                          "Are you sure you want to delete your account? This action is irreversible!"),
                      const SizedBox(height: 10),
                      if (isGoogleUser || isGithubUser)
                        const Text(
                            "You will be asked to reauthenticate with your provider."),
                      if (isEmailUser)
                        const Text(
                            "You will be asked to enter your password to proceed."),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await AuthController().deleteAccount(context: context);
                      },
                      child: const Text("Delete"),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Column __generalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("General Settings",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildSettingTile(
          leading: Icons.color_lens_outlined,
          title: "App Theme",
          subtitle: "Light/Dark mode",
          trailing: ValueListenableBuilder(
            valueListenable: themeNotifier,
            builder: (_, mode, __) {
              return Switch(
                value: mode == ThemeMode.dark,
                onChanged: (value) {
                  themeNotifier.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
        ),
        _buildSettingTile(
          leading: Icons.language,
          title: "App Language",
          subtitle: "Select your preferred language",
          trailing: DropdownButton<String>(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            value: selectedLang,
            items: ["Arabic", "English"].map((String language) {
              return DropdownMenuItem(value: language, child: Text(language));
            }).toList(),
            onChanged: (String? newVal) {
              setState(() {
                selectedLang = newVal;
              });
            },
          ),
        ),
        // Add a check to check if the user is on a mobile phone
        _buildSettingTile(
          leading: Icons.notifications_active_outlined,
          title: "Notifications",
          subtitle: "Enable Task Reminders",
          trailing: Switch(
            value: notifEnabled,
            onChanged: (value) {
              setState(
                () {
                  notifEnabled = value;
                },
              );
            },
          ),
        ),
        // _buildSettingTile(title: "Sound and Vibration", subtitle: "Enable sound and vibration"),
      ],
    );
  }

  Widget _buildSettingTile({
    IconData? leading,
    required final title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: leading != null ? Icon(leading, size: 30) : null,
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
    );
  }

  ExpansionTile _buildExpansionTile({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, size: 30),
      tilePadding: EdgeInsets.symmetric(horizontal: 0),
      childrenPadding: EdgeInsets.symmetric(horizontal: 10),
      title: Text(title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      children: children,
    );
  }
}
