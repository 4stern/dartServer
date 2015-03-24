part of server;

class FileResponse extends ResponseHandler{
  String contentType = "text/plain";
  FileResponse(String filename) : super(filename);

  String response(HttpRequest request, Map vars){
    var file = new File(this.filename);
    Future<String> finishedReading = file.readAsString(encoding: UTF8);
    finishedReading.then((template){
        String ct = this.contentType;
        if (this.filename.endsWith('.js')) {
          ct = "application/javascript";
        }

        request.response.headers.add(HttpHeaders.CONTENT_TYPE, ct );
        request.response.write(template);
        request.response.close();
    });
  }
}