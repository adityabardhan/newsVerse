import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:newsverse/screens/home_screen.dart';
import 'package:newsverse/screens/tabBar.dart';

class RatingAndFeedback extends StatefulWidget {
  const RatingAndFeedback({super.key});

  @override
  State<RatingAndFeedback> createState() => _RatingAndFeedbackState();
}

class _RatingAndFeedbackState extends State<RatingAndFeedback> with TickerProviderStateMixin {

  AnimationController? animation;

  @override
  void initState() {
    animation = AnimationController(vsync: this);
    animation?.addListener(() {
      if (animation!.value > 2){
        animation?.value = 2;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animation?.dispose();
    super.dispose();
  }

  String? feedback;
  final _formKey = GlobalKey<FormState>();
  double? rate;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.red.shade400;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back_rounded,
        //     color: Colors.black87,
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset("assets/icons/stars.json",reverse: true,controller: animation,
              onLoaded: (value){
                animation?..duration = value.duration..forward();
              }
              ),
              const SizedBox(height: 10),
              const Text("Please Rate us based on your User Experience",style: TextStyle(fontStyle: FontStyle.italic,fontWeight:
              FontWeight.w400,fontSize: 16),),
              const SizedBox(height: 15,),
              Center(
                child: RatingBar.builder(
                  initialRating: 0,
                  textDirection: TextDirection.ltr,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemSize: 35,
                  itemBuilder: (context, _) =>  Icon(
                    Icons.star_rate,
                    color: Colors.redAccent.withOpacity(0.75)
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      rate = rating;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                height: 40,width: 200,
                alignment: Alignment.center,
                margin:const  EdgeInsets.only(left: 30,right: 30,top: 25,bottom: 15),
                child: rate==1?const Text("Sorry to Know! 😔",textAlign: TextAlign.center,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),):rate==2?const Text("We'll try Better 😢",maxLines:1,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),textAlign: TextAlign.center,):
                rate==3? const Text("Thanks for Honesty 😐",textAlign: TextAlign.center,maxLines:1,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500)):rate==4?const Text("Super, Keep Loving Us 🙂",maxLines:1,textAlign: TextAlign.center,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500)):
                  rate==5 ?const Text("Amazing!!! 😊",textAlign: TextAlign.center,maxLines:1,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500)):
                  rate==null?const Text("Please Rate Us",style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.w500),):const Text("",textAlign: TextAlign.center,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500))
                ),
                // child: TextFormField(
                //   readOnly: true,
                //   decoration: const InputDecoration(
                //     fillColor: Colors.transparent,
                //     filled: true,
                //     border: InputBorder.none
                //   ),
              const SizedBox(height: 5,),
              Container(
                margin:const  EdgeInsets.only(left: 30,right: 30,top: 25,bottom: 25),
                child: TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty){
                      return "Required Field";
                    }
                    else if (value!.length<15) {
                      return "Feedback must be greater or equal than 15 Characters";
                    }
                    else {return null;}
                  },
                  onSaved: (String? value) {
                    feedback = value.toString();
                  },
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.disabled,
                  cursorColor: Colors.redAccent.withOpacity(0.7),
                  decoration: InputDecoration(
                    prefixIcon:  Icon(Icons.feedback_rounded,color: Colors.redAccent.withOpacity(0.7),),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black38),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Submit Feedback",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                if (_formKey.currentState!.validate() && !(rate==null)){

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Center(child: Text('Feedback Submitted',style: TextStyle(
                          fontFamily: 'CourierPrime'
                      ),)),
                      backgroundColor: Colors.black.withOpacity(0.8)));

                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Dashboard()));
                  // Navigator.pop(context);
                }
              },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  minimumSize: const Size(240, 55),
                  backgroundColor: Colors.deepOrangeAccent.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  )),
              child: const Text("Submit",style: TextStyle(fontSize: 18.5,color: Colors.white,fontWeight: FontWeight.w700),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
