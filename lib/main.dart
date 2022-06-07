import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Site Web",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Larissa Voltige"),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: SiteApp(),
      )));
}

class SiteApp extends StatefulWidget {
  const SiteApp({Key? key}) : super(key: key);

  @override
  State<SiteApp> createState() => _SiteAppState();
}

class _SiteAppState extends State<SiteApp> {
  int _currentIndex = 0;

  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.onSurface,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'A propos',
            icon: Icon(Icons.help),
          ),
          BottomNavigationBarItem(
            label: 'Diplômes',
            icon: Icon(Icons.school),
          ),
          BottomNavigationBarItem(
            label: 'Skills',
            icon: Icon(Icons.computer),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mail),
        backgroundColor: Colors.purple,
        onPressed: () async {
          var result = await OpenMailApp.openMailApp();

          // If no mail apps found, show error
          if (!result.didOpen && !result.canOpen) {
            showNoMailAppsDialog(context);

            // iOS: if multiple mail apps found, show dialog to select.
            // There is no native intent/default app system in iOS so
            // you have to do it yourself.
          } else if (!result.didOpen && result.canOpen) {
            showDialog(
              context: context,
              builder: (_) {
                return MailAppPickerDialog(
                  mailApps: result.options,
                );
              },
            );
          }
        },
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
