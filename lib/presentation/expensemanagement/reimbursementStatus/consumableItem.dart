import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/domain/GetConsumablesReimbItem_Model.dart';
import 'package:untitled/presentation/expensemanagement/reimbursementStatus/reimbursementstatus.dart';
import '../../../data/consumableItemRepo.dart';
import '../../resources/app_text_style.dart';

class ConsumableItemPage extends StatefulWidget {

  String sTranCode;

  ConsumableItemPage({super.key, required this.sTranCode});

  @override
  State<ConsumableItemPage> createState() => _ConsumableItemPageState();
}

class _ConsumableItemPageState extends State<ConsumableItemPage> {

  late Future<List<GetConsumableSreimbitemModel>> consumableItem;

  // get a api
  hrmsReimbursementStatus(String stranCode) async {
    consumableItem = ConsumableItemRepo().consumableList(context, stranCode);
    print(" -----xxxxx-  reimbursementStatusList--98-----> $consumableItem");
    // setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var stranCode = '${widget.sTranCode}';
    hrmsReimbursementStatus(stranCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar
      appBar: AppBar(
        // statusBarColore
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color  // 2a697b
          statusBarColor: Color(0xFF2a697b),
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark,
          // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // backgroundColor: Colors.blu
        backgroundColor: Color(0xFF0098a6),
        leading: InkWell(
          onTap: () {
             Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => const Reimbursementstatus()),
            // );
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Consumable Item',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ), // Removes shadow under the AppBar
      ),
      body: Column(children: [
        FutureBuilder<List<GetConsumableSreimbitemModel>>(
            future: consumableItem,
            builder: (context, snapshot) {
              // Check if the snapshot has data and is not null
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while waiting for data
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle error scenario
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Handle the case where the data is empty or null
                return Center(child: Text('No Data'));
              }
              // Once data is available, build the ListView
              final consumableItem = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                // Makes ListView take up only the needed height
                physics: NeverScrollableScrollPhysics(),
                // Disable ListView scrolling if the outer widget scrolls
                itemCount: consumableItem.length,
                itemBuilder: (context, index) {
                  final item = consumableItem[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 10.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 25,
                              width: 25,
                              child: Image.asset(
                                'assets/images/aadhar.jpeg',
                                fit: BoxFit.fill,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Icon(Icons.error, size: 25);
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.sItemName,
                                    style: AppTextStyle
                                        .font14OpenSansRegularBlack45TextStyle),
                                Text('Item Description',
                                    style: AppTextStyle
                                        .font14OpenSansRegularBlack45TextStyle),
                              ],
                            ),
                            Spacer(),
                            Text('Quantity: ${item.fQty}',
                                style: AppTextStyle
                                    .font14OpenSansRegularBlack45TextStyle),
                          ],
                        ),
                        Divider(),
                        Container(
                          height: 45,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 14,
                                          width: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(7),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(item.sUoM,
                                            style: AppTextStyle.font14OpenSansRegularBlackTextStyle),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text('UOM',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                color: Color(0xFF0098a6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  item.fAmount,
                                  style: AppTextStyle
                                      .font14OpenSansRegularWhiteTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
      ]),
    );
  }
}
