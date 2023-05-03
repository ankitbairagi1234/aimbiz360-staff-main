import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:eshopmultivendor/Helper/ApiBaseHelper.dart';
import 'package:eshopmultivendor/Helper/AppBtn.dart';
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Constant.dart';
import 'package:eshopmultivendor/Helper/PushNotificationService.dart';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Localization/Language_Constant.dart';
import 'package:eshopmultivendor/Model/CategoryModel/categoryModel.dart';
import 'package:eshopmultivendor/Model/OrdersModel/OrderModel.dart';
import 'package:eshopmultivendor/Model/ZipCodesModel/ZipCodeModel.dart';
import 'package:eshopmultivendor/Model/all_users_model.dart';
import 'package:eshopmultivendor/Model/my_leads_model.dart';
import 'package:eshopmultivendor/Screen/Add_Product.dart';
import 'package:eshopmultivendor/Screen/Authentication/Login.dart';
import 'package:eshopmultivendor/Screen/Authentication/SetNewPassword.dart';
import 'package:eshopmultivendor/Screen/Media.dart';
import 'package:eshopmultivendor/Screen/TermFeed/Contact_Us.dart';
import 'package:eshopmultivendor/Screen/Customers.dart';
import 'package:eshopmultivendor/Screen/OrderList.dart';
import 'package:eshopmultivendor/Screen/TermFeed/Privacy_Policy.dart';
import 'package:eshopmultivendor/Screen/ProductList.dart';
import 'package:eshopmultivendor/Screen/WalletHistory.dart';
import 'package:eshopmultivendor/Screen/daily_collection.dart';
import 'package:eshopmultivendor/Screen/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Helper/Indicator.dart';
import '../main.dart';
import 'Profile.dart';
import 'TermFeed/Terms_Conditions.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

int? total, offset;
List<Order_Model> orderList = [];
bool _isLoading = true;
bool isLoadingmore = true;
// List<PersonModel> delBoyList = [];
List<ZipCodeModel> zipCodeList = [];
List<CategoryModel> catagoryList = [];
String? delPermission;
ApiBaseHelper apiBaseHelper = ApiBaseHelper();

class _HomeState extends State<Home> with TickerProviderStateMixin {
//==============================================================================
//============================= Variables Declaration ==========================
  int curDrwSel = 0;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String?> languageList = [];
  List<Order_Model> tempList = [];
  String? all,
      received,
      processed,
      shipped,
      delivered,
      cancelled,
      returned,
      awaiting;
  String _searchText = "";
  String? totalorderCount,
      totalproductCount,
      totalcustCount,
      totaldelBoyCount,
      totalsoldOutCount,
      totallowStockCount;

  List<String> leadStatus = [
    'All',
    'New Lead',
  'Open',
  'Follow Up',
   'Proceeded',
   'Not Interested',
    'Closed',
    'Rejected',
  'Not eligible for the product'
  ];

  List<String> leadStatus1 = [
    'New Lead',
    'Open',
    'Follow Up',
    'Proceeded',
    'Not Interested',
    'Closed',
    'Rejected',
    'Not eligible for the product'
  ];

  String? categoryValue;
  String? categoryValue1;
  String? selectedUser;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  ScrollController? controller; // = new ScrollController();
  int? selectLan;
  bool _isNetworkAvail = true;
  String? activeStatus;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List<String> statusList = [
    ALL,
    PLACED,
    PROCESSED,
    SHIPED,
    DELIVERD,
    CANCLED,
    RETURNED,
    awaitingPayment
  ];

//==============================================================================
//===================================== For Chart ==============================

  int curChart = 0;
  Map<int, LineChartData>? chartList;
  List? days = [], dayEarning = [];
  List? months = [], monthEarning = [];
  List? weeks = [], weekEarning = [];
  List? catCountList = [], catList = [];
  List colorList = [];
  int? touchedIndex;

//==============================================================================
//============================= For Language Selection =========================

  List<String> langCode = [
    ENGLISH,
    HINDI,
    CHINESE,
    SPANISH,
    ARABIC,
    RUSSIAN,
    JAPANESE,
    DEUTSCH
  ];

  var onOf = false;

//==============================================================================
//============================= initState Method ===============================

  List<MyLeads> leadsList = [];
  List<AllUsersList> usersList = [];

