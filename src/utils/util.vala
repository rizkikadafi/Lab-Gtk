using Gee;

Gee.List<string> generate_random_string(uint16 count_generated, uint8 char_length){
    int32 limit = (int32) GLib.Math.pow(10, (double) char_length + 1);
    //its guaranteed to generate at max char_length integer values
    Gee.List<string> vector = new ArrayList<string>();
    for(var i=0;i<count_generated;i++){
        int32 x = new GLib.Rand().int_range(0, limit);
        string word = x.to_string();
        vector.add(word);

    }

    return vector;
}

//create a level index
private Gee.Map<string, Gee.List> createIndex(Gee.List<string> vector){
    Gee.Map<string, Gee.List> index_map = new Gee.TreeMap<string, Gee.List>();
    //loop all string to find all first digit
    foreach (string word in vector){
        //get first digit
        string first = word[0].to_string();
        string leftoverwords = word[1:];
        Gee.List<string> list = index_map.get(first);
        if(list != null){
            list.add(leftoverwords);
        } else{
            list = new Gee.ArrayList<string>();
            index_map.set(first, list);
        }
    }
    return index_map;
}

private Gee.Map<string, Gee.Map> createMultiIndex(Gee.List<string> vector){
    Gee.Map<string, Gee.Map> index_map = new Gee.TreeMap<string, Gee.Map>();
    foreach (string word in vector){
        string first = word[0].to_string();
        Gee.Map<string, Gee.Map> recMap = index_map.get(first);
        index_map.set(first, recMap);
    }

    foreach (var entry in index_map){
        string first = entry.key;
        Gee.List<string> bvector = new ArrayList<string>();
        Gee.Map<string, Gee.Map> currentMap = index_map.get(first);
        foreach (var word in vector){
            string anotherfirst = word[0].to_string();
            if(first == anotherfirst){
                bvector.add(word[1:]);
            }
        }
        Gee.Map<string, Gee.Map> returnMap = recMultiIndex(currentMap, bvector);
        index_map.set(first, returnMap);
    }
    return index_map;
}

//TODO
private Gee.Map<string, Gee.Map> recMultiIndex(Gee.Map<string, Gee.Map> map, Gee.List<string> vector){

    return null;
}

bool isContentEqual(Content a, Content b){
    return a.getUid() == b.getUid();
}

int compareContent(Content a, Content b){
    //get the timestamp part of Uid from each content
    string uid1 =  a.getUid();
    string uid2 = b.getUid();
    if(uid1 < uid2)
        return -1;
    else if(uid1 > uid2)
        return 1; 
    return 0;
}
