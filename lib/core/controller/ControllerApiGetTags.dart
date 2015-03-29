part of server;

class ControllerApiGetTags extends RouteController {
    PersistentProvider store;

    ControllerApiGetTags(this.store): super();

    Future<Map> execute(Map params) {
        print('params:');
        print(params);
        var completer = new Completer();
        store.getTags(params["local"]).then((tags){
            completer.complete({
                "tags": tags
            });
        });
        return completer.future;
    }
}