  getMyLeads(String status) async{
    var headers = {
      // 'Token': jwtToken.toString(),
      // 'Authorisedkey': authKey.toString(),
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request = http.MultipartRequest('POST', Uri.parse(leadsApi.toString()));
    request.fields.addAll({
      'user_id': '$CUR_USERID',
      'status' : status.toString(),
      // categoryValue != null ?
      //     categoryValue.toString()
      //     : "",
      'ass_id': selectedUser != null ?
          selectedUser.toString()
          :""
    });

    print("this is refer request ${request.fields.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      var finalResponse = MyLeadsModel.fromJson(result);
      setState(() {
        leadsList = finalResponse.data!;
      });
      print("this is referral data ${leadsList.length}");
      // setState(() {
      // animalList = finalResponse.data!;
      // });
      // print("this is operator list ----->>>> ${operatorList[0].name}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getAllUsers() async{
    var headers = {
      // 'Token': jwtToken.toString(),
      // 'Authorisedkey': authKey.toString(),
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request = http.MultipartRequest('POST', Uri.parse(allUsersApi.toString()));
    // request.fields.addAll({
    //   'user_id': '$CUR_USERID',
    //   'status' : categoryValue != null ?
    //   categoryValue.toString()
    //       : ""
    // });

    print("this is refer request ${request.fields.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      var finalResponse = AllUsersModel.fromJson(result);
      setState(() {
        usersList = finalResponse.data!;
      });
      print("this is referral data ${usersList.length}");
      // setState(() {
      // animalList = finalResponse.data!;
      // });
      // print("this is operator list ----->>>> ${operatorList[0].name}");
    }
    else {
      print(response.reasonPhrase);
    }
  }


  Future<void> showInformationDialog(BuildContext context, int index, MyLeads model) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.only(top: 90.0, bottom: 0),
              child: AlertDialog(
                content:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // status == "New Lead" ?
                    // Container(
                    // padding: EdgeInsets.all(8),
                    // decoration: BoxDecoration(
                    // color: primary,
                    // borderRadius: BorderRadius.circular(10)
                    // ),
                    // child: Center(child: Text("Open",
                    //     style: TextStyle(fontSize: 14,
                    // color: Colors.white,
                    // fontWeight: FontWeight.w600)))) :

                    Container(
                      padding: EdgeInsets.only(left: 5),
                      width: MediaQuery.of(context).size.width -10,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: primary)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text('Select Status'), // Not necessary for Option 1
                          value: categoryValue1,
                          onChanged: (String? newValue) {
                            setState(() {
                              categoryValue1 = newValue!;
                            });
                            print("this is dropdown value ${categoryValue1}");
                            // updateLeadStatus(newValue!, leadsList[index].id.toString());
                          },
                          items: leadStatus1.map((item) {
                            return DropdownMenuItem(
                              child:  Text(item),
                              value: item,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: primary)
                      ),
                      child: TextFormField(
                        controller: remarkController,
                        decoration: InputDecoration(
                            hintText: "Remark",
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    const SizedBox(height: 25,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(onPressed: (){
                         Navigator.pop(context);
                        }, child: Text("Cancel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
                          style: ElevatedButton.styleFrom(primary: primary,
                          fixedSize: Size(80, 35)),
                        ),


                        ElevatedButton(onPressed: (){
                          print("this is category value $categoryValue1");
                          if(categoryValue1 == null || categoryValue1 == '') {
                            Fluttertoast.showToast(msg: "Please select any status!");
                          }else{
                            updateLeadStatus(categoryValue1.toString(),
                                leadsList[index].id.toString());
                          }
                        }, child: Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
                          style: ElevatedButton.styleFrom(primary: primary,
                              fixedSize: Size(80, 35)),
                        ),
                      ],
                    ),

                  ],
                ),
                title: Text('Change Lead Status'),
                // actions: <Widget>[
                //   InkWell(
                //     child: Text('OK   '),
                //     onTap: () {
                //       if (_formKey.currentState.validate()) {
                //         // Do something like updating SharedPreferences or User Settings etc.
                //         Navigator.of(context).pop();
                //       }
                //     },
                //   ),
                // ],
              ),
            );
          });
        });
  }

  TextEditingController remarkController = TextEditingController();

  updateLeadStatus(String status, leadId) async{
    var headers = {
      // 'Token': jwtToken.toString(),
      // 'Authorisedkey': authKey.toString(),
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request = http.MultipartRequest('POST', Uri.parse(updateLeadStatusApi.toString()));
    request.fields.addAll({
      'lead_id': '$leadId',
      'status': '${status.toString()}',
      'remark': remarkController.text.toString()

    });

    print("this is update lead status request ${request.fields.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      Fluttertoast.showToast(msg: result['message'].toString());
      setState(() {
        categoryValue1 = null;
      });
      Navigator.pop(context);
      remarkController.clear();
      _refresh();


      // setState(() {
      // animalList = finalResponse.data!;
      // });
      // print("this is operator list ----->>>> ${operatorList[0].name}");
    }
    else {
      print(response.reasonPhrase);
    }
  }
  
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.light,
    //   systemNavigationBarColor: Colors.transparent,
    // ));
    final pushNotificationService = PushNotificationService(context: context);
    pushNotificationService.initialise();
    offset = 0;
    total = 0;
    chartList = {0: dayData(), 1: weekData(), 2: monthData()};

    orderList.clear();
    getSaveDetail();
    getStatics();
    getAllUsers();
    // getSallerDetail();
    //  getDeliveryBoy();
    getZipCodes();
    getCategories();
    Future.delayed(Duration(seconds: 1), (){
      getMyLeads('');
    });
    //  getOrder();

    buttonController = new AnimationController(
      duration: new Duration(milliseconds: 2000),
      vsync: this,
    );

    buttonSqueezeanimation = new Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: buttonController!,
        curve: new Interval(
          0.0,
          0.150,
        ),
      ),
    );
    controller = ScrollController(keepScrollOffset: true);
    // controller!.addListener(_scrollListener);
    new Future.delayed(
      Duration.zero,
      () {
        languageList = [
          getTranslated(context, 'English'),
          getTranslated(context, 'Hindi'),
          getTranslated(context, 'Chinese'),
          getTranslated(context, 'Spanish'),
          getTranslated(context, 'Arabic'),
          getTranslated(context, 'Russian'),
          getTranslated(context, 'Japanese'),
          getTranslated(context, 'Deutch'),
        ];
      },
    );
    super.initState();
  }

//==============================================================================
//============================= For Animation ==================================
  getSaveDetail() async {
    print("we are here");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getlng = await getPrefrence(LAGUAGE_CODE) ?? '';

    selectLan = langCode.indexOf(getlng == '' ? "en" : getlng);
  }

//==============================================================================
//============================= For Animation ==================================
  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }



