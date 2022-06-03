import 'package:flutter/material.dart';
import 'package:summit_app_2/pages/attendance_calendar_page.dart';

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
    var rowSpacer = TableRow(children: [
      SizedBox(
        width: 1,
        height: MediaQuery.of(context).size.height * 0.05,
      ),
      const SizedBox(
        width: 1,
        height: 10,
      ),
      const SizedBox(
        width: 1,
        height: 20,
      )
    ]);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Summit Running and Fitness"),
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
                          width: MediaQuery.of(context).size.width,
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
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Welcome Name",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              screenSize.width * screenSize.height * 0.00003 +
                                  2,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Table(
                        columnWidths: {
                          0: FixedColumnWidth(
                              MediaQuery.of(context).size.width * 0.4),
                          1: const FlexColumnWidth(),
                          2: FixedColumnWidth(
                              MediaQuery.of(context).size.width *
                                  0.4) //was 165 pixels
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
    var screenSize = MediaQuery.of(context).size;
    return SizedBox(
        width: double.infinity,
        height: screenSize.height * 0.17,
        child: ElevatedButton.icon(
          label: Text(
            label,
            maxLines: 2,
          ),
          icon: Icon(icon),
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(1000, 800),
              primary: color,
              textStyle: TextStyle(
                  fontSize: screenSize.width * screenSize.height * 0.00003 + 4,
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            switch (label) {
              case "Add Member":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Menu()),
                  );
                  break;
                }

              case "Admin Page":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Menu()),
                  );
                  break;
                }
              case "Check Attendance":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AttendanceCalendarPage()),
                  );
                  break;
                }
              case "Events":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Menu()),
                  );
                  break;
                }
            }
          },
        ));
  }
}