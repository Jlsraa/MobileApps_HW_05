import 'package:flutter/material.dart';

class ItemPublic extends StatefulWidget {
  final Map<String, dynamic> publicFData;
  ItemPublic({Key? key, required this.publicFData}) : super(key: key);

  @override
  State<ItemPublic> createState() => _ItemPublicState();
}

class _ItemPublicState extends State<ItemPublic> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                "${widget.publicFData["picture"]}",
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Text("${widget.publicFData["username"].toString()[0]}"),
              ),
              title: Text("${widget.publicFData["username"]}"),
              subtitle: Text("${widget.publicFData["publishedAt"].toDate()}"),
              trailing: Wrap(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.star_outlined, color: Colors.red),
                    tooltip: "Likes: ${widget.publicFData["stars"]}",
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.share),
                    tooltip: "Compartir",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