//==============================================================================
//============================= Build Method ===================================


  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: white, // status bar color
    //     systemNavigationBarColor: black,
    //   ),
    // );
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
        color: primary,
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child:
      Scaffold(
      key: _scaffoldKey,
      backgroundColor: lightWhite,
      appBar: getAppBar(context),
      drawer: getDrawer(context),
      body:
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: primary)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Filter by : ", style: TextStyle(
                        fontSize: 20, color: Colors.black87
                    ),),
                    Text("Status : ", style: TextStyle(
                      fontWeight: FontWeight.w600,
                        fontSize: 16, color: Colors.black87
                    ),),
                    Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          height: 50,
                          width: MediaQuery.of(context).size.width ,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: fontColor)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text('Select type'), // Not necessary for Option 1
                              value: categoryValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  categoryValue = newValue;
                                });
                                if(categoryValue == "All"){
                                  getMyLeads('');
                                }
                                else {
                                  getMyLeads(categoryValue.toString());
                                }

                              },
                              items: leadStatus.map((item) {
                                return DropdownMenuItem(
                                  child:  Text(item, style:TextStyle(color: fontColor),),
                                  value: item,
                                );
                              }).toList(),
                            ),
                          ),
                        )
                    ),
                    Text("Referral Associate : ", style: TextStyle(
                        fontSize: 16, color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),),
                    Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: fontColor)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text('Select Referral Associate'), // Not necessary for Option 1
                              value: selectedUser,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedUser = newValue;
                                });
                                if(categoryValue == "All"){
                                  getMyLeads('');
                                }
                                else {
                                  getMyLeads(categoryValue.toString());
                                }

                              },
                              items: usersList.map((item) {
                                return DropdownMenuItem(
                                  child:  Text(item.username!, style:TextStyle(color: fontColor),),
                                  value: item.id,
                                );
                              }).toList(),
                            ),
                          ),
                        )
                    )
                  ],
                ),),
            ),
            leadsList.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                  itemCount: leadsList.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        height: 345,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: primary),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("Product : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
                                    Text(leadsList[index].product.toString(),
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: primary) ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
                                    Text(DateFormat('dd MMM yyyy').format(DateTime.parse(leadsList[index].createdAt.toString())).toString(),
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: fontColor) ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Referred To : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
                                Text(leadsList[index].name.toString(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Contact No.: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
                                Text(leadsList[index].mobile.toString(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Referral Associate Details: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),

                                Container(
                                  width: 100,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: leadsList[index].shareInfo.toString() == "1"?
                                      Colors.green : Colors.red
                                  ),
                                  child: Center(
                                    child: Text(leadsList[index].shareInfo.toString() == "1"?
                                    "Share"
                                        : "Do Not Share",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            leadsList[index].shareInfo.toString() == "1" ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Referral Associate : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
                                Text(leadsList[index].refferFrom.toString(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
                              ],
                            )
                            : SizedBox.shrink(),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Remark : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
                                Container(
                                  width: 240,
                                  child: Text(
                                      leadsList[index].remark == null || leadsList[index].remark.toString() == ''?
                                          ""
                                      : leadsList[index].remark.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Status : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(border: Border.all(color: primary, ),
                                  borderRadius: BorderRadius.circular(15)),
                                  child: Text(leadsList[index].status.toString(),
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Divider(
                              thickness: 2,
                              color: secondary,
                            ),
                            // Expanded(
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(right: 8.0),
                            //     child: DropdownButtonFormField(
                            //       dropdownColor: white,
                            //       isDense: true,
                            //       iconEnabledColor: primary,
                            //       hint: Text(
                            //         getTranslated(context, "UpdateStatus")!,
                            //         style: Theme.of(this.context)
                            //             .textTheme
                            //             .subtitle2!
                            //             .copyWith(
                            //             color: primary,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //       decoration: InputDecoration(
                            //         filled: true,
                            //         isDense: true,
                            //         fillColor: white,
                            //         contentPadding: EdgeInsets.symmetric(
                            //             vertical: 10, horizontal: 10),
                            //         enabledBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(color: primary),
                            //         ),
                            //       ),
                            //       value: orderItem.status,
                            //       onChanged: (dynamic newValue) {
                            //         setState(
                            //               () {
                            //             orderItem.curSelected = newValue;
                            //             updateOrder(
                            //               orderItem.curSelected,
                            //               updateOrderItemApi,
                            //               model.id,
                            //               true,
                            //               i,
                            //             );
                            //           },
                            //         );
                            //       },
                            //       items: statusList.map(
                            //             (String st) {
                            //           return DropdownMenuItem<String>(
                            //             value: st,
                            //             child: Text(
                            //               capitalize(st),
                            //               style: Theme.of(this.context)
                            //                   .textTheme
                            //                   .subtitle2!
                            //                   .copyWith(
                            //                   color: primary,
                            //                   fontWeight:
                            //                   FontWeight.bold),
                            //             ),
                            //           );
                            //         },
                            //       ).toList(),
                            //     ),
                            //   ),
                            // ),
                           // statusUpdateWidget(index, leadsList[index]),
                            leadsList[index].status.toString() == "Closed"?
                                SizedBox.shrink():
                            ElevatedButton(onPressed: (){
                              showInformationDialog(context, index, leadsList[index]);
                            }, child: Text("Change Status", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(MediaQuery.of(context).size.width - 60, 50),
                                  primary: primary, shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),

                              )),
                            )
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 60,
                            //   child: Row(
                            //     children: [
                            //       Container(
                            //         width: MediaQuery.of(context).size.width/2,
                            //         height: 60,
                            //         child: DropdownButton(
                            //           hint: Text('Select Status'), // Not necessary for Option 1
                            //           value: categoryValue,
                            //           onChanged: (String? newValue) {
                            //             setState(() {
                            //               categoryValue = newValue;
                            //             });
                            //           },
                            //           items: leadStatus.map((item) {
                            //             return DropdownMenuItem(
                            //               child:  Text(item),
                            //               value: item,
                            //             );
                            //           }).toList(),
                            //         ),
                            //       ),
                            //       // Container(
                            //       //     padding: EdgeInsets.all(8),
                            //       //     decoration: BoxDecoration(
                            //       //         color: secondary,
                            //       //         borderRadius: BorderRadius.circular(10)
                            //       //     ),
                            //       //     child: Center(child: Text(leadsList[index].status.toString(), style: TextStyle(fontSize: 14,
                            //       //         color: Colors.white,
                            //       //         fontWeight: FontWeight.w600)))),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
                : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: Center(child: Text("No data found !!")),
            ),
          ],
        ),
      )

      // body: getBodyPart(),
      // floatingActionButton: floatingBtn(),
    )
    );
  }

