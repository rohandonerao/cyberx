import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cyberx/contactcm.dart';
import 'package:cyberx/db_services.dart';
import 'package:cyberx/contacts.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({Key? key}) : super(key: key);

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  late DatabaseHelper databaseHelper;
  List<TContact> contactList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    showList();
  }

  void showList() async {
    List<TContact> contacts = await databaseHelper.getContactList();
    setState(() {
      contactList = contacts;
      count = contactList.length;
    });
  }

  Future<void> deleteContact(TContact contact) async {
    int result = await databaseHelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact removed successfully");
      showList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Contacts'),
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactsPage()),
                  );
                  if (result == true) {
                    showList();
                  }
                },
                child: Text('Add Trusted Contacts'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: count,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(contactList[index].name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await FlutterPhoneDirectCaller.callNumber(
                                  contactList[index].number,
                                );
                              },
                              icon: Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteContact(contactList[index]);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
