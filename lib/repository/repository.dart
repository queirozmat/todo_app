import '../others/const.dart';

class Repository {
  Uri getUriAPI(String endpoint,
      {Map<String, dynamic>? queryParams, String prefix = ''}) {
    String url = Const.baseUrl + endpoint;

    if (queryParams != null) {
      return Uri.parse(url).replace(queryParameters: queryParams);
    }

    return Uri.parse(url);
  }

  Map<String, String> getHeaderDefault() {
    Map<String, String> result = {'Content-Type': 'application/json'};

    return result;
  }
}