//==============================================================================
//=============================== floating Button ==============================
  floatingBtn() {
    return FloatingActionButton(
      backgroundColor: white,
      child: Icon(
        Icons.add,
        size: 32,
        color: fontColor,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddProduct(),
          ),
        );
      },
    );
  }

//==============================================================================
//=============================== chart coding  ================================
  getChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        height: 250,
        child: Card(
          elevation: 0,
          margin: EdgeInsets.only(top: 10, left: 5, right: 15),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: Text(
                    getTranslated(context, "ProductSales")!,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: primary),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: curChart == 0
                        ? TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: primary,
                            onSurface: Colors.grey,
                          )
                        : null,
                    onPressed: () {
                      setState(
                        () {
                          curChart = 0;
                        },
                      );
                    },
                    child: Text(
                      getTranslated(context, "Day")!,
                    ),
                  ),
                  TextButton(
                    style: curChart == 1
                        ? TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: primary,
                            onSurface: Colors.grey,
                          )
                        : null,
                    onPressed: () {
                      setState(
                        () {
                          curChart = 1;
                        },
                      );
                    },
                    child: Text(
                      getTranslated(context, "Week")!,
                    ),
                  ),
                  TextButton(
                    style: curChart == 2
                        ? TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: primary,
                            onSurface: Colors.grey,
                          )
                        : null,
                    onPressed: () {
                      setState(
                        () {
                          curChart = 2;
                        },
                      );
                    },
                    child: Text(
                      getTranslated(context, "Month")!,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: LineChart(
                  chartList![curChart]!,
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

//1. LineChartData

  LineChartData dayData() {
    if (dayEarning!.length == 0) {
      dayEarning!.add(0);
      days!.add(0);
    }
    List<FlSpot> spots = dayEarning!.asMap().entries.map((e) {
      return FlSpot(double.parse(days![e.key].toString()),
          double.parse(e.value.toString()));
    }).toList();

    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2,
          colors: [
            grad2Color,
          ],
          belowBarData: BarAreaData(
            show: true,
            colors: [primary.withOpacity(0.5)],
          ),
          aboveBarData: BarAreaData(
            show: true,
            colors: [fontColor.withOpacity(0.2)],
          ),
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
      minY: 0,
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 3,
            getTextStyles: (context, value) => const TextStyle(
                  color: black,
                  fontSize: 9,
                ),
            margin: 10,
            getTitles: (value) {
              return value.toInt().toString();
            }),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: black,
            fontSize: 9,
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: fontColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  //2. catChart

  LineChartData weekData() {
    if (weekEarning!.length == 0) {
      weekEarning!.add(0);
      weeks!.add(0);
    }
    List<FlSpot> spots = weekEarning!.asMap().entries.map((e) {
      return FlSpot(
          double.parse(e.key.toString()), double.parse(e.value.toString()));
    }).toList();

    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2,
          colors: [
            grad2Color,
          ],
          belowBarData: BarAreaData(
            show: true,
            colors: [
              primary.withOpacity(0.5),
            ],
          ),
          aboveBarData: BarAreaData(
            show: true,
            colors: [fontColor.withOpacity(0.2)],
          ),
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
      minY: 0,
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 4,
            getTextStyles: (context, value) => const TextStyle(
                  color: black,
                  fontSize: 9,
                ),
            margin: 10,
            getTitles: (value) {
              return weeks![value.toInt()].toString();
            }),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: black,
            fontSize: 9,
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: fontColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  //2. monthData

  LineChartData monthData() {
    if (monthEarning!.length == 0) {
      monthEarning!.add(0);
      months!.add(0);
    }

    List<FlSpot> spots = monthEarning!.asMap().entries.map((e) {
      return FlSpot(
          double.parse(e.key.toString()), double.parse(e.value.toString()));
    }).toList();

    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2,
          colors: [
            grad2Color,
          ],
          belowBarData: BarAreaData(
            show: true,
            colors: [primary.withOpacity(0.5)],
          ),
          aboveBarData: BarAreaData(
            show: true,
            colors: [fontColor.withOpacity(0.2)],
          ),
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
      minY: 0,
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: black,
            fontSize: 9,
          ),
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 3,
          getTextStyles: (context, value) => const TextStyle(
            color: black,
            fontSize: 9,
          ),
          margin: 10,
          getTitles: (value) {
            return months![value.toInt()];
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: fontColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  Color generateRandomColor() {
    Random random = Random();
    // Pick a random number in the range [0.0, 1.0)
    double randomDouble = random.nextDouble();

    return Color((randomDouble * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

//==============================================================================
//========================= getZipcodesApi API =================================

  Future<void> getCategories() async {
    CUR_USERID = await getPrefrence(Id);
    var parameter = {
      SellerId: CUR_USERID,
    };
    apiBaseHelper.postAPICall(getCategoriesApi, parameter).then(
      (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          catagoryList.clear();
          var data = getdata["data"];
          catagoryList = (data as List)
              .map((data) => new CategoryModel.fromJson(data))
              .toList();
        } else {
          setSnackbar(msg!);
        }
      },
      onError: (error) {
        setSnackbar(error.toString());
      },
    );
  }

//==============================================================================
//========================= getZipcodesApi API =================================

  Future<void> getZipCodes() async {
    var parameter = {};
    apiBaseHelper.postAPICall(getZipcodesApi, parameter).then(
      (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          zipCodeList.clear();
          var data = getdata["data"];
          zipCodeList = (data as List)
              .map((data) => new ZipCodeModel.fromJson(data))
              .toList();
        } else {
          setSnackbar(msg!);
        }
      },
      onError: (error) {
        setSnackbar(error.toString());
      },
    );
  }

//==============================================================================
//========================= getDeliveryBoy API =================================

  // Future<void> getDeliveryBoy() async {
  //   CUR_USERID = await getPrefrence(Id);
  //   var parameter = {
  //     SellerId: CUR_USERID,
  //   };
  //   apiBaseHelper.postAPICall(getDeliveryBoysApi, parameter).then(
  //     (getdata) async {
  //       bool error = getdata["error"];
  //       String? msg = getdata["message"];
  //
  //       if (!error) {
  //         delBoyList.clear();
  //         var data = getdata["data"];
  //         delBoyList = (data as List)
  //             .map((data) => new PersonModel.fromJson(data))
  //             .toList();
  //       } else {
  //         setSnackbar(msg!);
  //       }
  //     },
  //     onError: (error) {
  //       setSnackbar(error.toString());
  //     },
  //   );
  // }

//==============================================================================
//========================= getStatics API =====================================

  Future<Null> getStatics() async {
    CUR_USERID = await getPrefrence(Id);
    CUR_USERNAME = await getPrefrence(Username);
    LOGO = (await getPrefrence(IMage))!;
    var parameter = {SellerId: CUR_USERID};

    apiBaseHelper.postAPICall(getStatisticsApi, parameter).then(
      (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];
        print(getStatisticsApi);
        print(parameter.toString());
        if (!error) {
          CUR_CURRENCY = getdata["currency_symbol"];
          var count = getdata['counts'][0];
          totalorderCount = count["order_counter"];
          totalproductCount = count["product_counter"];
          totalsoldOutCount = count['count_products_sold_out_status'];
          totallowStockCount = count["count_products_low_status"];
          totalcustCount = count["user_counter"];
          delPermission = count["permissions"]['assign_delivery_boy'];
          weekEarning = getdata['earnings'][0]["weekly_earnings"]['total_sale'];
          days = getdata['earnings'][0]["daily_earnings"]['day'];
          dayEarning = getdata['earnings'][0]["daily_earnings"]['total_sale'];
          months = getdata['earnings'][0]["monthly_earnings"]['month_name'];
          monthEarning =
              getdata['earnings'][0]["monthly_earnings"]['total_sale'];

          weeks = getdata['earnings'][0]["weekly_earnings"]['week'];
          //  if (chartList != null) chartList!.clear();
          chartList = {0: dayData(), 1: weekData(), 2: monthData()};

          catCountList = getdata['category_wise_product_count']['counter'];
          catList = getdata['category_wise_product_count']['cat_name'];
          colorList.clear();
          for (int i = 0; i < catList!.length; i++)
            colorList.add(generateRandomColor());
        } else {
          // setSnackbar(msg!);
        }

        setState(() {
          _isLoading = false;
        });
      },
      onError: (error) {
        // setSnackbar(error.toString());
      },
    );
    return null;
  }

//==============================================================================
//========================= get_seller_details API =============================

  Future<Null> getSallerDetail() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      CUR_USERID = await getPrefrence(Id);

      var parameter = {Id: CUR_USERID};
      apiBaseHelper.postAPICall(getSellerDetails, parameter).then(
        (getdata) async {
          bool error = getdata["error"];
          String? msg = getdata["message"];

          if (!error) {
            var data = getdata["data"][0];
            print(data);
            CUR_BALANCE = double.parse(data[BALANCE]).toStringAsFixed(2);
            LOGO = data["logo"].toString();
            RATTING = data[Rating] ?? "";
            NO_OFF_RATTING = data[NoOfRatings] ?? "";
            NO_OFF_RATTING = data[NoOfRatings] ?? "";
            var id = data[Id];
            var username = data[Username];
            var email = data[Email];
            var mobile = data[Mobile];
            var address = data[Address];
            var image = data[IMage];
            CUR_USERID = id!;
            CUR_USERNAME = username!;
            var srorename = data[Storename];
            var storeurl = data[Storeurl];
            var storeDesc = data[storeDescription];
            var accNo = data[accountNumber];
            var accname = data[accountName];
            var bankCode = data[BankCOde];
            var bankName = data[bankNAme];
            var latitutute = data[Latitude];
            var longitude = data[Longitude];
            var taxname = data[taxName];
            var tax_number = data[taxNumber];
            var pan_number = data[panNumber];
            var status = data[STATUS];
            var storeLogo = data[StoreLogo];
            onOf = data["online"] == "0" ? false : true;

            print("bank name : $bankName");
            saveUserDetail(
              id!,
              username!,
              email!,
              mobile!,
              image,
              address!,
              srorename!,
              storeurl!,
              storeDesc!,
              accNo!,
              accname!,
              bankCode ?? "",
              bankName ?? "",
              latitutute ?? "",
              longitude ?? "",
              taxname ?? "",
              tax_number!,
              pan_number!,
              status!,
              storeLogo!,
            );
          }
          setState(() {
            _isLoading = false;
          });
        },
        onError: (error) {
          setSnackbar(error.toString());
        },
      );
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
          _isLoading = false;
        });
    }

    return null;
  }

  Future<void> shopStatus() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var parameter = {
        "id": "$CUR_USERID",
        "open_close_status": onOf ? "1" : "0"
      };
      apiBaseHelper
          .postAPICall(updateUserApi, parameter)
          .then((getdata) async {
        bool error = getdata["error"];
        if (!error) {
          setState(() {
            print("Success");
          });
        } else {
          print("Failed");
        }
      });
    }
  }

