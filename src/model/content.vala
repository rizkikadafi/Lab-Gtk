using Gee;
using GLib;
using Posix;

class Content: GLib.Object {
    private uint32[] _id = new uint32[3];

    private static uint32 sequence = 0;
    public int64 createdOn { get; set;}
    public int64 updatedOn { get; set;}
    //keys are column heading, while values are the data rows
    private Gee.Map<string, Any> map;

    //we need a reference to parent class
    private weak Document doc;

     /**
     * Default constructor instantiate the class
     * immediately set unique id to class
     * the class must be parameterized
     */
    public Content(Document doc) {
        this.generateUid();
        map = new HashMap<string, Any>();
        this.createdOn = new GLib.DateTime.now_local().to_unix();
        this.doc = doc;

    }

    // to generate uid call here
    private void generateUid(){
        sequence += 1;
        _id[2] = sequence;
        GLib.DateTime dtime = new GLib.DateTime.now_local();
        int64 time = dtime.to_unix();
        uint64 utime = (uint64) time;
        _id[0] =  (uint32) (utime & 0xffffffff);
        _id[1] = GLib.Random.next_int();
    }

    /**
    * 
    */
    private string uidToHexChar(char[] uid){
        string res = "";
        //loop per byte
        foreach(char c in uid){
            //split a byte into two hex 

            // print("%b:%d\n", c, c);
            var cur_c = 0x0;
            if(c < 0) {
              cur_c = c + 128;
            } else {
              cur_c = c;
            }
            // print("%b:%d\n", cur_c, cur_c);
            var r = 0x00;
            var right_hex = cur_c & 0xf;
            var left_hex = (cur_c >> 4) & 0xf;
            // print("left_hex: %b-%d\n", left_hex, left_hex);
            // print("right_hex: %b-%d\n", right_hex, right_hex);

            // print("\n--------------------\n");
            if(left_hex <= 3) {
              r |= left_hex + 4;
              r <<= 4;
              if(right_hex > 9) {
                r |= (right_hex + 1) % 10;
              } else {
                r |= (right_hex + 1) % 11;
              }
            } else {
              r |= left_hex;
              r <<= 4;
              if(right_hex > 9) {
                r |= (right_hex + 1) % 10;
              } else {
                r |= (right_hex + 1) % 11;
              }
            }

            res += ((char)r).to_string();
         }
         // print(res + "\n");
         return res;
    }

    /*
     * Concatenate all char as string
     */
    public string getUid(){
        char[] id = new char[12];
        memcpy((void *) &id[0], (void *) &_id[0], 4*sizeof(char));
        memcpy((void *) &id[4], (void *) &_id[1], 4*sizeof(char));
        memcpy((void *) &id[8], (void *) &_id[2], 4*sizeof(char));
        // printf("%.*s\n", id.length, id);
        string res = this.uidToHexChar(id);
        return res;
    }

    public Any? getEntry(string attributeName){
        
        return map.get(attributeName);
    }

    public float getFloatEntry(string attributeName) throws TypeError{
        //get Metadata
        Metadata meta = this.doc.metadata;
        KeyMetadata keyMeta = meta.heading.get(attributeName);
        if(keyMeta.type == AttributeType.NUMERIC){
            Any<float?> any = this.getEntry(attributeName);
            return any.val;
        }
        throw new TypeError.NOT_FLOAT("The data wasn't a float");
    }

    public double getDoubleEntry(string attributeName) throws TypeError{
        Metadata meta = this.doc.metadata;
        KeyMetadata keyMeta = meta.heading.get(attributeName);
        if(keyMeta.type == AttributeType.REAL){
            Any<double?> any = this.getEntry(attributeName);
            return any.val;
        }
        throw new TypeError.NOT_DOUBLE("The data wasn't a double");
    }

    public string getStringEntry(string attributeName) throws TypeError{
        Metadata meta = this.doc.metadata;
        KeyMetadata keyMeta = meta.heading.get(attributeName);
        if(keyMeta.type == AttributeType.NOMINAL){
            Any<string> any = this.getEntry(attributeName);
            return any.val;
        }
        throw new TypeError.NOT_NOMINAL("The data wasn't a nominal");
    }

    public void setEntry(string attributeName, Any any){
        map.set(attributeName, any);
        this.updatedOn = new GLib.DateTime.now_local().to_unix();
        doc.updatedOn = this.updatedOn;
    }

    public uint32 getTimeStamp(){
        return this._id[0];
    }
}
