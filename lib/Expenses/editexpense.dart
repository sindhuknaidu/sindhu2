import 'package:final_hri_system/Expenses/jsondecodeexpenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../Api.dart';
import '../main.dart';
import 'expencedashboard.dart';


class getdata {
  String category_id;
  String date;
  String merchant;
  String reference;
  String description;
  String currencytype;
  String amount;
  String tax;

  getdata({
    @required this.category_id,
    @required this.date,
    @required this.merchant,
    @required this.reference,
    @required this.description,
    @required this.currencytype,
    @required this.amount,
    @required this.tax,

  });
}

class editexpense extends StatefulWidget {
editexpense(this.history);
final History history;

  @override
  _editexpenseState createState() => _editexpenseState();
}

class _editexpenseState extends State<editexpense> {
  _editexpenseState();
  bool iseditexpense = false;
  String date="Click and select date";
  String ctype = "SGD";
  String doller = "1";
  String _category;
  List Category_id = [
    'Allowance',
    'Dental Claim',
    'Fuel Expense',
    'Home base-Taxi/Car RENTAL',
    'Home base -mileage',
    'IT and Internet Expense',
    'Meals and Entertainment',
    'Medical Claim',
    'Office Supplies',
    'Other Expense',
    'Transport Claims',
    'Travel-Airline',
    'Travel-Overseas Allowance',
    'Travel Claim',
  ];
  String currencychoose;
  List listcurrency = [
    'SGD', 'CNY', 'MYR', 'THB', 'TWD', 'USD', 'VND', 'EUR', 'HKD', 'IDR', 'JPY',
  ];

  String taxchoose;
  List listTax = [
    'GST 0% (0%)',
    'GST 7% (7%)',
    'Service Charge 10% (10%)  ',
  ];

  String Report;
  List report = [
    "PO-0049-Dominic's",
    "PO-0048-April Japan Trip Project",
    "PO-0045-Project A March 2021",
    "PO-0044-Local Transport-SG",
    "PO-0037-Nov2020 Claims",
  ];

  final claimsController =  TextEditingController();
  final currencyController =  TextEditingController();
  final taxController =  TextEditingController();
  final reporttypeController =  TextEditingController();
  final merchantController =  TextEditingController();
  final referenceController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectdateController = DateTime.now();
  String SelectDate;