//==============================================================================
//============================ AppBar ==========================================

  getAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Image.asset('assets/logo/homelogo.png'),
      backgroundColor: white,
      iconTheme: IconThemeData(color: grad2Color),
      actions: [
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     onOf ? Text("Online") : Text("Offline"),
        //   ],
        // ),
        // CupertinoSwitch(
        //     trackColor: primary,
        //     value: onOf,
        //     onChanged: (value) {
        //       setState(() {
        //         onOf = value;
        //         shopStatus();
        //       });
        //     })
      ],
    );
  }

//==============================================================================
//================================ SnackBar ====================================

  setSnackbar(String msg) {
ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(color: black),
        ),
        backgroundColor: white,
        elevation: 1.0,
      ),
    );
  }

//==============================================================================
//============================= Drawer Implimentation ==========================

  getDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: white,
          child: ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              _getHeader(),
              Divider(),
              _getDrawerItem(
                  0, getTranslated(context, "HOME")!, Icons.home_outlined),
              // _getDrawerItem(1, getTranslated(context, "ORDERS")!,
              //     Icons.shopping_basket_outlined),
              // Divider(),
              // _getDrawerItem(
              //     2, getTranslated(context, "CUSTOMERS")!, Icons.person),
              // _getDrawerItem(3, getTranslated(context, "WALLETHISTORY")!,
              //     Icons.account_balance_wallet_outlined),
              // // _getDrawerItem(11, "Daily Collection", Icons.account_balance_wallet_outlined),
              // _getDrawerItem(12, "Transaction",
              //     Icons.compare_arrows_sharp),
              // Divider(),
              // _getDrawerItem(4, getTranslated(context, "PRODUCTS")!,
              //     Icons.production_quantity_limits_outlined),
              // _getDrawerItem(10, "Add Product", Icons.add),
              // Divider(),
              // _getDrawerItem(5, getTranslated(context, "ChangeLanguage")!,
              //     Icons.translate),
              _getDrawerItem(6, getTranslated(context, "T_AND_C")!,
                  Icons.speaker_notes_outlined),
              // Divider(),
              _getDrawerItem(7, getTranslated(context, "PRIVACYPOLICY")!,
                  Icons.lock_outline),
              _getDrawerItem(2, getTranslated(context, "CHANGE_PASS_LBL")!,
                  Icons.password_rounded),
              _getDrawerItem(
                  9, getTranslated(context, "CONTACTUS")!, Icons.contact_page),
              Divider(),
              _getDrawerItem(
                  8, getTranslated(context, "LOGOUT")!, Icons.home_outlined),
            ],
          ),
        ),
      ),
    );
  }

