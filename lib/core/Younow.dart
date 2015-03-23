part of server;

class HttpCaller {
  void _call(url, callback) {
    HttpClient client = new HttpClient();
    String jsonContent = "";
    client.getUrl(Uri.parse(url))
    .then((HttpClientRequest request) => request.close())
    .then((HttpClientResponse response) {
      response.transform(UTF8.decoder).listen((contents) {
        jsonContent += contents.toString();
      }, onDone:() => callback(jsonContent));
    });
  }
}

class Younow extends HttpCaller{
  String dashboardUrl = "http://cdn2.younow.com/php/api/younow/dashboard/trending=200";
  Map data;

  Younow() {
    this.refreshData();
  }

  void refreshData(){
    this._call(this.dashboardUrl,(String content){
      Map data = JSON.decode(content);
      this.data = data;
      print("fetched new younow data");
    });
  }

  Map getData() {
    return this.data;
  }

}