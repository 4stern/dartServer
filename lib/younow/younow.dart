library younow;

import 'dart:io';
import 'dart:convert';
import 'dart:mirrors';
import 'dart:async';

abstract class Serializable {

    Map toJson() {
        Map map = new Map();
        InstanceMirror im = reflect(this);
        ClassMirror cm = im.type;
        var decls = cm.declarations.values.where((dm) => dm is VariableMirror);
        decls.forEach((dm) {
            var key = MirrorSystem.getName(dm.simpleName);
            var val = im.getField(dm.simpleName).reflectee;
            map[key] = val;
        });

        return map;
    }
}

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

class YounowLocale {
    static String LOCALE_DE = "de"; //german [de]
    static String LOCALE_EN = "en"; //english
    static String LOCALE_ES = "es"; //spanish [es,ca]
    static String LOCALE_ME = "me"; //arabic [ar]
    static String LOCALE_TR = "tr"; //turkish [tr, az, kk]
    static String LOCALE_WW = "ww"; //worldwide
}

class YounowUser extends Object with Serializable {
    int userId;
    String username;
    String profile;
    String locale;
    int likes;
    int viewers;
    double userlevel;
    List tags;
    int broadcastId;

    YounowUser(this.userId, this.username, this.profile, this.locale, this.likes, this.viewers, this.userlevel, this.tags, this.broadcastId);
}

class YounowTag extends Object with Serializable {
    String name;
    double score;
    YounowTag(this.name, this.score);
}

class Younow extends HttpCaller {
/*
    http://www.younow.com/php/api/younow/featured/locale=de/tag=deutsch
    http://cdn2.younow.com/php/api/younow/dashboard
    http://cdn2.younow.com/php/api/younow/config

    //getting broadcasters within a channel - only available within a channel
    http://cdn2.younow.com/php/api/broadcast/playData/channelId=6459715
    {
        onBroadcastPlay:{
            queues:[
                {
                    tag:"deutsch-girl",
                    items:[
                        {
                            broadcastId: "43173330",
                            l: "de",
                            likes: "797",
                            profile: "Prinzessinunicorn",
                            tags: ["deutsch-girl"],
                            userId: "6459715",
                            userlevel: 40,
                            username: "Prinzessinunicorn",
                            viewers: "199",
                        },
                        ...
                    ]
                }
            ]
        }
    }
*/
    String dashboardUrl = "http://cdn2.younow.com/php/api/younow/dashboard";
    String configUrl = "http://cdn2.younow.com/php/api/younow/config";
    String channelUrl = "http://cdn2.younow.com/php/api/broadcast/playData/channelId=";
    String featuresUrl = "http://www.younow.com/php/api/younow/featured/locale=__locale__/tag=__tag__";
    int defaultTrendingCount = 50;
    Map data;

    Younow() {
        this.refreshData();
    }

    void dashboard(int trendingCount, locale, callback){
        String url = this.dashboardUrl;
        if(trendingCount != null){
            url += "/trending="+trendingCount.toString();
        }
        if(locale != null){
            url += "/locale="+locale;
        }
        //print(url);
        this._call(url, (String content) {
            Map data = JSON.decode(content);
            callback(data);
        });
    }

    void refreshData() {
        int trendingCount = 50;
        String locale = null; //YounowLocale.LOCALE_DE;

        this.dashboard(trendingCount,locale,(jsonData){
            this.data = jsonData;
            print("fetched new younow data");
        });
    }

    Map getRowData() {
        return this.data;
    }

    /*List<YounowUser> getUsers(){
        List<YounowUser> users = new List<YounowUser>();
        List rowUsers = this.data["trending_users"];
        rowUsers.forEach((rowUser){
            var user = new YounowUser(
                int.parse(rowUser["userId"]),
                rowUser["username"],
                rowUser["profile"],
                rowUser["locale"],
                int.parse(rowUser["likes"]),
                int.parse(rowUser["viewers"]),
                double.parse(rowUser["userlevel"]),
                rowUser["tags"],
                int.parse(rowUser["broadcastId"])
            );
            users.add(user);
        });
        return users;
    }*/

    /*List<YounowTag> getTags(){
        List<YounowTag> tags = new List<YounowTag>();
        List rowTags = this.data["trending_tags"];
        rowTags.forEach((rowTag){
            var tag = new YounowTag(
                rowTag["tag"],
                double.parse(rowTag["score"])
            );
            tags.add(tag);
        });
        return tags;
    }*/

    Future<int> getChannelId(String locale, String tag){
        var completer = new Completer();
        String url = featuresUrl;
        url = url.replaceAll(new RegExp(r'__locale__'), locale);
        url = url.replaceAll(new RegExp(r'__tag__'), tag);
        //print(url);
        this._call(url, (String content) {
            Map data = JSON.decode(content);
            if(data["userId"] != null){
                completer.complete(int.parse(data["userId"]));
            }
        });
        return completer.future;
    }

    Future<List<YounowUser>> getUsers(int channelId){
        var completer = new Completer();
        this._call(channelUrl+channelId.toString(), (String content) {
            Map data = JSON.decode(content);
            List broadcastingUsers = data["onBroadcastPlay"]["queues"][0]["items"];
            List<YounowUser> users = new List<YounowUser>();
            broadcastingUsers.forEach((broadcastingUser){
                try{
                    var user = new YounowUser(
                        int.parse(broadcastingUser["userId"]),      //
                        broadcastingUser["username"],               //
                        broadcastingUser["profile"],                //
                        broadcastingUser["l"],                      //
                        int.parse(broadcastingUser["likes"]),       //
                        int.parse(broadcastingUser["viewers"]),     //
                        double.parse(broadcastingUser["userlevel"].toString()),//
                        broadcastingUser["tags"],                   //
                        int.parse(broadcastingUser["broadcastId"])  //
                    );
                    users.add(user);
                }catch(e){
                    print(e);
                }
            });
            completer.complete(users);
        });
        return completer.future;
    }

    Future<List<YounowTag>> getTags(String locale){
        var completer = new Completer();
        this.dashboard(defaultTrendingCount,locale,(jsonData){
            List rowTags = jsonData["trending_tags"];
            List<YounowTag> tags = new List<YounowTag>();
            rowTags.forEach((rowTag){
                var tag = new YounowTag(
                    rowTag["tag"],
                    double.parse(rowTag["score"])
                );
                tags.add(tag);
            });
            completer.complete(tags);
        });
        return completer.future;
    }



    Future<List<String>> getLocals(){
        var completer = new Completer();
        this._call(configUrl, (String content) {
            Map data = JSON.decode(content);
            if(data.containsKey("Locales")){
                List<String> locals = new List<String>();
                data["Locales"].forEach((k,v){
                    locals.add(k);
                });
                completer.complete(locals);
            }
        });
        return completer.future;
    }

}