//  => Drawer Header

  _getHeader() {
    return InkWell(
      child: Container(
        decoration: back(),
        padding: EdgeInsets.only(left: 10.0, bottom: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CUR_USERNAME!,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: white, fontWeight: FontWeight.bold),
                  ),
                  // Text(
                  //   getTranslated(context, "WALLET_BAL")! +
                  //       ": " +
                  //       CUR_CURRENCY +
                  //       "" +
                  //       CUR_BALANCE,
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .caption!
                  //       .copyWith(color: white),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 7,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getTranslated(context, "EDIT_PROFILE_LBL")!,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: white),
                        ),
                        Icon(
                          Icons.arrow_right_outlined,
                          color: white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(top: 20, right: 20),
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.0,
                  color: white,
                ),
              ),
              child: LOGO != ''
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: sallerLogo(62),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: imagePlaceHolder(62),
                    ),
            ),
          ],
        ),
      ),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(),
          ),
        ).then((value) {
          print("back frome profile screen");
          getStatics();
          // getSallerDetail();
          //  getDeliveryBoy();
          getZipCodes();
          getCategories();
          setState(() {});
          Navigator.pop(context);
        });
        setState(() {});
      },
    );
  }

//  => PlaceHolder Image For Drawer Header
  sallerLogo(double size) {
    return CircleAvatar(
      backgroundImage: NetworkImage(LOGO),
      radius: 25,
    );
  }

  imagePlaceHolder(double size) {
    return new Container(
      height: size,
      width: size,
      child: Icon(
        Icons.account_circle,
        color: Colors.white,
        size: size,
      ),
    );
  }

