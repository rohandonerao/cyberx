// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_is_empty, unused_import, use_build_context_synchronously

import 'dart:developer';
import 'package:contacts_service/contacts_service.dart';
import 'package:cyberx/contactcm.dart';
import 'package:cyberx/db_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
    searchController.addListener(filterContacts);
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAll(RegExp(r'[^\d]'), '');
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermission();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
    } else {
      handleInvalidPermission(permissionStatus);
    }
  }

  void handleInvalidPermission(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.permanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Permission Denied"),
          content: Text(
              "You need to grant contacts permission to use this feature."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<PermissionStatus> getContactsPermission() async {
    PermissionStatus permission =
        await Permission.contacts.request(); // Request permission
    return permission;
  }

  Future<void> getAllContacts() async {
    List<Contact> _contacts =
        await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = _contacts;
      contactsFiltered = _contacts;
    });
  }

  void filterContacts() {
    List<Contact> filteredContacts = [];
    String searchTerm = searchController.text.toLowerCase();

    if (searchTerm.isEmpty) {
      setState(() {
        contactsFiltered = contacts;
      });
      return;
    }

    for (var contact in contacts) {
      String contactName = contact.displayName?.toLowerCase() ?? '';
      if (contactName.contains(searchTerm)) {
        filteredContacts.add(contact);
      } else {
        for (var phone in contact.phones ?? []) {
          String phoneNumber =
              phone.value?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
          if (phoneNumber.contains(searchTerm)) {
            filteredContacts.add(contact);
            break;
          }
        }
      }
    }

    setState(() {
      contactsFiltered = filteredContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.blue,
      ),
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: "Search Contacts",
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: contactsFiltered.isEmpty
                        ? Center(
                            child: Text("No contacts found"),
                          )
                        : ListView.builder(
                            itemCount: contactsFiltered.length,
                            itemBuilder: (BuildContext context, int index) {
                              Contact contact = contactsFiltered[index];
                              String phoneNumber = contact.phones!.isEmpty
                                  ? 'No Phone Number'
                                  : contact.phones!.first.value!;
                              return ListTile(
                                title: Text(contact.displayName ?? 'No Name'),
                                subtitle: Text(phoneNumber),
                                leading: contact.avatar != null &&
                                        contact.avatar!.isNotEmpty
                                    ? CircleAvatar(
                                        backgroundImage:
                                            MemoryImage(contact.avatar!),
                                      )
                                    : CircleAvatar(
                                        child: Text(contact.initials()),
                                      ),
                                onTap: () {
                                  if (contact.phones!.length > 0) {
                                    final String phoneNum =
                                        contact.phones!.elementAt(0).value!;
                                    final String name = contact.displayName!;
                                    addContact(TContact(phoneNum, name));
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: Text("Phone Number Missing"),
                                        content: Text(
                                            "Oops! The phone number of this contact does not exist."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("OK"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  void addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    String message =
        (result != 0) ? "Contact Added Successfully" : "Contact Adding Failed";

    Fluttertoast.showToast(msg: "Contact Added successfully");
    Navigator.of(context).pop(true);
  }
}
