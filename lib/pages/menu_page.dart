import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> firstRow = [
      menuButtonsWidget("Check Attendance", Colors.blueAccent,
          Icons.calendar_month_outlined, context),
      const SizedBox(width: 1), //for spacing
      menuButtonsWidget(
          "Events", Colors.orangeAccent, Icons.event_outlined, context),
    ];
    List<Widget> secondRow = [
      menuButtonsWidget(
          "Add Member", Colors.greenAccent, Icons.add_box_outlined, context),
      const SizedBox(width: 1), //for spacing
      menuButtonsWidget("Admin Page", Colors.redAccent,
          Icons.admin_panel_settings_outlined, context),
    ];
    const rowSpacer = TableRow(children: [
      SizedBox(
        width: 1,
        height: 10,
      ),
      SizedBox(
        width: 1,
        height: 10,
      ),
      SizedBox(
        width: 1,
        height: 20,
      )
    ]);
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Summit App"),
        ),
        body: SingleChildScrollView(
          reverse: true,
          //padding: const EdgeInsets.all(20),
          child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: IntrinsicWidth(
                      child: Container(
                          color: Colors.white,
                          width: 1000,
                          alignment: Alignment.center,
                          child: const Image(
                              fit: BoxFit.cover,
                              width: 100,
                              image: AssetImage(
                                  "assets/images/summit_big_logo.png"))),
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome Name",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(165),
                          1: FlexColumnWidth(),
                          2: FixedColumnWidth(165)
                        },
                        children: [
                          TableRow(children: firstRow),
                          rowSpacer,
                          TableRow(children: secondRow)
                        ],
                      ),
                    )),
              ]),
        ));
  }

  Widget menuButtonsWidget(
      String label, Color color, IconData icon, BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 110,
        child: ElevatedButton.icon(
          label: Text(label),
          icon: Icon(icon),
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(1000, 800),
              primary: color,
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          onPressed: () {
            switch (label) {
              case "Add Member":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctxt) => const Menu()),
                  );
                  break;
                }

              case "Admin Page":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctxt) => const Menu()),
                  );
                  break;
                }
              case "Check Attendance":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctxt) => const Menu()),
                  );
                  break;
                }
              case "Events":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctxt) => const Menu()),
                  );
                  break;
                }
            }
          },
        ));
  }
}
