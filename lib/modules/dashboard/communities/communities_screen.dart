import 'package:flutter/material.dart';

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> counter = ValueNotifier<int>(0);
    final ValueNotifier<int> counter2 = ValueNotifier<int>(0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Communities",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        actions: [Icon(Icons.more_vert)],
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
             valueListenable:counter ,
        builder: (_, value1, __) =>
            ValueListenableBuilder<int>(
              valueListenable: counter,
              builder: (_, value2, __) => Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text("Count:$value1", style: TextStyle(fontSize: 24)),
              ),
            ),
          ),

          ValueListenableBuilder<int>(
            valueListenable: counter,
            builder: (_, value, __) => Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text("Count:$value", style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.value = counter.value + 1,
        child: Icon(Icons.add),
      ),
    );
  }
}
