import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kamus/firebase_options.dart';
import 'package:kamus/page/indo_key.dart';
import 'package:kamus/page/kei_indo.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      initialRoute: '/',
      routes: {
        '/' : (context) => const MyHomePage(),
        '/indo' : (context) => const IndoKey(),
        '/kei'  : (context) => const KeiIndo(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            child: const Image(
              image: AssetImage('assets/ocep.jpg'),
              fit: BoxFit.cover,
              ),
          ),
          SizedBox(
            width: 500.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/indo');
                  }, 
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue
                    ),
                  child: const Text(
                    "INDONESIA - KEI",
                    style: TextStyle(
                      fontSize: 30.0
                    ),
                    )
                  ),
                const SizedBox(height: 30.0,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/kei');
                  }, 
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue
                    ),
                  child: const Text(
                    "KEI - INDONESIA",
                    style: TextStyle(
                      fontSize: 30.0
                    ),
                    )
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
