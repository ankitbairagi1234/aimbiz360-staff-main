import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import 'package:http/http.dart' as http;

import '../../Helper/Color.dart';
import '../../Helper/appbutton.dart';
import '../../Model/Doctordegreemodel.dart';
import '../Home.dart';

class RegistrationScreen extends StatefulWidget {
  final int? role ;
  String? id;


  RegistrationScreen({Key? key, this.role,this.id}) : super(key: key);


  @override
  State<RegistrationScreen> createState() => _DoctorResignationState();
}

class _DoctorResignationState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phonelController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController CpassController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController clinikaddressController = TextEditingController();
  TextEditingController docdegreeController = TextEditingController();


  List<DoctorList> doctorList = [];


  bool isDoctor = false;
  File? imageFile;
  File? imageFile1;
  File? newImageFile;
  String? SelectedPharma;
  String? SelectedGender;
  String? categoryValue;
  String? categoryValue2;

  int _value = 1;
  bool isMobile = false;
  bool isSendOtp = false;
  bool isLoading = false;
  String  gender =  "Male";

  int selectedIndex = 0;
  int selectedGender = 0;
  String finalString ='';

  int category = 2;
  List results = [];

  var items = [
    'M.B.B.S.',
    'B.H.M.S',
  ];

  List<String> items1 = [
    'Mr.',
    'Miss.',
    'Mrs.',
  ];
  selectDoctorDegree() async{
    var headers = {
      'Cookie': 'ci_session=6bece19029430dfbbce85cca2c9d3872e8824a71; ekart_security_cookie=e68b3e0aaefe6b42aa94d02b282ac23f'
    };
    var request = http.Request('GET', Uri.parse('https://developmentalphawizz.com/vetcare/doctor/app/v1/api/get_doctor_degree'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      final finalResponse = Doctordegreemodel.fromJson(result);
      doctorList = finalResponse.data!;
      print("this is doctor list ----->>>> ${doctorList[0].name}");
    }

    else {
      print(response.reasonPhrase);
    }

  }

  final ImagePicker _picker = ImagePicker();

  Future<bool> showExitPopup() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
          title: Text('Select Image'),
          content: Row(
            // crossAxisAlignment: CrossAxisAlignment.s,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _getFromCamera();
                },
                //return false when click on "NO"
                child: Text('Camera'),
              ),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  _getFromGallery();
                  // Navigator.pop(context,true);
                  // Navigator.pop(context,true);
                },
                //return true when click on "Yes"
                child: Text('Gallery'),
              ),
            ],
          )),
    ) ??
        false; //if showDialouge had returned null, then return false
  }

  Future<bool> showExitPopup1() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
          title: Text('Select Image'),
          content: Row(
            // crossAxisAlignment: CrossAxisAlignment.s,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _getFromCamera1();
                },
                //return false when click on "NO"
                child: Text('Camera'),
              ),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  _getFromGallery1();
                  // Navigator.pop(context,true);
                  // Navigator.pop(context,true);
                },
                //return true when click on "Yes"
                child: Text('Gallery'),
              ),
            ],
          )),
    ) ??
        false; //if showDialouge had returned null, then return false
  }

  _getFromGallery() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    /* PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );*/
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getFromCamera() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    /*  PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );*/
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getFromGallery1() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    /* PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );*/
    if (pickedFile != null) {
      setState(() {
        imageFile1 = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getFromCamera1() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    /*  PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );*/
    if (pickedFile != null) {
      setState(() {
        imageFile1 = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  // RegistrationModel? detailsData;


  // registration() async {
  //   if(imageFile ==null ){
  //     Fluttertoast.showToast(msg: 'Please add registration card');
  //   }else if(imageFile1 == null){
  //     Fluttertoast.showToast(msg: 'Please add profile photo');
  //   }else {
  //     String? token;
  //     try {
  //       token = await FirebaseMessaging.instance.getToken();
  //       print("-----------token:-----${token}");
  //     } on FirebaseException {
  //       print('__________FirebaseException_____________');
  //     }
  //
  //     if (widget.role == 2 && finalString.isEmpty) {
  //       Fluttertoast.showToast(msg: 'Please select category');
  //     } else {
  //       print("this is user registration ");
  //       var headers = {
  //         'Cookie': 'ci_session=7484a255faa8a60919687a35cf9c56e5c55326d2'
  //       };
  //       var request = http.MultipartRequest(
  //           'POST', Uri.parse('${ApiService.userRegister}'));
  //       request.fields.addAll({
  //         'email': emailController.text,
  //         'mobile': mobileController.text,
  //         'username': nameController.text,
  //         'gender': gender.toString(),
  //         'doc_degree': docdegreeController.text,
  //         'address': addressController.text,
  //         'c_address': clinikaddressController.text,
  //         'cat_type': SelectedPharma.toString(),
  //         'category_id': finalString.isEmpty && widget.id != null
  //             ? widget.id ?? ''
  //             : finalString,
  //         'password': passController.text,
  //         'roll': widget.role.toString(),
  //         'confirm_password': CpassController.text,
  //         'fcm_id': token ?? ''
  //       });
  //       print("Surendra------------>${ApiService.userRegister}");
  //
  //       if (imageFile != null) {
  //         request.files.add(await http.MultipartFile.fromPath(
  //             'registration_card', imageFile?.path ?? ''));
  //       }
  //       if (imageFile1 != null) {
  //         request.files.add(await http.MultipartFile.fromPath(
  //             'image', imageFile1?.path ?? ''));
  //       }
  //
  //       print(
  //           "this is request ===>>>>surendra ${request.fields}   ${request.files.toString()}");
  //       request.headers.addAll(headers);
  //       http.StreamedResponse response = await request.send();
  //
  //       if (response.statusCode == 200) {
  //         if (!(detailsData?.user ?? false)) {
  //           Fluttertoast.showToast(msg: "User Registered Successfully!!");
  //           Navigator.pushReplacement(context,
  //               MaterialPageRoute(builder: (context) => LoginScreen()));
  //         }
  //         setState(() {
  //           isLoading = false;
  //         });
  //       } else {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         print(response.reasonPhrase);
  //       }
  //     }
  //   }
  // }

    void initState() {
    // TODO: implement initState
    super.initState();
    selectDoctorDegree();

  }

  void _showMultiSelect(int category) async {
    results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Text("");
        });
      },
    );
    setState(() {});
  }
  bool _isObscure = true;
  bool _isObscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: customAppBar(
        //     text:
        //     "${widget.role == 1 ? "Doctor" : "Pharma(PMT Team & Marketing)"}",
        //     isTrue: true,
        //     context: context),
      appBar: AppBar(backgroundColor: primary,
      centerTitle: true,
      title: Text(" Doctor Registration",style: TextStyle(color: white),),),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // widget.role == 1 ?  Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 15),
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: colors.black54)),
                  //   child: DropdownButtonHideUnderline(
                  //     child: DropdownButton<String>(
                  //       hint: const Text("Select Gender", style: TextStyle(color: colors.black54),),
                  //       isExpanded: true,
                  //       elevation: 0,
                  //       value: SelectedGender,
                  //       icon: const Icon(
                  //         Icons.keyboard_arrow_down,
                  //         size: 40,
                  //         color:primary,
                  //       ),
                  //       items: items1.map((items) {
                  //         print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa${items}");
                  //         return DropdownMenuItem<String>(
                  //             value: items.toString(),
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Text(
                  //                 items,
                  //                 style: TextStyle(color:primary),
                  //               ),
                  //             ));
                  //       }).toList(),
                  //       onChanged: (String? newValue) {
                  //         setState(() {
                  //           SelectedGender = newValue!;
                  //           //selectedGender = items1.indexOf(newValue);
                  //
                  //           /*selectedIndex++;
                  //         print("tttttt--------->${selectedIndex}");*/
                  //         });
                  //       },
                  //     ),
                  //   ),):SizedBox(),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child:Row(
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 10),
                          ),
                        ],
                      )


                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: '',
                        hintStyle: const TextStyle(
                            fontSize: 15.0, color: secondary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.only(left: 10, top: 10)),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "name is required";
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:Row(
                        children: [
                          Text(
                            "Mobile No",
                            style: TextStyle(
                               fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                                 fontWeight: FontWeight.bold,fontSize: 10),
                          ),
                        ],
                      )
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                        counterText: "",
                        hintText: '',
                        hintStyle:
                        TextStyle(fontSize: 15.0, ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.only(left: 10, top: 10)),
                    validator: (v) {
                      if (v!.length != 10) {
                        return "mobile number is required";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Text(
                            "Email Id",
                            style: TextStyle(
                               fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 10),
                          ),

                        ],
                      )

                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: '',
                        hintStyle: const TextStyle(
                            fontSize: 15.0, ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.only(left: 10, top: 10)),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Email is required";
                      }
                      if (!v.contains("@")) {
                        return "Enter Valid Email Id";
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Select Doctor Type",
                          style: TextStyle(
                              color: Colors.black54, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            fillColor: MaterialStateColor.resolveWith(
                                    (states) =>  secondary),
                            activeColor: secondary,
                            groupValue: _value,
                            onChanged: (int? value) {
                              setState(() {
                                _value = value!;
                                gender = "Junior Dr.";
                                //isMobile = false;
                              });
                            },
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "Senior Doctor",
                            style: TextStyle(
                                 fontSize: 15),
                          ),
                          SizedBox(height: 5,),
                          Radio(
                              value: 2,
                              fillColor: MaterialStateColor.resolveWith(
                                      (states) => secondary),
                              activeColor:  secondary,
                              groupValue: _value,
                              onChanged: (int? value) {
                                setState(() {
                                  _value = value!;
                                  gender = "Female";
                                  // isMobile = true;
                                });
                              }),
                          // SizedBox(width: 10.0,),
                          Text(
                            "Junior Doctor",
                            style: TextStyle(
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Select Doctor Degree",
                          style: TextStyle(
                              color: Colors.black54, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.black54)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // Initial Value
                            value: categoryValue,
                            // underline: Container(),
                            isExpanded: true,
                            // Down Arrow Icon
                            icon: Icon(Icons.keyboard_arrow_down, color: primary,),
                            hint: Text("Select Doctor Degree", style: TextStyle(
                                color: Colors.black
                            ),),
                            // Array list of items
                            items: doctorList.map((items) {
                              return DropdownMenuItem(
                                value: items.id,
                                child: Container(
                                    child: Text(items.name.toString())),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                categoryValue = newValue!;
                                print("selected category ${categoryValue}");
                              });
                            },
                          ),
                          // DropdownButton(
                          //   hint: const Text("Select Dr. Degree", style: TextStyle(color: Colors.black54),),
                          //   isExpanded: true,
                          //   elevation: 0,
                          //   value: SelectedPharma,
                          //   icon: const Icon(
                          //     Icons.keyboard_arrow_down,
                          //     size: 40,
                          //     color:primary,
                          //   ),
                          //   items: items.map((String items) {
                          //     return DropdownMenuItem(
                          //         value: items,
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(8.0),
                          //           child: Text(
                          //             items,
                          //             style: TextStyle(color:primary),
                          //           ),
                          //         ));
                          //   }).toList(),
                          //   onChanged: (String? newValue) {
                          //     setState(() {
                          //       SelectedPharma = newValue!;
                          //       selectedIndex = items.indexOf(newValue);
                          //       if (selectedIndex == 0) {
                          //         category = 2;
                          //       } else {
                          //         category = 3;
                          //       }
                          //       /*selectedIndex++;
                          // print("tttttt--------->${selectedIndex}");*/
                          //     });
                          //   },
                          // ),
                        ),
                      ),
                      SizedBox(height: 15,),

                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Select Doctor Specialization",
                          style: TextStyle(
                              color: Colors.black54, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.black54)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // Initial Value
                            value: categoryValue,
                            // underline: Container(),
                            isExpanded: true,
                            // Down Arrow Icon
                            icon: Icon(Icons.keyboard_arrow_down, color: primary,),
                            hint: Text("Select Doctor Specialization", style: TextStyle(
                                color: Colors.black
                            ),),
                            // Array list of items
                            items: doctorList.map((items) {
                              return DropdownMenuItem(
                                value: items.id,
                                child: Container(
                                    child: Text(items.name.toString())),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                categoryValue = newValue!;
                                print("selected category ${categoryValue}");
                              });
                            },
                          ),
                          // DropdownButton(
                          //   hint: const Text("Select Dr. Degree", style: TextStyle(color: Colors.black54),),
                          //   isExpanded: true,
                          //   elevation: 0,
                          //   value: SelectedPharma,
                          //   icon: const Icon(
                          //     Icons.keyboard_arrow_down,
                          //     size: 40,
                          //     color:primary,
                          //   ),
                          //   items: items.map((String items) {
                          //     return DropdownMenuItem(
                          //         value: items,
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(8.0),
                          //           child: Text(
                          //             items,
                          //             style: TextStyle(color:primary),
                          //           ),
                          //         ));
                          //   }).toList(),
                          //   onChanged: (String? newValue) {
                          //     setState(() {
                          //       SelectedPharma = newValue!;
                          //       selectedIndex = items.indexOf(newValue);
                          //       if (selectedIndex == 0) {
                          //         category = 2;
                          //       } else {
                          //         category = 3;
                          //       }
                          //       /*selectedIndex++;
                          // print("tttttt--------->${selectedIndex}");*/
                          //     });
                          //   },
                          // ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      // Padding(
                      //     padding: EdgeInsets.all(5.0),
                      //     child: Row(
                      //       children: [
                      //         Text(
                      //           "Category",
                      //           style: TextStyle(
                      //             // color: colors.black54,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //         Text(
                      //           "*",
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold,fontSize: 10),
                      //         ),
                      //       ],
                      //     )
                      //
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // select(),
                    ],
                  ) ,
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                               fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3,left: 2),
                          child: Text(
                            "*",
                            style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: _isObscurePassword,
                    controller: passController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: '',
                        hintStyle:
                        TextStyle(fontSize: 15.0, color: secondary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.only(left: 10, top: 10),
                        suffixIcon: IconButton(
                            icon: Icon(
                              _isObscurePassword ? Icons.visibility : Icons.visibility_off,color: secondary,),
                            onPressed: () {
                              setState(() {
                                _isObscurePassword = !_isObscurePassword;
                              });
                            })
                    ),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "password is required";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Text(
                            "Confirm password",
                            style: TextStyle(
                                 fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 10),
                          ),
                        ],
                      )

                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: _isObscure,
                    controller: CpassController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: '',
                        hintStyle:
                        TextStyle(fontSize: 15.0, color: secondary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.only(left: 10, top: 10),
                        suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility : Icons.visibility_off,color: secondary,),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            })
                    ),
                    validator: (v) {
                      if (v!.isEmpty || CpassController.text != passController.text) {
                        return "password does not match";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:Row(
                        children: [
                          Text(
                            "Address",
                            style: TextStyle(
                                 fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                               fontWeight: FontWeight.bold,fontSize: 10),
                          ),
                        ],
                      )


                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: addressController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: '',
                        hintStyle:
                        TextStyle(fontSize: 15.0, color: secondary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.only(left: 10, top: 10)),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Address is required";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.role == 1
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Clinic Address",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: clinikaddressController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(
                                fontSize: 15.0, color: secondary),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding:
                            const EdgeInsets.only(left: 10, top: 10)),
                        // validator: (v) {
                        //   if (v!.isEmpty && widget.role == 1) {
                        //     return "Clinic Address is required";
                        //   }
                        // },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(5.0),
                          child:Row(
                            children: const [
                              Text(
                                "Dr.Degree",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                    color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                              ),
                            ],
                          )

                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: docdegreeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: '',
                            hintStyle: const TextStyle(
                                fontSize: 15.0, color: secondary),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding:
                            EdgeInsets.only(left: 10, top: 10)),
                        validator: (v) {
                          if (v!.isEmpty && widget.role == 1) {
                            return "degree is required";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                    ],
                  )
                      : SizedBox.shrink(),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: const [
                          Text(
                            "Registration Card",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                          ),
                        ],
                      )

                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showExitPopup();
                    },
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height/6,
                      height: imageFile == null ? 50:155,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(5),
                        dashPattern: [5, 5],
                        color: Colors.grey,
                        strokeWidth: 2,
                        child: imageFile == null || imageFile == ""
                            ? Center(
                            child: Icon(
                              Icons.drive_folder_upload_outlined,
                              color: Colors.grey,
                              size: 30,
                            ))
                            : Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                imageFile!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Text(
                            "Profile Image",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                          ),
                        ],
                      )


                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showExitPopup1();
                    },
                    child: Container(
                      height: imageFile1 == null ? 50:155,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(5),
                        dashPattern: [5, 5],
                        color: Colors.grey,
                        strokeWidth: 2,
                        child: imageFile1 == null || imageFile1 == ""
                            ? Center(
                            child: Icon(
                              Icons.drive_folder_upload_outlined,
                              color: Colors.grey,
                              size: 30,
                            ))
                            : Column(
                          children: [
                            Image.file(
                              imageFile1!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Center(
                    child: Btn(
                        height: 50,
                        width: 320,
                        title: isLoading == true ? "Please wait......" : 'Submit',
                        color: secondary,
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            print("hhhhhhhhhhhhhhhhhhhhhh${widget.role}");

                            // registration();
                            print("surennnnnnnnnnnnnnnn");
                            //
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) =>New()));
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            const snackBar = SnackBar(
                              content: Text('All Fields are required!'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget select() {
    return InkWell(
      onTap: () {
        _showMultiSelect(category);
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black.withOpacity(0.7))),
          child: results.isEmpty
              ? const Padding(
            padding: EdgeInsets.only(left: 10, top: 15, bottom: 15),
            child: Text(
              'Select Categories',
              style: TextStyle(
                fontSize: 16,

                fontWeight: FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
              : Wrap(
            children: results.map((item) {
              String itemId = item.id.toString();
              finalString = '${finalString},${itemId}';
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Chip(
                  backgroundColor:primary,
                  label: Text(
                    "${item.name}",
                    style: TextStyle(color: Colors.white),
                    //item.name
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }
}

// class MultiSelect extends StatefulWidget {
//   int category;
//
//   MultiSelect({Key? key, required this.category}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _MultiSelectState();
// }
//
// class _MultiSelectState extends State<MultiSelect> {
//   List _selectedItems = [];
//   List<PharmaCategory> pharmaCategoryList = [];
//   void _itemChange(PharmaCategory itemValue, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         _selectedItems.add(itemValue);
//       } else {
//         _selectedItems.remove(itemValue);
//       }
//     });
//     print("this is selected values ${_selectedItems.toString()}");
//   }
//
//   void _cancel() {
//     Navigator.pop(context);
//   }
//
//   void _submit() {
//     List selectedItem = _selectedItems.map((item) => item.id).toList();
//     Navigator.pop(context);
//   }
//
//   // getPharmaCategory(int category) async {
//   //   var headers = {
//   //     'Cookie': 'ci_session=7484a255faa8a60919687a35cf9c56e5c55326d2'
//   //   };
//   //   var request = http.MultipartRequest(
//   //       'POST', Uri.parse('${ApiService.getPharmaCategory}'));
//   //   request.fields.addAll({
//   //     'cat_type': category.toString(),
//   //   });
//   //
//   //   print("request________${request.fields}");
//   //
//   //   request.headers.addAll(headers);
//   //   http.StreamedResponse response = await request.send();
//   //   print('${response.statusCode}_____________statuscode');
//   //
//   //   if (response.statusCode == 200) {
//   //     print('_____________');
//   //
//   //     var finalResult = await response.stream.bytesToString();
//   //     final jsonResponse =
//   //         GetPharmaCategory.fromJson(json.decode(finalResult)).data;
//   //     //Fluttertoast.showToast(msg: "${jsonResponse}");
//   //
//   //     setState(() {
//   //       pharmaCategoryList = jsonResponse ?? [];
//   //     });
//   //   } else {
//   //     //Fluttertoast.showToast(msg: "${detailsData?.message}");
//   //     // Fluttertoast.showToast(msg: "${jsonResponse['message']}");
//   //     // Navigator.push(
//   //     //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
//   //     print(response.reasonPhrase);
//   //   }
//   // }
//
//   bool isChecked = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // getPharmaCategory(widget.category);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StatefulBuilder(builder: (context, setState) {
//       return AlertDialog(
//         title: const Text('Select Multiple Categories'),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: pharmaCategoryList
//                 .map((item) =>
//                 CheckboxListTile(
//                   activeColor:primary,
//                   value: _selectedItems.contains(item),
//                   title: Text(item.name!),
//                   controlAffinity: ListTileControlAffinity.leading,
//                   onChanged: (isChecked) => _itemChange(item, isChecked!),
//                 ))
//                 .toList(),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: _cancel,
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color:primary),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(),
//             child: Text('Submit'),
//             onPressed: () {
//               // _submit();
//               Navigator.pop(context, _selectedItems);
//             }
//             ,
//           ),
//         ],
//       );
//     });
//   }
// }
