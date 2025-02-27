import 'package:e_mech/data/firebase_user_repository.dart';
import 'package:e_mech/data/models/transaction.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/provider_services.dart';
import '../../../domain/entities/request_model.dart';
import '../../../domain/entities/seller_model.dart';
import '../../../providers/seller_provider.dart';

class InvoiceScreen extends StatefulWidget {
  final RequestModel requestModel;
  InvoiceScreen({
    Key? key,
    required this.requestModel,
  }) : super(key: key);
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  List<String> services = [];
  String serviceName = '';
  double serviceCharge = 0.0;
  double totalAmount = 0.0;
  SellerModel? seller;
  void addService() {
    if (serviceName.isNotEmpty && serviceCharge > 0) {
      setState(() {
        // services.add(ProvidedServices(serviceName, serviceCharge));
        services.add('$serviceName : $serviceCharge');
        totalAmount += serviceCharge;
        serviceName = '';
        serviceCharge = 0.0;
      });
    }
  }

  // void send() async {
  //   FocusManager.instance.primaryFocus?.unfocus();
  //   utils.toastMessage("please wait....");
  //   TransactionModel transaction = TransactionModel(
  //       services: services,
  //       total: totalAmount,
  //       mechanicId: utils.currentUserUid,
  //       userId: widget.requestModel.senderUid,
  //       date: utils.getCurrentDate(),
  //       time: utils.getCurrentTime());
  //   await FirebaseUserRepository.saveTransactionDataToFirestore(transaction);
  //   utils.toastMessage("invoice sent");
  // }
  void send() async {
    if (mounted) {
      FocusManager.instance.primaryFocus?.unfocus();
      utils.toastMessage("please wait....");
      TransactionModel transaction = TransactionModel(
          services: services,
          total: totalAmount,
          mechanicId: utils.currentUserUid,
          userId: widget.requestModel.senderUid,
          date: utils.getCurrentDate(),
          time: utils.getCurrentTime());
      await FirebaseUserRepository.saveTransactionDataToFirestore(transaction);
      await FirebaseUserRepository.notifyUseronInvoice(
          widget.requestModel.senderDeviceToken!, seller!.name!);
      await FirebaseUserRepository.deleteRequestDocument(
          "AcceptedRequest", widget.requestModel.documentId!, context);

      if (mounted) {
        utils.toastMessage("invoice sent");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (double.parse(widget.requestModel.distance!) <= 5) {
      services.add(
          'Travel Charges : ${double.parse(widget.requestModel.distance!) * 50}');
      totalAmount += double.parse(widget.requestModel.distance!) * 50;
    } else if (double.parse(widget.requestModel.distance!) > 5 &&
        double.parse(widget.requestModel.distance!) <= 15) {
      services.add('Travel Charges : ${500}');
      totalAmount += 500;
    } else if (double.parse(widget.requestModel.distance!) > 15) {
      services.add('Travel Charges : ${1000}');
      totalAmount += 1000;
    }
  }

  @override
  Widget build(BuildContext context) {
    seller = Provider.of<SellerProvider>(context, listen: false).seller;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Styling.primaryColor,
        leading: BackButton(),
        title: Text('Invoice Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Distance Traveled:  ${widget.requestModel.distance!.split(".")[0]} km',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Card(
                //   child: ListTile(
                //     title: Text('Distance'),
                //     trailing: Text('\ ${widget.requestModel.distance} km'),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Services Provided:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(services[index].split(':')[0]),
                        trailing:
                            Text('\ ${services[index].split(':')[1]} pkr'),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.0),
                Text(
                  'Total Amount: \ ${totalAmount.toStringAsFixed(2)} pkr',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                TextField(
                  onChanged: (value) {
                    serviceName = value;
                  },
                  decoration: InputDecoration(labelText: 'Service Name'),
                ),
                SizedBox(height: 20.0),
                TextField(
                  onChanged: (value) {
                    serviceCharge = double.parse(value);
                  },
                  decoration: InputDecoration(labelText: 'Service Charge (\$)'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: addService,
                      child: Text('Add Service'),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: send,
                      child: Text('send'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
