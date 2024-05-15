import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:search_app/product_provider.dart';
import 'package:search_app/settings_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(ProductNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('search app'), actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage()));
          },
        )
      ]),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            onChanged: (value) {
              ref.read(ProductNotifierProvider.notifier).search(value);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(products[index]),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Column(
          children: [
            InkWell(
              onTap: () {
                if (settings.langage == 'English') {
                  ref
                      .read(userSettingsProvider.notifier)
                      .updateLangage('Japanese');
                } else {
                  ref
                      .read(userSettingsProvider.notifier)
                      .updateLangage('English');
                }
              },
              child: Row(
                children: [
                  Flexible(child: ListTile(title: Text('言語の変更'))),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(settings.langage)),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                if (settings.theme == 'Light') {
                  ref.read(userSettingsProvider.notifier).updateTheme('Dark');
                } else {
                  ref.read(userSettingsProvider.notifier).updateTheme('Light');
                }
              },
              child: Row(
                children: [
                  Flexible(
                    child: ListTile(title: Text('テーマの変更')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(settings.theme)),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
