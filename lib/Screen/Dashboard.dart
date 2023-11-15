import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import '../theme.dart';
import 'Auth/login.dart';
import 'Auth/product.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;
  User? user ;
  get productsellStream =>
      FirebaseFirestore.instance.collection('usersell').snapshots();
  final uid1 = new FlutterSecureStorage();
  final LocalStorage emaile = new LocalStorage('localstorage_app');

  showPopupMenu(){
    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(25.0, 105.0, 0.0, 0.0),  //position where you want to show the menu on screen
      items: [

        PopupMenuItem(
          value: 1,
          // row has two child icon and text
          child: InkWell(
            onTap: () {
             signout();



            },
            child: Row(
              children: [
                Icon(Icons.logout,color:Mytheme().primary,),
                SizedBox(
                  // sized box with width 10
                  width: 10,
                ),
                Text("Log Out",style: TextStyle(color:Mytheme().primary),)
              ],
            ),
          ),
        ),      ],
      // offset: Offset(0, 65),
      color: Colors.white,
      elevation: 0,
      // shape: const TooltipShape(),

    );
  }
signout()async{
  FirebaseAuth.instance.signOut().then((value) async =>
  {
    await uid1.delete(key: 'uid'),
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
  return Login();
  }), (route) => false)
  });
      }
  @override
  void initState() {
    CollectionReference productsell =
    FirebaseFirestore.instance.collection('usersell');
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    user = _auth.currentUser;
    var image;
    print("hjsdfvij"+image.toString());
    return StreamBuilder<QuerySnapshot>(
        stream: productsellStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) async {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();
          return Scaffold(
            appBar: AppBar(
                title: Text(
                  'Dashboard',
                ),
              actions: [InkWell(
                onTap: () async {
                  showPopupMenu();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.more_vert_sharp,color: Colors.white,)
                ),
              ),

              ],
                centerTitle: true,
                //  title: const Text('Tritan Bikes'),
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                //  backgroundColor: const Color.fromRGBO(100, 0, 0, 10),
                ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    if(snapshot.data!.docs[index]['email']== emaile.getItem( 'email').toString()){
                      image=snapshot.data!.docs[index]['image'].toString();
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8,right: 8,),
                            child: Table(
                              columnWidths: {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(4)},
                              children: [
                                TableRow(children: [

                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(80)),

                                      child: CircleAvatar(
                                        minRadius: 38,
                                        maxRadius: 39,
                                        child: FadeInImage.assetNetwork(
                                         placeholder: 'assets/images.jpeg',
                                         image: snapshot.data!.docs[index]['image'].toString(),
                                         fit: BoxFit.cover,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(snapshot.data!.docs[index]['fname'].toString(),
                                                style:  TextStyle(
                                                      fontSize: 23,
                                                      fontWeight: FontWeight.bold,
                                                ))
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(snapshot.data!.docs[index]['email'].toString(),
                                                style:  TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w500,
                                                ))
                                        ),
                                      ],
                                    ),
                                  )
                                ])
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text("Categories",
                                  style:  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w500,
                                  ))
                          ),
                          Product()
                        ],
                      );
                    }
                return Text('');
              }),),
            )
          );
        });
  }
}
