part of server;

class JSONResponse extends ResponseHandler {
    JSONResponse(String filename) : super(filename);

    String response(HttpRequest request, Map vars) {
        request.response.headers.contentType = new ContentType("application", "json", charset: "utf-8");
        //request.response.headers.add(HttpHeaders.CONTENT_TYPE, "application/json");
        request.response.write(JSON.encode(vars));
        request.response.close();

    }
}