  Future DatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectdateController,
      firstDate: new DateTime(DateTime.now().year - 50),
      lastDate: new DateTime(DateTime.now().year + 50),
    );
    if (picked != null && picked != selectdateController ) {
      setState(() {
        selectdateController = picked;
        print(selectdateController);
        SelectDate = DateFormat.yMMMd().format(selectdateController).toString();
      });
    }
  }
  @override
  void initState() {
    var id = widget.history.id;
    claimsController.text = widget.history.categoryId;

    currencyController.text = widget.history.currencyId;
    merchantController.text = widget.history.merchant;
    referenceController.text = widget.history.reference;
    descriptionController.text = widget.history.description;
    amountController.text = widget.history.amount;
    super.initState();
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery
            .of(context)
            .size
            .height * 0.1,
        backgroundColor: Colors.lightBlue[300],
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              FlutterSession().set('token','null');
              Fluttertoast.showToast(
                  msg: "Logout Successful",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,

                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0
              );
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
        title: Text('Edit Expense', style: TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Container(
          color:Colors.grey[200],
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.only(top:20.0,left: 10,right: 10),
            padding: EdgeInsets.all(8.0),
            color:Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category', style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],)),
                      SizedBox(height: 8.0),
                      Container(
                        margin: EdgeInsets.only(left: 40.0),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButton(
                              hint: Text('Select Category'),
                              icon: Icon(
                                Icons.arrow_drop_down, color: Colors.blue,),
                              iconSize: 30,
                              value: _category,
                              onChanged: (newValue) {
                                setState(() {
                                  _category = newValue;
                                  claimsController.text=_category;
                                });
                              },
                              items: Category_id.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: Text(valueItem),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date', style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],)),
                      SizedBox(height: 6.0),
                      Container(
                        margin: EdgeInsets.only(left: 40.0),
                        child: Container(
                          width: 265,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: ListTile(
                            title: Text( "${DateFormat.yMMMMd().format(selectdateController).toString()}",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.grey[600]),),
                            trailing: Icon(Icons.arrow_drop_down,color: Colors.blueAccent,size:30),
                            onTap: () async{
                              await DatePicker(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Merchant', style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],)),
                      SizedBox(height: 6.0),
                      Container(
                        margin: EdgeInsets.only(left: 40.0),
                        child: Container(
                          width: 260,
                          height: 50,
                          child: TextField(
                            controller: merchantController,
                            decoration: InputDecoration(
                              hintText: "Enter merchant",
                              border: OutlineInputBorder(
                              ),
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reference No.', style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],)),
                      SizedBox(height: 6.0),
                      Container(
                        margin: EdgeInsets.only(left: 40.0),
                        child: Container(
                          width: 260,
                          height: 50,
                          child: TextField(
                            controller: referenceController,
                            decoration: InputDecoration(
                              hintText: "Enter reference no.",
                              border: OutlineInputBorder(
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description', style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],)),
                      SizedBox(height: 6.0),
                      Padding(
                        padding: const EdgeInsets.only(left:40.0,right: 40,),
                        child: TextField(
                          controller: descriptionController,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                            ),
                            hintText: 'Enter Description..',
                          ),
                          maxLines: 3,
                          keyboardType: TextInputType.name,
                          //textDirection: TextDirection.ltr,
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount', style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],)),
                      SizedBox(height: 6.0),
                      Container(
                        margin: EdgeInsets.only(left: 40.0),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              padding: EdgeInsets.only(left: 6.0, right: 6.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[500]),
                                  borderRadius: BorderRadius.circular(2.0)),
                              child: DropdownButton(
                                hint: Text('SGD', style: TextStyle(
                                    fontSize: 16, color: Colors.black)),
                                icon: Icon(
                                  Icons.arrow_drop_down, color: Colors.blue,),
                                iconSize: 30,
                                value: currencychoose,
                                onChanged: (newValue) {
                                  setState(() {
                                    currencychoose = newValue;
                                    currencyController.text= currencychoose;

                                    if(newValue == 'SGD'){
                                      ctype = "SGD";
                                      doller = "1";
                                    }
                                    if(newValue == 'IDR'){
                                      ctype = "IDR";
                                      doller = "0.000093";
                                    }
                                    if(newValue == 'MYR'){
                                      ctype = "MYR";
                                      doller = "0.324200";
                                    }
                                    if(newValue == 'HKD'){
                                      ctype = "HKD";
                                      doller = "0.173800";
                                    }
                                    if(newValue == 'VND'){
                                      ctype = "VND";
                                      doller = "0.000059";
                                    }
                                    if(newValue == 'THB'){
                                      ctype = "THB";
                                      doller = "0.041963";
                                    }
                                    if(newValue == 'TWD'){
                                      ctype = "TWD";
                                      doller = "0.048274";
                                    }
                                    if(newValue == 'USD'){
                                      ctype = "USD";
                                      doller = "1.350000";
                                    }
                                    if(newValue == 'JPY'){
                                      ctype = "JPY";
                                      doller = "0.012098";
                                    }
                                    if(newValue == 'CNY'){
                                      ctype = "CNY";
                                      doller = "0.208400";
                                    }
                                    if(newValue == 'EUR'){
                                      ctype = "EUR";
                                      doller = "1.598700";
                                    }
                                  });
                                },
                                items: listcurrency.map((valueItem) {
                                  return DropdownMenuItem(
                                    value: valueItem,
                                    child: Text(valueItem),
                                  );
                                }).toList(),
                              ),
                            ),
                            Container(
                              width: 180,
                              height: 50,
                              child: TextField(
                                controller: amountController,
                                textAlign: TextAlign.end,
                                decoration: InputDecoration(
                                  hintText: "Enter Amount",
                                  border: OutlineInputBorder(
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Exchange Rate', style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],)),
                      SizedBox(height: 6.0),
                      Container(
                        width: 260,
                        height: 50,
                        margin: EdgeInsets.only(left: 40.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 48,
                              color: Colors.grey[100],
                              child: Center(
                                child: Text('1 ${ctype} =',style:TextStyle(fontSize:16.0,color:Colors.black,)),
                              ),
                            ),
                            Container(
                              width: 140,
                              height: 48,
                              color: Colors.grey[300],
                              child: Center(
                                child: Text('${doller}',style:TextStyle(fontSize:16.0,color:Colors.black,)),
                              ),
                            ),
                            Container(
                              width: 47,
                              height: 48,
                              color: Colors.grey[100],
                              child: Center(
                                child: Text('SGD'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tax', style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],)),
                      SizedBox(height: 6.0),
                      Container(
                        margin: EdgeInsets.only(left: 40.0),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButton(
                              hint: Text('Please select the Tax'),
                              icon: Icon(
                                Icons.arrow_drop_down, color: Colors.blue,),
                              iconSize: 30,
                              value: taxchoose,
                              onChanged: (newValue) {
                                setState(() {
                                  taxchoose = newValue;
                                  taxController.text=taxchoose;
                                });
                              },
                              items: listTax.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: Text(valueItem),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Report', style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],)),
                      SizedBox(height: 6.0),
                      Container(
                        margin: EdgeInsets.only(left: 40.0),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 3.0, right: 3.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButton(
                              hint: Text('Please select the report'),
                              icon: Icon(
                                Icons.arrow_drop_down, color: Colors.blue,),
                              iconSize: 30,
                              value: Report,
                              onChanged: (newValue) {
                                setState(() {
                                  Report = newValue;
                                  reporttypeController.text=Report;
                                });
                              },
                              items: report.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: Text(valueItem),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Attachment', style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],))),
                      SizedBox(height: 6.0),

                      Container(
                        margin:EdgeInsets.only(left: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Click and select files-->',style: TextStyle(fontSize: 16.0,color:Colors.red),),

                          ],
                        ),
                      ),

                      SizedBox(height:5.0),
                      FlatButton(
                        color: Colors.lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                          child:Text('Save',style: TextStyle(fontSize: 18.0,color:Colors.white),),

                          onPressed: () async {
                            var claims = claimsController.text;
                            var amount = amountController.text;
                            var selectdate = selectdateController.toString();
                            Future edit = editdata(widget.history.id.toString());
                     setState(() {
                       edit =  updateexpense(widget.history.id.toString(),claims,amount,selectdate);

                     });


                          Fluttertoast.showToast(
                                  msg: "saved",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.green,
                                  fontSize: 16.0
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) => expanse()));

                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}