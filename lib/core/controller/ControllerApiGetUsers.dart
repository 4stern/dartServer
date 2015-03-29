part of server;

class ControllerApiGetUsers extends RouteController {
    PersistentProvider store;

    ControllerApiGetUsers(this.store): super();

    Future<Map> execute(Map params) {
        var completer = new Completer();
        store.getUsers(params["local"],params["tag"]).then((users){
            completer.complete({
                "users": users
            });
        });
        return completer.future;
    }
}