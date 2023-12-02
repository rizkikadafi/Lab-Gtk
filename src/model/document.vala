using GLib;
using Gee;

class Document: GLib.Object{
    public string name;
    private static int uid=0;
    //this list hold unsorted Content as data inserted
    public Gee.List<Content> list;// = new Content<double?>();
    public Metadata metadata{get;set;}
    public int64 createdOn;
    public int64 updatedOn;

    //create a mapping between uid and content
    private Gee.Map<string, Content> uidMap;

    //create a mapping between uid and content but using our own structure
    private Node<string, Content> indexMap;

    /**
     * initialize empty values of rows
     */
    public Document(){
        //if not given
        //this.name = name;
        metadata = new Metadata();
        GLib.Math.pow(10,2);
        uid++;
        list = new Gee.UnrolledLinkedList<Content>(isContentEqual);
        this.createdOn = new GLib.DateTime.now_local().to_unix();
        uidMap = new Gee.HashMap<string, Content>();
        //this.updatedOn = setUpdatedOn();
    }

    public int getUid() {
      return uid;
    }

    /**
     * Build index must be invoked manually
     */
    public void buildIndex(){
        //loop through all content and get the Uid
        foreach(var content in this.list){
            this.uidMap.set(content.getUid(), content);
        }
    }

    /**
    * The true function to set Multi Index based on our own implementation
    */
    public void buildAlternateIndex(){
        //start from create sorted list content by id 
        list.sort(compareContent);
    }

    public void insertData(string line){
        // break data by comma delimiter
        // then read metadata to arrange collection by metadata type
        string[] word = line.split(",");
        // return an immutable heading keys which we'll be using to loop'
        Content array = new Content(this);
        foreach(var entry in metadata.heading){
            //read the type of attribute type first
            AttributeType type = metadata.heading.get(entry.key).type;
            switch(type){
                case AttributeType.NUMERIC:
                    double val = double.parse(word[entry.value.index]);
                    Any<double?> any = new Any<double?>(val);
                    array.setEntry(entry.key, any);
                    break;
                case AttributeType.REAL:
                    float val  = float.parse(word[entry.value.index]);
                    Any<float?> any = new Any<float?>(val);
                    array.setEntry(entry.key, any);
                    break;
                case AttributeType.NOMINAL:
                    string val = word[entry.value.index];
                    Any<string> any = new Any<string>(val);
                    array.setEntry(entry.key, any);
                    break;
            }
        }
        list.add(array);
    }

    public int getInstanceCount(){
        return list.size;
    }

    public Gee.Set<string> getAttribute(){
        Gee.Set<string> set = this.metadata.heading.keys;
        return set;
    }

    /*
     * Normal searching without index by uid by looping all content
     */
    public Content? getContentById(string uid){
        foreach(var row in this.list){
            if(row.getUid() == uid)
                return row;
        }
        return null;
    }

    /**
     * Optimal implementation of
     */
    public Content? getContentThroughIndexById(string uid){
        return this.uidMap.get(uid);
    }
}
