import 'package:crudrestapiwithdb/hivedb/hivedatascreen.dart';
import 'package:crudrestapiwithdb/sqdb/sqdatascreen.dart';
import 'package:flutter/material.dart';

class DBNAV extends StatefulWidget {
  const DBNAV({Key? key}) : super(key: key);

  @override
  State<DBNAV> createState() => _DBNAVState();
}

class _DBNAVState extends State<DBNAV> {
  @override
  Widget build(BuildContext context) {
    final statusbar = MediaQuery.of(context).padding.top;
    final height = MediaQuery.of(context).size.height - statusbar;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.amberAccent,
              height: height * 0.5,
              width: double.infinity,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SQLITEDBSCREEN(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Text(
                      'SQLITE\nDATABASE',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.orangeAccent,
              height: height * 0.5,
              width: double.infinity,
              child: Center(
                child: ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text(
                        'HIVE\nDATABASE',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HiveDataScreen(),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
