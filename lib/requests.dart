import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'tree.dart';

final http.Client client = http.Client();
// better than http.get() if multiple requests to the same server

// If you connect the Android emulator to the webserver listening to localhost:8080
// const String baseUrl = "http://10.0.2.2:8080";
const String baseUrl = "http://localhost:8080";

// If instead you want to use a real phone, you need ngrok to redirect
// localhost:8080 to some temporal Url that ngrok.com provides for free: run
// "ngrok http 8080" and replace the address in the sentence below
// const String baseUrl =
//     "https://d86d-158-109-94-83.eu.ngrok.io"; // change url when needed
// Uri uri = Uri(
//   scheme: "https",
//   host: "9db0-79-157-94-181.eu.ngrok.io",
// );
// in linux I've installed ngrok with "sudo npm install ngrok -g". On linux, windows,
// mac download it from https://ngrok.com/. More on this here
// https://medium.com/@vnbnews.vn/how-can-i-access-my-localhost-from-my-real-android-ios-device-d037fd192cdd

Future<Tree> getTree(int id) async {
  String uriString = "$baseUrl/get_tree?$id";
  Uri uri = Uri.parse(uriString);
  final response = await client.get(uri);
  // response is NOT a Future because of await but since getTree() is async,
  // execution continues (leaves this function) until response is available,
  // and then we come back here
  if (response.statusCode == 200) {
    print("statusCode=$response.statusCode");
    print(response.body);
    // If the server did return a 200 OK response, then parse the JSON.
    Map<String, dynamic> decoded = convert.jsonDecode(response.body);
    return Tree(decoded);
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    print("statusCode=$response.statusCode");
    throw Exception('Failed to get children');
  }
}

Future<void> start(int id) async {
  String uriString = "$baseUrl/start?$id";
  Uri uri = Uri.parse(uriString);
  final response = await client.get(uri);
  if (response.statusCode == 200) {
    print("statusCode=$response.statusCode");
  } else {
    print("statusCode=$response.statusCode");
    throw Exception('Failed to get children');
  }
}

Future<void> stop(int id) async {
  String uriString = "$baseUrl/stop?$id";
  Uri uri = Uri.parse(uriString);
  final response = await client.get(uri);
  if (response.statusCode == 200) {
    print("statusCode=$response.statusCode");
  } else {
    print("statusCode=$response.statusCode");
    throw Exception('Failed to get children');
  }
}

Future<void> createProject(int id, String name) async {
  //, List<String> tag) async {
  String uriString = "$baseUrl/create_project?$id&$name";
  Uri uri = Uri.parse(uriString);
  final response = await client.get(uri);
  if (response.statusCode == 200) {
    print("statusCode=$response.statusCode");
  } else {
    print("statusCode=$response.statusCode");
    throw Exception('Failed to get children');
  }
}

Future<void> createTask(int id, String name) async {
  //, List<String> tag) async {
  String uriString = "$baseUrl/create_task?$id&$name"; //&$tag";
  Uri uri = Uri.parse(uriString);
  final response = await client.get(uri);
  if (response.statusCode == 200) {
    print("statusCode=$response.statusCode");
  } else {
    print("statusCode=$response.statusCode");
    throw Exception('Failed to get children');
  }
}
