import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlutterFlavorExample());
}

class FlutterFlavorExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<CounterNotifier, CounterState>(
      create: (context) => CounterNotifier(),
      child: MaterialApp(
          title: 'FlutterFlavorExample',
          home: Scaffold(
            appBar: AppBar(
              title: const Text('FlutterFlavorExample'),
            ),
            body: Center(
              child: Home(),
            ),
          )),
    );
  }
}

class Home extends StatelessWidget {
  final _infoStream = FirebaseFirestore.instance.collection('Info').snapshots();

  @override
  Widget build(BuildContext context) {
    final count = context.select((CounterState s) => s.count).toString();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<CounterNotifier>().increment();
          },
          child: Icon(Icons.add),
        ),
        Text(count),
        StreamBuilder(
          stream: _infoStream,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading');
            }
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Text(snapshot.data!.docs[index]['flavor'] as String),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class CounterState {
  CounterState(this.count);
  int count;
}

class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(CounterState(0));

  void increment() {
    state = CounterState(++state.count);
  }
}
