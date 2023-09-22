

import 'dart:math';

import 'package:cards/AddPage.dart';
import 'package:cards/ProfilePage.dart';
import 'package:cards/SettingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final currentUid= FirebaseAuth.instance.currentUser!.uid;

  

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        
        title: Text('Cards',style: Theme.of(context).textTheme.titleLarge,),
        actions: [
          IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddPage()));}, icon: Icon(CupertinoIcons.add_circled)),
          IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SettingPage()));}, icon: Icon(CupertinoIcons.settings))
        ],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').doc(currentUid).collection('Cards').orderBy('date',descending: true).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData)return ListWheelScrollView(
            children: snapshot.data!.docs.map((value) => Hero(
              tag: value.id,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(id: value.id),)),
                child: SizedBox(
                        height: 55*4,
                      width: 91*4,
                        child: Card(
                child: (value.data() as Map).containsKey('cardImageFront')?Image.network(value['cardImageFront'],height: 55*4,
                      width: 91*4,loadingBuilder: (context, child, loadingProgress){ 
                        if(loadingProgress==null) return child;
                        return Center(child: CircularProgressIndicator.adaptive(),);
                        }):null,
                elevation: 5,
                        ),
                      ),
              ),
            ),).toList(),
            itemExtent: 55*4,
            clipBehavior: Clip.antiAlias,
            diameterRatio: pi*2,
            
      
            
            
            
            
            
            );
            else return Center(child: CircularProgressIndicator.adaptive());
        }
      ),
      
    );
  }
}
