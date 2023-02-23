function up_to_firestore_events() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheet1 = ss.getSheetByName('event');

  //《タイトル行取得部分》
  var firstRange = sheet1.getRange(2, 5, 1,10);//ヘッダー取得。5から13までを、jsonArrayにしたい。14は済だけど、if分岐のために仕方なく取り込む。つまり10つ右の列まで取得とする。
  var firstRowValues = firstRange.getValues();//この段階では、まだ値が、[[]]入れ子になっている。→それがどう問題なのかは、不明。行けるか試してみたい。
  var titleColumns = firstRowValues[0];//ここで１行目のarrayを取得できた
  // Logger.log("●タイトル")
  // Logger.log(titleColumns)
  // Logger.log(titleColumns)

  //回答データ取得、「済」による分岐
  var sheetData = sheet1.getSheetValues(3, 5, sheet1.getLastRow(), 10);//5から13までを、jsonArrayにしたい。14もやむなし。
  // Logger.log(sheetData);

  //ループ開始 
  sheetData.forEach(function(value, index) {
    // 済による分岐
    if (value[0] !="" && value[9] !="済") {
      Logger.log("●value")
      Logger.log(value)
      Logger.log(index)
      sheet1.getRange(3+index, 14).setValue("済");//3は開始行。１４行目と一致

      //その行データをrowValuesに入れる
      var rowValues = sheetData[index];
      // Logger.log("●rowValues")
      // Logger.log(rowValues);
      
      //いよいよJSON作成
      var jsonArray = [];
      var json = new Object();
      for(var j=0; j<titleColumns.length; j++) {//次にタイトルの列数（フィールド個数）。縦（列）で、ループ回す。
          json[titleColumns[j]] = rowValues[j];//元line[j]だったものを、rowValuesに変更。//一列ずつ、生徒の回答を【タイトル１：回答１】、【タイトル２：回答２】と結合さして
        }
        jsonArray.push(json);//それを、一つずつPUSH。
        Logger.log("●jsonArray")
        Logger.log(jsonArray)
      // }

      // CloudFirestoreの認証
      var firestore = firestoreData();
          
      //コレクションとドキュメント名を指定
      // var collection_name = value[1]
      var document_name = value[1]+value[2]+value[5] //キャンパス名+生徒番号+クラスを、ドキュメント名とする
        // Logger.log("●コレクション")
        // Logger.log(collection_name)
        // Logger.log("●ドキュメント")
        // Logger.log(document_name)

      // var token = collection_name+"/"+document_name
      //   Logger.log("●token")
      //   Logger.log(token)

      //update部分：コレクションとドキュメント名も、IFでくくる予定。

      try{
          firestore.createDocument("nikka/"+document_name, jsonArray);
      }catch(e){
          Logger.log("エラー：" + e.message)
          firestore.updateDocument("nikka/"+document_name, jsonArray);
      }




      Logger.log("■おわり■")

        }
      });

}


