import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:ignite/apicontrollers/basic_auth_config.dart';

class DepartmentsApiController {
  late String _ip;
  late String _baseUrl;

  DepartmentsApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/ignite/api/department";
  }

//List<Department>
  Future<String> getDepartments() async {
    Map<String, String> header = await BasicAuthConfig().getUserHeader();
    http.Response res =
        await http.get(Uri.parse("$_baseUrl/all"), headers: header);
    return res.body;
  }
}
