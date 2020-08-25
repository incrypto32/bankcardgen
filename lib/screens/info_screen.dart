import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  final List _terms=["user shall impart the whole responsibilty of their credentials shared using cards.","we will not be responsible for the information lost through sharing images,although your data is stored anywhere in our system","user is not allowed to share the images of the card by any other means than this app",];
  final List _about=["this app was created by krishnanand(cse undergrad)","his contact number will be provided if you contact us","rating 5 star is mandatory for users of this app"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Info",
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 20,vertical: 10
        ),
        child: Column(
          children: [ _myHeading("Terms Of Service", context),
          _myList(_terms),
          _myHeading("About Us", context),
          _myList(_about)

           ] )
        ),
      
    );
  }
}


Widget _myHeading(text,context) {

return Padding(
  padding: const EdgeInsets.symmetric(vertical: 15),
  child:   Text(text,softWrap: true,style:Theme.of(context).textTheme.headline6.copyWith(fontSize: 20) ,),
);

}

Widget _myList(list){
  return  ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                list[index],
                                style: Theme.of(context).textTheme.headline6.copyWith( fontWeight: FontWeight.normal,fontSize: 16),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  );
}
