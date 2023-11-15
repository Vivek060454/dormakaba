import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormakaba/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final _auth = FirebaseAuth.instance;
  User? user ;
  get productsellStream =>
      FirebaseFirestore.instance.collection('product').snapshots();

  @override
  void initState() {
    CollectionReference productsell =
    FirebaseFirestore.instance.collection('product');
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    user = _auth.currentUser;
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
          return Container(child:  GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              padding:
              const EdgeInsets.only(left: 18, right: 18, top: 13, bottom: 20),
              // scrollDirection: Axis.vertical,
              // controller: _featuredCategoryScrollController,
              itemCount: snapshot.data!.docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // childAspectRatio: 3 / 2,
                // crossAxisSpacing: 14,
                // mainAxisSpacing: 14,
                // mainAxisExtent: 170.0
              ),
              itemBuilder: (context, index) {

                return  GestureDetector(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //   return CategoryProducts(
                    //     category_id: fe[index].id,
                    //     category_name: fe[index].name,
                    //   );
                    // }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        
                        Container(
                        // height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.08),
                              blurRadius: 20,
                              spreadRadius: 0.0,
                              offset: Offset(0.0, 10.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        // decoration: BoxDecorations.buildBoxDecoration_1(),
                        child: Column(
                          children: <Widget>[
                            Container(
                              // height: 80,
                                child:    AspectRatio(
                                  aspectRatio: 1.4,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(6), right: Radius.circular(6)),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/images.jpeg',
                                        image: snapshot.data!.docs[index]['image'] ,
                                        fit: BoxFit.cover,
                                      )),
                                )),
                            RatingBar.builder(
                              initialRating:
                              double.parse(snapshot.data!.docs[index]['rating']),
                              itemPadding: EdgeInsets.all(0),
                              itemSize: 15,
                              ignoreGestures: false,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snapshot.data!.docs[index]['title'] ,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                    style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            // Text(
                            //   snapshot.data!.docs[index]['price'],
                            //   maxLines: 1,
                            //   style: TextStyle(
                            //       color: Mytheme().primary,
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.w700),
                            // ),
                          ],
                        ),
                      ),
                      // Icon(Icons.favorite,color: Colors.red,)
                      ]
                    ),
                  ),
                );
              }),);
        });
  }
}
