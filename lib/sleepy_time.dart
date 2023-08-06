import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'button.dart';

const words =
    "A good night's sleep consists of 5 to 6 complete sleep cycles. It takes the average human fifteen minutes to fall asleep. Sleepytime works by counting backwards in sleep cycles. Sleep cycles typically last 90 minutes. Waking up in the middle of a sleep cycle leaves you feeling tired and groggy, but waking up in between cycles lets you wake up feeling refreshed and alert!";

class SleepyTime extends StatefulWidget {
  const SleepyTime({super.key});

  @override
  State createState() => _SleepyTimeState();
}

class _SleepyTimeState extends State<SleepyTime> {
  final wakeupTimesNotifier = ValueNotifier([]);
  final sleepTimeNotifier = ValueNotifier<String?>(null);

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
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildTitleNContent(context),
                  buildSleepLater(context),
                  buildSleepNow(context),
                  if (value.isNotEmpty) buildViewTime(value, context),
                ],
              ),
            ),
          ),
        ),
      );

  Padding buildTitleNContent(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          children: [
            Text(
              'Sleepytime',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Container(
              width: 360,
              padding: const EdgeInsets.only(
                top: 12,
              ),
              child: Text(
                words,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      );

  Widget buildSleepLater(BuildContext context) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'I have to wake up at:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ValueListenableBuilder(
              builder: (context, value, _) {
                return Padding(
                  padding: const EdgeInsetsDirectional.only(top: 8.0),
                  child: Button(onTap: onSleepLater, lable: value ?? 'Go'),
                );
              },
              valueListenable: sleepTimeNotifier,
            ),
          ],
        ),
      );

  Widget buildSleepNow(BuildContext context) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'or, find out when to wake up:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 8.0),
              child: Button(onTap: onSleepNow, lable: 'Sleep now'),
            ),
          ],
        ),
      );

  Widget buildViewTime(List<dynamic> value, BuildContext context) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: sleepTimeNotifier,
              builder: (BuildContext context, value, _) => Text(
                value == null
                    ? 'Sleep now, wake up at...'
                    : 'Go to bed at one of the following times:',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Wrap(
              children: value
                  .map((i) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat('kk:mm').format(i),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
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

    sleepTimeNotifier.value = null;
    wakeupTimesNotifier.value = wakeupTimes;
  }

  Future<void> onSleepLater() async {
    final wakeupTimes = [];
    final now = DateTime.now();

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (!mounted) {
      return;
    }

    if (null == time) {
      return;
    }

    late final DateTime later;

    if ((time.hour - now.hour) < 0) {
      final nextDay = DateTime.now().add(const Duration(days: 1));
      later = DateTime(
          nextDay.year, nextDay.month, nextDay.day, time.hour, time.minute);
    } else {
      later = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    }

    final diffrence = later.difference(now).inMinutes.abs();

    if (585 <= diffrence) {
      wakeupTimes.add(later.subtract(const Duration(
        hours: 9,
        minutes: 15,
      )));
    }

    if (465 <= diffrence) {
      wakeupTimes.add(later.subtract(const Duration(
        hours: 7,
        minutes: 45,
      )));
    }

    if (375 <= diffrence) {
      wakeupTimes.add(later.subtract(const Duration(
        hours: 6,
        minutes: 15,
      )));
    }

    if (285 <= diffrence) {
      wakeupTimes.add(later.subtract(const Duration(
        hours: 4,
        minutes: 45,
      )));
    }

    if (195 <= diffrence) {
      wakeupTimes.add(later.subtract(const Duration(
        hours: 3,
        minutes: 15,
      )));
    }

    if (105 <= diffrence) {
      wakeupTimes.add(later.subtract(const Duration(
        hours: 1,
        minutes: 45,
      )));
    }

    sleepTimeNotifier.value = DateFormat('kk:mm').format(later);
    wakeupTimesNotifier.value = wakeupTimes;
  }
}
