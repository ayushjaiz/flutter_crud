import 'package:first_project/view/create_book_page.dart';
import 'package:first_project/controllers/database.dart';
import 'package:first_project/utils/uiHelper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController bookController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController borrowerController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  Stream? _bookStream;

  void _getBookDetailsOnLoad() async {
    _bookStream = await DatabaseMethods().getBookDetails();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getBookDetailsOnLoad();
  }

  @override
  void dispose() {
    bookController.dispose();
    authorController.dispose();
    borrowerController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Widget _buildBookDetailsList() {
    return StreamBuilder(
      stream: _bookStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];

              return Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Book: ${ds["Book"]}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Author: ${ds["Author"]}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                bookController.text = ds["Book"];
                                authorController.text = ds["Author"];
                                borrowerController.text = ds["Borrower"];
                                dateController.text = ds["Date"];
                                EditBookDetail(ds["Id"]);
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            IconButton(
                              onPressed: () async {
                                DatabaseMethods().deleteBookDetail(ds["Id"]);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        Text(
                          "Borrower: ${ds["Borrower"]}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Date: ${ds["Date"]}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<void> _updateBookDetails(id) async {
    Map<String, dynamic> updateInfo = {
      "Book": bookController.text.toString(),
      "Id": id,
      "Author": authorController.text.toString(),
      "Borrower": borrowerController.text.toString(),
      "Date": dateController.text.toString(),
    };
    await DatabaseMethods()
        .updateBookDetail(id, updateInfo)
        .then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Book()),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Library Management',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Expanded(child: _buildBookDetailsList()),
          ],
        ),
      ),
    );
  }

  Future EditBookDetail(String id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            child: ListView(
              shrinkWrap: true,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel),
                ),
                SizedBox(
                  width: 60,
                ),
                Text(
                  'Edit',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  'Details',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  // Set the top margin as needed
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        child: Text(
                          "Book",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: UiHelper.CustomTextField(
                            bookController, "Book Name", Icons.book, false),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  // Set the top margin as needed
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        child: Text(
                          "Author",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: UiHelper.CustomTextField(
                            authorController, "Author Name", Icons.book, false),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  // Set the top margin as needed
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        child: Text(
                          "Borrower",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: UiHelper.CustomTextField(borrowerController,
                            "Borrower Name", Icons.person, false),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  // Set the top margin as needed
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        child: Text(
                          "Issued on",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: UiHelper.CustomTextField(dateController,
                            "Enter Date", Icons.calendar_month, false),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: UiHelper.CustomButton(() {_updateBookDetails(id); }, 'Update')
                )
              ],
            ),
          ),
        ),
      );
}
