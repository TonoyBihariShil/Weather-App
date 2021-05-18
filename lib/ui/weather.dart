import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/util/utilitis.dart' as util;
import 'package:http/http.dart'as http;
import 'dart:async';

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String _cityEntered;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future _gotoNextScreen(BuildContext context)async{
    Map result= await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context){
        return new ChangeCity();
      })
    );
    if (result != null && result.containsKey("enter")){

      setState(() {
        _cityEntered=result["enter"];

      });
      // print("From first screen"+result["enter"].toString());

    }
}


  void showStuff()async{
   Map _data=await getWeather(util.appID,util.defaultCity);
   print(_data.toString());
   print("pressed");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Weather"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: [
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: (){_gotoNextScreen(context);})

        ],
      ),
      body: new Stack(
            children: [
              new Center(
                child: new Image.asset("images/umbrella.png",
                  width: 490.0,
                  height: 1200.0,
                  fit: BoxFit.fill,
                ),

              ),
              new Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
                child: Text("${_cityEntered== null? util.defaultCity: _cityEntered}",
                  style: cityStyle(),
                ),
              ),
              new Container(
                alignment: Alignment.center,
               // margin: const EdgeInsets.fromLTRB(0.0, 100, 0.0, 0.0),
                child: new Image.asset("images/light_rain.png"),
              ),
              new Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(30.0, 400, 0.0, 0.0),

                  child:updateWidget(_cityEntered)
              )

            ],
          ),


    );
  }
  Future<Map> getWeather(String appID, String city) async {
    var url= Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appID}&units=metric");
    http.Response response= await http.get(url);
    return json.decode(response.body);
  }
  Widget updateWidget(String city){
    return new FutureBuilder(
        future: getWeather(util.appID, city ==null?util.defaultCity:city),
        builder:(BuildContext context, AsyncSnapshot<Map> snapshot){
          if(snapshot.hasData){

            Map content =snapshot.data;
            return new Container(
              child: Column(
                children: [
               new ListTile(
              title: new Text("Temp: ${content["main"]["temp"].toString()}F", style: TextStyle(color: Colors.white, fontSize: 37.0,
              fontStyle: FontStyle.normal, fontWeight: FontWeight.w500
              ),),
                 subtitle: new Text("Max Temp: ${content["main"]["temp_max"].toString()}F\nMin Temp: ${content["main"]["temp_min"].toString()}F",style: TextStyle(color: Colors.white, fontSize: 20),),
                //trailing: new Text(content["weather"]["description"].toString(),style: TextStyle(color: Colors.white, fontSize: 20),)
               )
                ],


                )
              );

          }
          else
            return new Container();
      }



    );

  }
}

class ChangeCity extends StatelessWidget {
  var _cityController= new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Change City"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          new Center(



           child: Image.asset("images/white_snow.png",
              width: 490,
              height: 1200,
              fit: BoxFit.fill,
            ),
          ),
          
          ListView(
            children: [
              new ListTile(
                title: new TextField(
                  decoration: InputDecoration(
                    hintText: "Enter City"
                  ),
                  controller: _cityController,
                  keyboardType: TextInputType.text,
                )
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: (){
                      Navigator.pop(context,{
                        'enter':_cityController.text
                      });


                    },
                    textColor: Colors.white70,
                    color: Colors.redAccent,
                    child: new Text("Get Weather")),
              )
            ],
          )

        ],
      ),

    );
  }
}


TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 29.0,
    fontStyle: FontStyle.italic

  );
}
TextStyle temStyle(){
  return new TextStyle(
      color: Colors.white,
      fontSize: 49.9,
      fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500


  );
}