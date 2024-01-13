import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart" show FirebaseFirestore, QuerySnapshot;

class KeiIndo extends StatefulWidget {
  const KeiIndo({super.key});

  @override
  State<KeiIndo> createState() => _KeiIndoState();
}

class _KeiIndoState extends State<KeiIndo> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? searchResults;
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Kei - Indonesia'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    // Update searchText when the user types
                    
                    searchText = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Kei',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 40.0, bottom: 0)),
                ElevatedButton(
                  onPressed: (){
                    performSearch();
                  }, 
                  child: const Text('Terjemahkan'),),
              ],
            ),
          ),
          

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: StreamBuilder(
                stream: searchResults,
                builder: (context, snapshot) {
              
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
              
                  if (!snapshot.hasData) {
                    return const SizedBox(
                      // child: Text("Silahkan isikan kata"),
                    );
                  }

              
                  var documents = snapshot.data?.docs;
              
                  return ListView.builder(
                    itemCount: documents?.length,
                    itemBuilder: (context, index) {
                      var document = documents?[index];
                      return ListTile(
                        title: Text(
                          document?['kata'],
                          style: const TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          ),
                        // subtitle: Text(document?['arti']),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void performSearch() async {
  // Query Firestore with the searchText
  if (searchText.isNotEmpty) {
    var query = FirebaseFirestore.instance
        .collection('kamus')
        .where('arti', isEqualTo: searchText.toLowerCase());

    var querySnapshot = await query.get();

    // Update the stream with the new query
    setState(() {
      searchResults = Stream.value(querySnapshot);
    });

    if (querySnapshot.docs.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak Ada Kata'))
      );
    }

  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Peringatan'),
          content: const Text('Harap masukkan kata kunci untuk melakukan pencarian.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
}