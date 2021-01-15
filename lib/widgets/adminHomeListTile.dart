import 'package:flutter/material.dart';

class AdminHomeListTile extends StatelessWidget {
  const AdminHomeListTile({Key key, this.title, this.route, this.forward})
      : super(key: key);
  final String title;
  final String route;
  final void Function(
    String route,
    BuildContext context,
  ) forward;

  void pressed(BuildContext ctx) {
    forward(route, ctx);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            this.title,
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Icon(
            Icons.arrow_forward,
            size: 30,
            color: Colors.black,
          ),
        ),
        onTap: () {
          print("Tile Pressed!!");
          pressed(context);
        },
      ),
    );
  }
}
