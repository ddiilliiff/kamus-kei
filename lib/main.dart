import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, QuerySnapshot;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kamus/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kamus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? searchResults;
  
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Search Example'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      // Update searchText when the user types
                      if (value.isEmpty) {
                         Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                              child: StreamBuilder(
                                stream: searchResults,
                                builder: (context, snapshot) {
                              
                                  var documents = snapshot.data?.docs;
                              
                                  return ListView.builder(
                                    itemCount: documents?.length,
                                    itemBuilder: (context, index) {
                                      var document = documents?[index];
                                      return ListTile(
                                        title: Text(
                                          document?[''],
                                          style: TextStyle(fontSize: 30.0),
                                          ),
                                        // subtitle: Text(document?['arti']),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                      }
                      searchText = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Cari Kata',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
            
                IconButton(
                  onPressed: (){
                    performSearch();
                  }, 
                  icon: const Icon(Icons.search)),
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
                      child: Text("Silahkan isikan kata"),
                    );
                  }

              
                  var documents = snapshot.data?.docs;
              
                  return ListView.builder(
                    itemCount: documents?.length,
                    itemBuilder: (context, index) {
                      var document = documents?[index];
                      return ListTile(
                        title: Text(
                          document?['arti'],
                          style: TextStyle(fontSize: 30.0),
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
        .where('kata', isEqualTo: searchText);

    // Update the stream with the new query
    setState(() {
      searchResults = query.snapshots();
    });
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Peringatan'),
          content: Text('Harap masukkan kata kunci untuk melakukan pencarian.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}

}
