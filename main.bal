import ballerina/http;

//new type declaration
type ItunesResultsItems record {
    string collectionName;
    string collectionViewUrl;
};

type ItunesResults record {
    ItunesResultsItems[]  results;
};

type Album record {|
    string name;
    string url;
    
|};
service /picagift on new http:Listener(8080) {
    resource function get albums(string artist) returns Album[]|error{

        http:Client iTunes = check new("https://itunes.apple.com"); //http client 

        //call the api
        ItunesResults search = check  iTunes->get(searchURL(artist)); //assigning the response to json variable.

        return from ItunesResultsItems i in search.results
            select {name: i.collectionName, url:i.collectionViewUrl};
    }
}


//prepare search query with artist parameeter
function searchURL(string artist) returns string {
    return "/search?term="+artist;
}