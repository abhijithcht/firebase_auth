import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireBaseCrud extends StatefulWidget {
  const FireBaseCrud({Key? key}) : super(key: key);

  @override
  State<FireBaseCrud> createState() => _FireBaseCrudState();
}

class _FireBaseCrudState extends State<FireBaseCrud> {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('todo');

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    title = TextEditingController();
    description = TextEditingController();
    super.initState();
  }

  Future<void> create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      title.text = documentSnapshot['title'];
      description.text = documentSnapshot['description'];
    }
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: title,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: description,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _reference.add({
                      'title': title.text,
                      'description': description.text,
                    });
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          );
        });
  }

  // delete
  Future<void> delete(String id) async {
    await _reference.doc(id).delete();
  }

  // update
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      title.text = documentSnapshot['title'];
      description.text = documentSnapshot['description'];
    }
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  ),
                ),
                TextField(
                  controller: description,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _reference.doc(documentSnapshot!.id).update({
                      'title': title.text,
                      'description': description.text,
                    });
                    title.clear();
                    description.clear();
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            create();
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
        stream: _reference.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    // title: Text(streamSnapshot.data!.docs[index].id),
                    title: Text(documentSnapshot['title']),
                    subtitle: Text(
                      documentSnapshot['description'],
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _update(documentSnapshot);
                            },
                            icon: const Icon(
                              Icons.edit,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              delete(documentSnapshot.id);
                            },
                            icon: const Icon(
                              Icons.delete,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