//  => Drawer Item List

  _getDrawerItem(int index, String title, IconData icn) {
    return Container(
      margin: EdgeInsets.only(
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: curDrwSel == index
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [secondary.withOpacity(0.2), primary.withOpacity(0.2)],
                stops: [0, 1],
              )
            : null,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icn,
          color: curDrwSel == index ? primary : lightBlack2,
        ),
        title: Text(
          title,
          style: TextStyle(
              color: curDrwSel == index ? primary : lightBlack2, fontSize: 15),
        ),
        onTap: () {
          if (title == getTranslated(context, "HOME")!) {
            setState(
              () {
                curDrwSel = index;
              },
            );
            Navigator.pop(context);
          }
          else if (title == getTranslated(context, "ORDERS")!) {
            setState(
              () {
                curDrwSel = index;
              },
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderList(),
              ),
            );
          }
          else if (title == getTranslated(context, "CHANGE_PASS_LBL")!) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SetPass(mobileNumber: '')));
            // setState(
            //       () {
            //     curDrwSel = index;
            //   },
            // );
            // Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => OrderList(),
            //   ),
            // );
          }
          else if (title == getTranslated(context, "CUSTOMERS")!) {
            setState(
              () {
                curDrwSel = index;
              },
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Customers(),
              ),
            );
          }
          else if (title == getTranslated(context, "WALLETHISTORY")!) {
            setState(
              () {
                curDrwSel = index;
              },
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WalletHistory(),
              ),
            );
          }
          else if (title == "Daily Collection") {
            setState(
                  () {
                curDrwSel = index;
              },
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DailyCollection(),
              ),
            );
          }
          else if (title == "Transaction") {
            setState(
                  () {
                curDrwSel = index;
              },
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionDetails(),
              ),
            );
          }
          else if (title == getTranslated(context, "PRODUCTS")!) {
            setState(
              () {
                curDrwSel = index;
              },
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductList(
                  flag: '',
                ),
              ),
            );
          }
          else if (title == getTranslated(context, "ChangeLanguage")!) {
            setState(
              () {
                curDrwSel = index;
              },
            );
            languageDialog();
          }
          else if (title == getTranslated(context, "T_AND_C")!) {
            setState(
              () {
                curDrwSel = index;
              },
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Terms_And_Condition(),
              ),
            );
          }
          else if (title == getTranslated(context, "CONTACTUS")!) {
            setState(
              () {
                curDrwSel = index;
              },
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactUs(),
              ),
            ).then((value) {
              setState(() {});
            });
          }
          else if (title == getTranslated(context, "PRIVACYPOLICY")!) {
            setState(
              () {
                curDrwSel = index;
              },
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivacyPolicy(),
              ),
            );
          }
          else if (title == getTranslated(context, "LOGOUT")!) {
            Navigator.pop(context);
            logOutDailog();
          }
          else if (title == "Add Product") {
            setState(
              () {
                curDrwSel = index;
              },
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProduct(),
              ),
            );
          }
        },
      ),
    );
  }

//==============================================================================
//============================= Language Implimentation ========================

  languageDialog() async {
    await dialogAnimate(
      context,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                  child: Text(
                    getTranslated(context, 'CHOOSE_LANGUAGE_LBL')!,
                    style: Theme.of(this.context).textTheme.subtitle1!.copyWith(
                          color: fontColor,
                        ),
                  ),
                ),
                Divider(color: lightBlack),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: getLngList(context)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

//==============================================================================
//======================== Language List Generate ==============================

  List<Widget> getLngList(BuildContext ctx) {
    return languageList
        .asMap()
        .map(
          (index, element) => MapEntry(
            index,
            InkWell(
              onTap: () {
                if (mounted)
                  setState(
                    () {
                      selectLan = index;
                      _changeLan(langCode[index], ctx);
                    },
                  );
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 25.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectLan == index ? grad2Color : white,
                            border: Border.all(color: grad2Color),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: selectLan == index
                                ? Icon(
                                    Icons.check,
                                    size: 17.0,
                                    color: white,
                                  )
                                : Icon(
                                    Icons.check_box_outline_blank,
                                    size: 15.0,
                                    color: white,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 15.0,
                          ),
                          child: Text(
                            languageList[index]!,
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: lightBlack),
                          ),
                        )
                      ],
                    ),
                    index == languageList.length - 1
                        ? Container(
                            margin: EdgeInsetsDirectional.only(
                              bottom: 10,
                            ),
                          )
                        : Divider(
                            color: lightBlack,
                          ),
                  ],
                ),
              ),
            ),
          ),
        )
        .values
        .toList();
  }

  void _changeLan(String language, BuildContext ctx) async {
    Locale _locale = await setLocale(language);

    MyApp.setLocale(ctx, _locale);
  }

