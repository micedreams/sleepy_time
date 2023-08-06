import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep time',
      theme: ThemeData(
        brightness: Brightness.dark,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  final wakeupTimesNotifier = ValueNotifier([]);
  final sleepNowNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ValueListenableBuilder(
          valueListenable: wakeupTimesNotifier,
          builder: (context, value, _) => Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/night.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: Text(
                    'Sleepytime',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 8.0,
                  ),
                  child: Text(
                    'I have to wake up at:',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 4.0),
                  child: Button(onTap: onSleepLater, lable: 'Go'),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 8.0,
                    top: 8.0,
                  ),
                  child: Text(
                    'or, find out when to wake up:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 4.0),
                  child: Button(onTap: onSleepNow, lable: 'Sleep now'),
                ),
                if (value.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: sleepNowNotifier,
                        builder: (BuildContext context, value, _) {
                          return Padding(
                            padding: const EdgeInsetsDirectional.only(
                              top: 16.0,
                              start: 8.0,
                            ),
                            child: Text(value
                                ? 'Sleep now, wake up at...'
                                : 'Go to bed at one of the following times:'),
                          );
                        },
                      ),
                      Wrap(
                        children: value
                            .map((i) => Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      DateFormat('kk:mm').format(i),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );

  void onSleepNow() {
    final now = DateTime.now();
    final wakeupTimes = [];

    for (int i = 0; i < 6; i++) {
      if (wakeupTimes.isEmpty) {
        wakeupTimes.add(now.add(const Duration(
          hours: 1,
          minutes: 45,
        )));
      } else {
        wakeupTimes.add(wakeupTimes.last.add(const Duration(
          hours: 1,
          minutes: 30,
        )));
      }
    }

    sleepNowNotifier.value = true;
    wakeupTimesNotifier.value = wakeupTimes;
  }

  void onSleepLater() {
    final wakeupTimes = [];

    sleepNowNotifier.value = false;
    wakeupTimesNotifier.value = wakeupTimes;
  }
}

class Button extends StatelessWidget {
  const Button({
    required this.lable,
    required this.onTap,
    super.key,
  });

  final String lable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Card(
          color: Theme.of(context).colorScheme.inversePrimary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              lable,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      );
}