function firestoreData() {
  var dataArray = {
    "client_email": "firebase-adminsdk-tjisc@nikka-5ff58.iam.gserviceaccount.com", //もとは"email"だった
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCY40pqBBFpmIEz\nc0zvZptpgH90XKMUu+SS8tJgot6Ra5R7ss+7M4GvUHioRUtig/k5dz3dBXKVo4cn\nL/i4+uBGla0qgm0KvCrlPtOuaq1U1995mBJoUUCScEQkCvfTMqxad3EyWO8k/q7X\nAu8sszwuQRZhHDbXIcWdu8OJJR2ygtCT2gjGCkpM1oBxI3FXz2Kw36lbFT03Bba/\nXvWcN0EhJxosMvDtRU/3QiCuIzflBn+ZPsJD05JZF/BWigZ0R5NgZeemOt/hsyAO\nqI8qTCvAEqVzWSaH7lBNqcwCg43MsWXsD5Np06BkAqTNJWS9dnr909chz5wp4QVx\nqMAuNiurAgMBAAECggEAFzUJKqaLbhf0JLcvyncsyAr1Tdhx+Me8noG1ZW3Tkwdd\ndplh5uyeltoENqauFroprotnHJGjHwu/jDc/7fRG7u/xZS5/Fs4RRNMQlr0iqmpK\nRc7LnIIY5yGbdk0j6S8b8m+HAzl0s4zlRUXwwDxEulCu8PazbFx3/sVtnPfBVkNA\n1dRtrPDQYCgxuYoO/Dqnq9SKsGY5uzs7AoCNAjIg19Z9QVM8P1BqN/8z6BCXjhxX\nPdZACzSOo+WckwLetZTf2wsvfLw7QLLIJYH1W+BP91YZEgR6K4BgtWMoaKlc59hC\nj5zUkz0j0qmDIqFOLWQIT/NmCoYYqfbRjWxHUMIjgQKBgQDXiiYHOlV0Z4ZERIb8\n1TuaNPLEJ355ntUCvhjzmLfZo+MdKX3OsobsTdYNdC4moaGrHKA59BGO4i0Agcrx\nbT2b8So8SzSeiMoJ3IWA3nbC/Pv6FssCPccY8LikUyHbPNFw25LVgHz+dFAE/QFz\ndOMWPHj5acy3oTF0MHdNDKX2UQKBgQC1lmIVEXVKZLuMUPPvxIQ+EzwXNC7Y97B9\ntqgeJbHDqzEff6iI/wYy3CH21cnYKuXgRK/hUCd10FyrDePJJxAAs2ahlCkmj2nw\nnfV8FLhisqsxysJTOotd6xlbQqLrCto74xvFoT1VqpgFTbXH7+RBwfrhEPGe2F77\nRZJ/qZs3OwKBgG+kdRIlWwISZW+S90CaymaTqnOD6XThmn/zK0VyAzjONON0DGA2\nBMD9iDQry4PjELRq/WtHSpjx+lFa6V2oMdNGVZQpeDXtsIjvGo+nq2hQVcwyZjDh\nAvGeLmWfUdgXZnzInwPLq/K5GIGc81V0Y/OumxLFhG5RJiaCvCjCtmwhAoGAGs9V\nM98b/hvZROI+4cuV6sRUPujJcec/+4+YSrst/8GqwwfKDk/4zlGKAjOWVYAf6Hi7\nrvxylwZoaCjo1K4bwr66DGkfmj3aWlg4AlXc01WlyPgysK8YHIm1eK/h9enoRqdF\nVmxz7c3+G+pZSGe2v66wJ8KkqdswStD+zDJyZDkCgYEAguLy6nP3Si8Ws1gn8jNF\nhj+YcTKDUQYmMkdE4pdSrmRT4aO+HiMFWwOGz1PjO1EWwW/PrBZc+N0/jzTS3uni\n0ebilI+bFlVKxyrrrVshTmaKINTJ3xr5njq/eONDAwiyruDcYwarUUXKGQFFzz7E\nFGeMI24+18yRd/0pVJ4CIDY=\n-----END PRIVATE KEY-----\n",
    "project_id": "nikka-5ff58",
  }

  var firestore = FirestoreApp.getFirestore(dataArray.client_email, dataArray.private_key, dataArray.project_id);
  return firestore;
}


//   // // CloudFirestoreからデータを読み込む方法
//   // const doc = firestore.getDocument("data/WKRsIKXKdRs6Stf5bnWf");
//   // console.log(doc);
//   // console.log(`データベースの読み込み時間：${doc.read}`);
//   // console.log(`データベースの更新時間：${doc.updated}`);
//   // console.log(`データベースの作成時間：${doc.created}`);
//   // console.log(`Fullドキュメントパス：${doc.name}`);
//   // console.log(`Localドキュメントパス：${doc.path}`);




function copy_sum_1nensei() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheet1 = ss.getSheetByName('1nensei');

  //《タイトル行取得部分》
  var firstRange = sheet1.getRange(2, 5, 1,10);//ヘッダー取得。5から13までを、jsonArrayにしたい。14は済だけど、if分岐のために仕方なく取り込む。つまり10つ右の列まで取得とする。
  var firstRowValues = firstRange.getValues();//この段階では、まだ値が、[[]]入れ子になっている。→それがどう問題なのかは、不明。行けるか試してみたい。
  var titleColumns = firstRowValues[0];//ここで１行目のarrayを取得できた
  // Logger.log("●タイトル")
  // Logger.log(titleColumns)
  // Logger.log(titleColumns)

  //回答データ取得、「済」による分岐
  var sheetData = sheet1.getSheetValues(3, 5, sheet1.getLastRow(), 10);//5から10までを、jsonArrayにしたい。11もやむなし。
  // Logger.log(sheetData);

  //ループ開始 
  sheetData.forEach(function(value, index) {
    // 済による分岐
    if (value[0] !="" && value[9] !="済") {
      Logger.log("●value")
      Logger.log(value)
      Logger.log(index)
      //処理中の、一つ↑の行から、COL【済の２つ前と１つ前】をコピーするだけ
      sheet1.getRange(2+index,11,1,3).copyTo(sheet1.getRange(3+index,11,1,3));
        }
      });
}




 //menu//
 function onOpen() {
  var ui = SpreadsheetApp.getUi();           // Uiクラスを取得する
  var menu = ui.createMenu('更新♥');  // Uiクラスからメニューを作成する
  menu.addItem('更新', 'up_to_firestore_1nensei');   // メニューにアイテムを追加する
  menu.addToUi();            
  }












