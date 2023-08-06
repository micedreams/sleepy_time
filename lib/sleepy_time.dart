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
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.all(8.0),
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
      );

  Padding buildTitleNContent(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          children: [
            Text(
              'Sleepytime',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
              ),
              child: Text(
                words,
                style: Theme.of(context).textTheme.bodyLarge,
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
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 8.0),
              child: Button(onTap: onSleepLater, lable: 'Go'),
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
              valueListenable: sleepNowNotifier,
              builder: (BuildContext context, value, _) => Text(
                value
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

    sleepNowNotifier.value = true;
    wakeupTimesNotifier.value = wakeupTimes;
  }

  void onSleepLater() {
    final wakeupTimes = [];

    sleepNowNotifier.value = false;
    wakeupTimesNotifier.value = wakeupTimes;
  }
}
