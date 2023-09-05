import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Api/api.dart';
import '../auth/profile_screen.dart';
import '../models/chat_user.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Contact> _contacts = []; // List to store contacts with phone numbers
  final List<ChatUser> _searchList = [];
  List<ChatUser> _list = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() async {
    print('Loading contacts...'); // Add this line for debugging
    Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.toList();
    });
  }

  // void _loadContacts() async {
  //   Iterable<Contact> contacts = await ContactsService.getContacts();
  //   List<Contact> contactsWithPhoneNumbers = [];
  //
  //   // Filter contacts to include only those with phone numbers
  //   for (var contact in contacts) {
  //     if (contact.phones!.isNotEmpty) {
  //       contactsWithPhoneNumbers.add(contact);
  //     }
  //   }
  //
  //   setState(() {
  //     _contacts = contactsWithPhoneNumbers;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Search Contacts'),
                autofocus: true,
                style: TextStyle(fontSize: 16, letterSpacing: 1),
                onChanged: (val) {
                  //search logic
                  _searchList.clear();

                  for (var i in _list) {
                    if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                        i.email.toLowerCase().contains(val.toLowerCase())) {
                      _searchList.add(i);
                      setState(() {
                        _searchList;
                      });
                    }
                  }
                },
              )
            : Text(
                'Contacts',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(
                _isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Profile_Page(
                              user: APIs.me,
                            )));
              },
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.black,
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                Contact contact = _contacts[index];
                return ListTile(
                  title: Text(contact.displayName ?? ''),
                  subtitle: Text(contact.phones!.first.value!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
