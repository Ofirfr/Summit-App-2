import 'package:flutter/material.dart';
import 'package:summit_app_2/pages/admin/admin_coach_page.dart';
import 'package:summit_app_2/pages/admin/admin_district_page.dart';
import 'package:summit_app_2/pages/admin/admin_general_stats_page.dart';
import 'package:summit_app_2/pages/admin/admin_type_page.dart';
import 'package:summit_app_2/pages/admin/admin_users_stats_page.dart';

class StatsMenuPage extends StatelessWidget {
  const StatsMenuPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> firstRow = [
      menuButtonsWidget("General Stats", Colors.blueAccent,
          Icons.travel_explore_outlined, context),
      const SizedBox(width: 1), //for spacing
      menuButtonsWidget("Users Stats", Colors.orangeAccent,
          Icons.fitness_center_outlined, context),
    ];
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
                      "Admin Page",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              screenSize.width * screenSize.height * 0.00003 +
                                  12,
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
                  fontSize: screenSize.width * screenSize.height * 0.00003 + 8,
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            switch (label) {
              case "General Stats":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GeneralStatsPage()),
                  );
                  break;
                }

              case "Users Stats":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UsersStatsPage()),
                  );
                  break;
                }
            }
          },
        ));
  }
}
