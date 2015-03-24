part of server;

class RouteProvider {
    HttpServer server;
    Map<String, Map> routeControllers = new Map();
    Map cfg;

    RouteProvider(this.server, this.cfg);

    void route(Map routeConfig) {
        String url = routeConfig["url"];
        routeControllers[url] = routeConfig;
    }

    void start() {
        server.listen(this.handleRequest);
    }

    void handleRequest(HttpRequest request) {
        String path = request.uri.path;
        print('incomming request: ' + path);

        // route has a config?
        if (routeControllers.containsKey(path)) {

            //get config of this route
            Map routeConfig = routeControllers[path];

            RouteController controller = routeConfig["controller"];
            ResponseHandler responseHandler = routeConfig["response"];

            //create vars for the template
            Map templateVars = controller.execute();
            responseHandler.response(request, templateVars);

        } else {

            //try to find the file with the default file-response-handler
            if (this.cfg.containsKey('staticContentRoot') &&
                path.startsWith(this.cfg['staticContentRoot']+'/') &&
                !path.contains('..') /*&& path.endsWith('.js')*/) {

                try {
                    FileResponse fr = new FileResponse(path.substring(1));
                    fr.response(request, {});
                } catch (exception) {

                    //404 not found
                    request.response
                        ..statusCode = HttpStatus.NOT_FOUND
                        ..write('Not found')
                        ..close();
                }
            } else {

                //404 not found
                request.response
                    ..statusCode = HttpStatus.NOT_FOUND
                    ..write('Not found')
                    ..close();
            }
        }
    }
}