//==============================================================================
//============================= Log-Out Implimentation =========================

  logOutDailog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              content: Text(
                getTranslated(context, "LOGOUTTXT")!,
                style: Theme.of(this.context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: fontColor),
              ),
              actions: <Widget>[
                new TextButton(
                    child: Text(
                      getTranslated(context, "LOGOUTNO")!,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: lightBlack, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
                new TextButton(
                  child: Text(
                    getTranslated(context, "LOGOUTYES")!,
                    style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                        color: fontColor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    clearUserSession();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

//==============================================================================
//=========================== Body Part Implimentation =========================

  getBodyPart() {
    return _isNetworkAvail
        ? _isLoading
            ? shimmer()
            : RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 8,
                      right: 8,
                    ),
                    child: Column(
                      children: [
                        firstHeader(),
                        // secondHeader(),
                        thirdHeader(),
                        SizedBox(height: 5),
                        getChart(),
                        catChart(),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              )
        : noInternet(context);
  }

//==============================================================================
//============================ Category Chart ==============================

  catChart() {
    Size size = MediaQuery.of(context).size;
    double width = size.width > size.height ? size.height : size.width;
    double ratio;
    if (width > 600) {
      ratio = 0.5;
      // Do something for tablets here
    } else {
      ratio = 0.8;
      // Do something for phones
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: AspectRatio(
        aspectRatio: 1.23,
        child: Card(
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getTranslated(context, "CatWiseCount")!,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: primary),
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      height: 18,
                    ),
                    Expanded(
                      flex: 2,
                      child: AspectRatio(
                        aspectRatio: .8,
                        child: Stack(
                          children: [
                            PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                    touchCallback: (pieTouchResponse) {
                                  // ingnore abc
                                  setState(
                                    () {
                                      final desiredTouch =
                                          pieTouchResponse.touchInput
                                                  is! PointerExitEvent &&
                                              pieTouchResponse.touchInput
                                                  is! PointerUpEvent;
                                      if (desiredTouch &&
                                          pieTouchResponse.touchedSection !=
                                              null) {
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      } else {
                                        touchedIndex = -1;
                                      }
                                    },
                                  );
                                }),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                startDegreeOffset: 180,
                                centerSpaceRadius: 40,
                                sections: showingSections(),
                              ),
                            ),

                            // Text("Category wise product's count",style: TextStyle(fontWeight: FontWeight.bold,color: primary),)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shrinkWrap: true,
                        itemCount: colorList.length,
                        itemBuilder: (context, i) {
                          return Indicators(
                            color: colorList[i],
                            text: catList![i] + " " + catCountList![i],
                            textColor:
                                touchedIndex == i ? Colors.black : Colors.grey,
                            isSquare: true,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 28,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      catCountList!.length,
      (i) {
        final isTouched = i == touchedIndex;
        //  final double opacity = isTouched ? 1 : 0.6;

        final double fontSize = isTouched ? 25 : 16;
        final double radius = isTouched ? 60 : 50;

        return PieChartSectionData(
          color: colorList[i],
          value: double.parse(catCountList![i].toString()),
          title: "",
          radius: radius,
          titleStyle:
              TextStyle(fontSize: fontSize, color: const Color(0xffffffff)),
        );
      },
    );
  }

//==============================================================================
//============================ No Internet Widget ==============================

  noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            noIntImage(),
            noIntText(context),
            noIntDec(context),
            AppBtn(
              title: getTranslated(context, "TRY_AGAIN_INT_LBL")!,
              btnAnim: buttonSqueezeanimation,
              btnCntrl: buttonController,
              onBtnSelected: () async {
                _playAnimation();

                Future.delayed(Duration(seconds: 2)).then(
                  (_) async {
                    _isNetworkAvail = await isNetworkAvailable();
                    if (_isNetworkAvail) {
                      getStatics();
                      // getSallerDetail();
                      //      getDeliveryBoy();
                      //  getOrder(); //API Call
                    } else {
                      await buttonController!.reverse();
                      setState(
                        () {},
                      );
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

//==============================================================================
//============================ Refresh Implimentation ==========================

  Future<Null> _refresh() async {
    Completer<Null> completer = new Completer<Null>();
    await Future.delayed(Duration(seconds: 3)).then(
      (onvalue) {
        completer.complete();
        offset = 0;
        total = 0;
        orderList.clear();
        orderList.clear();
        getStatics();
        getMyLeads('');
        getAllUsers();
        print("referecs state");
        // getSallerDetail();

        //   getDeliveryBoy();

        getZipCodes();
        setState(
          () {
            _isLoading = true;
          },
        );
      },
    );
    return completer.future;
  }

//==============================================================================
//============================ First Row Implimentation ========================

  firstHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        getOrderButton(),
        getBalanceButton(),
        getProductsButton(),
      ],
    );
  }

  getOrderButton() {
    return Expanded(
      flex: 3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderList(),
            ),
          );
        },
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "ORDER")!,
                  style: TextStyle(
                    color: grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  totalorderCount ?? "",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getBalanceButton() {
    return Expanded(
      flex: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WalletHistory(), //  WalletHistory(),
            ),
          );
        },
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "BALANCE_LBL")!,
                  style: TextStyle(
                    color: grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  CUR_CURRENCY + " " + CUR_BALANCE,
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getProductsButton() {
    return Expanded(
      flex: 3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductList(
                flag: '',
              ),
            ),
          );
        },
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.wallet_giftcard,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "PRODUCT_LBL")!,
                  style: TextStyle(
                    color: grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  totalproductCount ?? "",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//==============================================================================
//========================= Second Row Implimentation ==========================

  secondHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // getCustomerButton(),
        getRattingButton(),
      ],
    );
  }

  getRattingButton() {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Icon(
                Icons.star_rounded,
                color: primary,
              ),
              Text(
                "Rating",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: grey,
                ),
              ),
              Text(
                RATTING + r" / " + NO_OFF_RATTING,
                style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }

  getCustomerButton() {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Customers(),
            ),
          );
        },
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.group,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "CUSTOMER_LBL")!,
                  style: TextStyle(
                    color: grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  totalcustCount ?? "",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//==============================================================================
//========================= Third Row Implimentation ===========================

  thirdHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        getSoldOutProduct(),
        getRattingButton(),
        getLowStockProduct(),
      ],
    );
  }

  getSoldOutProduct() {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductList(
                  flag: "sold",
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.not_interested,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "Sold Out Products")!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    color: grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  totalsoldOutCount ?? "",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getLowStockProduct() {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductList(
                  flag: "low",
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.offline_bolt,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "Low Stock Products")!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  totallowStockCount ?? "",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }
}
//==============================================================================
//==============================================================================




// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Image.asset(
//           'assets/images/homelogo.png',
//           //height: 40,
//           //   width: 200,
//           height: 120,
//           //s
//           // width: 45,
//         ),
//       ),
//     );
//   }
// }
