library store;

import 'package:sqljocky/sqljocky.dart';
import '../younow/younow.dart';
import 'dart:async';

/**
 * Übernimmt Aufgaben zum Persistieren von Younow-Daten
 */
class PersistentProvider {

    ConnectionPool connectionPool;

    PersistentProvider(String host, int port, String user, String password, String db ){
        this.connectionPool = new ConnectionPool(
            host: host,
            port: port,
            user: user,
            password: password,
            db: db,
            max: 5
        );
    }

    void appendUsers(String tag, List<YounowUser> users){
        DateTime now = new DateTime.now();
        this.connectionPool.prepare('insert into user (`id`,`name`,`profile`,`locale`,`likes`,`viewers`,`level`,`time`,`tag`) values (?, ?, ?, ?, ?, ?, ?, ?, ?)').then((query) {
            users.forEach((user){
                query.execute([user.userId, user.username, user.profile, user.locale, user.likes, user.viewers, user.userlevel, now, tag]).then((result) {
                    //nothing more to do here
                });
            });
        });
    }

    void appendTags(String locale, List<YounowTag> tags){
        DateTime now = new DateTime.now();
        this.connectionPool.prepare('insert into tag (`name`,`score`,`time`,`locale`) values (?, ?, ?, ?)').then((query) {
            tags.forEach((tag){
                query.execute([tag.name, tag.score, now, locale]).then((result) {
                    //nothing more to do here
                });
            });
        });
    }

    Future<List<String>> getLocals(){
        var completer = new Completer();
        this.connectionPool.query('SELECT * FROM locales').then((result) {
            List<String> locals = new List<String>();
            result.forEach((row) {
                locals.add(row.name);
            }).then((e){
                completer.complete(locals);
            });
        });
        return completer.future;
    }

    Future<List<YounowTag>> getTags(String local){
        var completer = new Completer();
        this.connectionPool.query('SELECT DISTINCT * FROM younowmonitor.tag WHERE locale="'+local+'" GROUP BY name ORDER BY score DESC, time ASC').then((result) {
            List<YounowTag> tags = new List<YounowTag>();
            result.forEach((row) {
                YounowTag tag = new YounowTag(row.name, row.score);
                tags.add(tag);
            }).then((e){
                completer.complete(tags);
            });
        });
        return completer.future;
    }

    Future<List<YounowUser>> getUsers(String locale, String tag){
        var completer = new Completer();
        this.connectionPool.query('SELECT * FROM user WHERE locale="'+locale+'" AND tag="'+tag+'" ORDER BY viewers DESC').then((result) {
            List<YounowUser> users = new List<YounowUser>();
            result.forEach((dbuser) {
                var user = new YounowUser(
                    dbuser[0],
                    dbuser[1],
                    dbuser[2],
                    dbuser[3],
                    dbuser[4],
                    dbuser[5],
                    dbuser[6],
                    [dbuser[8]],
                    0
                );
                users.add(user);
            }).then((e){
                completer.complete(users);
            });
        });
        return completer.future;
    }
}