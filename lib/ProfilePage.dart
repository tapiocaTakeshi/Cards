import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class ProfilePage extends StatefulWidget {
  final String id;
  const ProfilePage({required this.id, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUid)
              .collection('Cards')
              .doc(widget.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: widget.id,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: GestureFlipCard(
                          frontWidget: Image.network(data['cardImageFront'],
                              height: 55 * 4, width: 91 * 4, loadingBuilder:
                                  (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }),
                          backWidget: Image.network(data['cardImageBack'],
                              height: 55 * 4, width: 91 * 4, loadingBuilder:
                                  (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  if (data.containsKey('jsonFront'))
                    Column(
                      children: (data['jsonFront'] as Map<String, dynamic>)
                          .entries
                          .map((e1) => e1.value.toString().isEmpty?Container():Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(e1.key),
                                  subtitle: e1.value is List
                                      ? Column(
                                          children: (e1.value as List)
                                              .map(
                                                (value) => value.toString().isEmpty?Container():value is Map<String,dynamic>?Column(
                                                  children:
                                                      (value as Map<String,
                                                              dynamic>)
                                                          .entries
                                                          .map((e2) => ListTile(
                                                                title:
                                                                    Text(e2.key),
                                                                subtitle: Text(
                                                                    e2.value),
                                                                titleTextStyle: Theme.of(
                                                                        context)
                                                                    .listTileTheme
                                                                    .subtitleTextStyle,
                                                                subtitleTextStyle: Theme.of(
                                                                        context)
                                                                    .listTileTheme
                                                                    .titleTextStyle,
                                                                trailing: e2.key ==
                                                                        '電話番号'
                                                                    ? IconButton(
                                                                        onPressed:
                                                                            () {},
                                                                        icon: Icon(Icons
                                                                            .phone))
                                                                    : e2.key ==
                                                                                'メールアドレス'
                                                                            ? IconButton(
                                                                                onPressed: () {},
                                                                                icon: Icon(Icons.email))
                                                                            : e2.key == 'ホームページ'
                                                                                ? IconButton(onPressed: () {}, icon: Icon(Icons.web))
                                                                                : e2.key == '住所'
                                                                                    ? IconButton(onPressed: () {}, icon: Icon(Icons.location_on))
                                                                                    : null,
                                                              ))
                                                          .toList(),
                                                ):Text(value),
                                              )
                                              .toList())
                                      : Text(e1.value),
                                  trailing: e1.key == '電話番号'
                                      ? IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.phone))
                                      : e1.key == '携帯電話番号'
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons
                                                        .chat_bubble_rounded)),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.phone)),
                                              ],
                                            )
                                          : e1.key == 'メールアドレス'
                                              ? IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.email))
                                              : e1.key == 'ホームページ'
                                                  ? IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.web))
                                                  : e1.key == '住所'
                                                      ? IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(Icons
                                                              .location_on))
                                                      : null,
                                  titleTextStyle: Theme.of(context)
                                      .listTileTheme
                                      .subtitleTextStyle,
                                  subtitleTextStyle: Theme.of(context)
                                      .listTileTheme
                                      .titleTextStyle,
                                ),
                              ))
                          .toList(),
                    ),
                  if (data.containsKey('jsonBack'))
                    Column(
                      children: (data['jsonBack'] as Map<String, dynamic>)
                          .entries
                          .map((e1) => e1.value.toString().isEmpty?Container():Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(e1.key),
                                  subtitle: e1.value is List
                                      ? Column(
                                          children: (e1.value as List)
                                              .map(
                                                (value) => value.toString().isEmpty?Container():value is Map<String,dynamic>?Column(
                                                  children:
                                                      (value as Map<String,
                                                              dynamic>)
                                                          .entries
                                                          .map((e2) => ListTile(
                                                                title:
                                                                    Text(e2.key),
                                                                subtitle: Text(
                                                                    e2.value),
                                                                titleTextStyle: Theme.of(
                                                                        context)
                                                                    .listTileTheme
                                                                    .subtitleTextStyle,
                                                                subtitleTextStyle: Theme.of(
                                                                        context)
                                                                    .listTileTheme
                                                                    .titleTextStyle,
                                                                trailing: e2.key ==
                                                                        '電話番号'
                                                                    ? IconButton(
                                                                        onPressed:
                                                                            () {},
                                                                        icon: Icon(Icons
                                                                            .phone))
                                                                    : e2.key ==
                                                                                'メールアドレス'
                                                                            ? IconButton(
                                                                                onPressed: () {},
                                                                                icon: Icon(Icons.email))
                                                                            : e2.key == 'ホームページ'
                                                                                ? IconButton(onPressed: () {}, icon: Icon(Icons.web))
                                                                                : e2.key == '住所'
                                                                                    ? IconButton(onPressed: () {}, icon: Icon(Icons.location_on))
                                                                                    : null,
                                                              ))
                                                          .toList(),
                                                ):Text(value),
                                              )
                                              .toList())
                                      : Text(e1.value),
                                  trailing: e1.key == '電話番号'
                                      ? IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.phone))
                                      : e1.key == '携帯電話番号'
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons
                                                        .chat_bubble_rounded)),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.phone)),
                                              ],
                                            )
                                          : e1.key == 'メールアドレス'
                                              ? IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.email))
                                              : e1.key == 'ホームページ'
                                                  ? IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.web))
                                                  : e1.key == '住所'
                                                      ? IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(Icons
                                                              .location_on))
                                                      : null,
                                  titleTextStyle: Theme.of(context)
                                      .listTileTheme
                                      .subtitleTextStyle,
                                  subtitleTextStyle: Theme.of(context)
                                      .listTileTheme
                                      .titleTextStyle,
                                ),
                              ))
                          .toList(),
                    ),
                ],
              );
            } else
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
          }),
    );
  }
}
