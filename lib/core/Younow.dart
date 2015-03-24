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

class YounowLocale {
    static String LOCALE_DE = "de"; //german [de]
    static String LOCALE_EN = "en"; //english
    static String LOCALE_ES = "es"; //spanish [es,ca]
    static String LOCALE_ME = "me"; //arabic [ar]
    static String LOCALE_TR = "tr"; //turkish [tr, az, kk]
    static String LOCALE_WW = "ww"; //worldwide
}

class Younow extends HttpCaller {
/*
    http://www.younow.com/php/api/younow/featured/locale=de/tag=deutsch
    http://cdn2.younow.com/php/api/younow/dashboard
*/
    String dashboardUrl = "http://cdn2.younow.com/php/api/younow/dashboard";
    Map data;

    Younow() {
        this.refreshData();
    }

    void dashboard(trendingCount, locale, callback){
        String url = this.dashboardUrl;
        if(trendingCount != null){
            url += "/trending="+trendingCount;
        }
        if(locale != null){
            url += "/locale="+locale;
        }
        print(url);
        this._call(url, (String content) {
            Map data = JSON.decode(content);
            callback(data);
        });
    }

    void refreshData() {
        String trendingCount = "50";
        String locale = YounowLocale.LOCALE_DE;

        this.dashboard(trendingCount,locale,(jsonData){
            this.data = jsonData;
            print("fetched new younow data");
        });
    }

    Map getData() {
        return this.data;
    }

}