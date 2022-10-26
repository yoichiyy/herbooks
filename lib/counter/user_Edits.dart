import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../ui/pageview.dart';

class UsersEdits extends StatefulWidget {
  const UsersEdits({Key? key}) : super(key: key);

  @override
  State<UsersEdits> createState() => _UsersEditsState();
}

class _UsersEditsState extends State<UsersEdits> {
  final TextEditingController _textContName = TextEditingController();
  final TextEditingController _textContProf = TextEditingController();
  // String _editTextName = '';
  // String _editTextProf = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PageViewClass(),
                ));
          },
        ),
        centerTitle: true,
        title: const Text('ユーザー登録'),
        actions: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: OutlinedButton(
                child: const Text('保存', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  Map<String, dynamic> insertObj = {
                    'id': user!.uid,
                    'name': _textContName.text,
                    'note': _textContProf.text,
                    'vaild': true,
                    'created_at': FieldValue.serverTimestamp(),
                    'modified_at': FieldValue.serverTimestamp()
                  };
                  try {
                    var doc = FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid);
                    await doc.set(insertObj);

                    //新しいコード andremoveuntilが多分正しい
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PageViewClass(),
                      ),
                    );

                    //元のコード
                    // await Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(builder: (context) {
                    //     return PageView();
                    //   }),
                    // );

                  } catch (e) {
                    debugPrint('-----insert error----');
                    print(e);
                  }
                },
              ))
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomSpace),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.grey))),
                      child: Row(
                        // 名前
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 40.0),
                            child: Text('ユーザーID'),
                          ),
                          Flexible(
                            child: TextField(
                              autofocus: false,
                              controller: _textContName,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              // onChanged: (String? val) {
                              //   if (val != null && val != '') {
                              //     _editTextName = val;
                              //   }
                              // },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.grey))),
                      child: Row(
                        // 自己紹介
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 40.0),
                            child: Text('自己紹介（必須ではない）'),
                          ),
                          Flexible(
                            child: TextField(
                              autofocus: false,
                              controller: _textContProf,
                              maxLines: 2,
                              minLines: 1,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              // onChanged: (String? val) {
                              //   if (val != null && val != '') {
                              //     _editTextProf = val;
                              //   }
                              // },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
