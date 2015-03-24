part of server;

class JadeResponse extends ResponseHandler {
    JadeResponse(String filename) : super(filename);

    String response(HttpRequest request, Map vars) {
        var file = new File(this.filename);
        Future<String> finishedReading = file.readAsString(encoding: UTF8);
        finishedReading.then((template) {
            var compileTemplate = jade.compile(template);
            compileTemplate(vars).then((htmlTemplate) {
                request.response.headers.add(HttpHeaders.CONTENT_TYPE, "text/html");
                request.response.write(htmlTemplate);
                request.response.close();
            });
        });
    }
}