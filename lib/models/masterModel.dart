// ignore_for_file: non_constant_identifier_names, file_names, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:bseccs/models/dialogModel.dart';

class MasterModel {
  // static String URL = 'http://192.168.1.60:3011/api';
  // static String SocketURL = 'http://192.168.1.60:3011';
  // static String BaseUrl = 'http://192.168.1.60:3011';

  static String URL = 'https://adminbs.synergicbanking.in/api';
  static String SocketURL = 'https://adminbs.synergicbanking.in/';
  static String BaseUrl = 'https://adminbs.synergicbanking.in/';

  static Future globalApiCall(int flag, String endUrl, values) async {
    var reqUrl = Uri.parse(URL + endUrl);
    var result;
    dialogModel.showLoading();
    if (flag > 0) {
      result = await http
          .post(reqUrl, body: values)
          .whenComplete(() => dialogModel.dismissLoading())
          .then((value) => value)
          .onError((error, stackTrace) {
        dialogModel.dismissLoading();
        dialogModel.showToast(error.toString());
        var result = {"suc": 0, "msg": error};
        throw result;
      });
    } else if (flag == 0) {
      dialogModel.showLoading();
      result = await http
          .get(Uri.parse(URL + endUrl))
          .whenComplete(() => dialogModel.dismissLoading())
          .then((value) => value)
          .onError((error, stackTrace) {
        dialogModel.dismissLoading();
        dialogModel.showToast(error.toString());
        var result = {"suc": 0, "msg": error};
        throw result;
      });
    }
    return result;
  }

  static String createStar(len) {
    int i;
    String star = '';
    for (i = 0; i < len; i++) {
      star = '$star*';
    }
    return star;
  }

  static int getFinDt() {
    String finStDt = '0104';
    String finEndDt = '3103';

    int curr_year = int.parse(DateFormat('yyyy').format(DateTime.now())) - 1;
    int previous_year =
        int.parse(DateFormat('yyyy').format(DateTime.now())) - 2;
    int next_year = int.parse(DateFormat('yyyy').format(DateTime.now()));
    int currYear = int.parse(DateFormat('yyyy').format(DateTime.now()));
    int nowDt = int.parse(DateFormat('ddMMyyyy').format(DateTime.now()));

    if (nowDt > int.parse('${finEndDt.toString()}${currYear.toString()}')) {
      curr_year += 1;
      previous_year += 1;
      next_year += 1;
    }

    int currFinYear = int.parse(DateFormat('yyyy').format(DateTime.now()));
    int nowYear = int.parse(DateFormat('yyyy').format(DateTime.now()));
    int nextYear = int.parse(DateFormat('yyyy').format(DateTime.now())) + 1;
    // int nowMonth = int.parse();

    if (nowDt > int.parse('${finStDt.toString()}${(nowYear - 1).toString()}') &&
        nowDt < int.parse('${finEndDt.toString()}${nextYear.toString()}')) {
      currFinYear = nowYear;
    } else {
      currFinYear = currFinYear - 1;
    }
    return curr_year;
  }
}
