part of server;

class ControllerApiGetLocals extends RouteController {
    PersistentProvider store;

    ControllerApiGetLocals(this.store): super();

    Future<Map> execute(Map params) {
        var completer = new Completer();
        store.getLocals().then((locals){
            completer.complete({
                "locals": locals
            });
        });
        return completer.future;
    }
}