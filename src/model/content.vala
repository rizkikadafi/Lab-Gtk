using Gee;
using GLib;
using Posix;

namespace DocStructure {
  public class Content: GLib.Object {
      private uint32[] _id = new uint32[3];

      private static uint32 sequence = 0;
      public int64 createdOn { get; set;}
      public int64 updatedOn { get; set;}
      //keys are column heading, while values are the data rows
      public Gee.Map<string, Any> map;

      //public static int staticVar = 0;
      //public static Gee.ArrayList<int> staticList = new Gee.ArrayList<int>();

      //we need a reference to parent class
      private weak Document doc;

       /**
       * Default constructor instantiate the class
       * immediately set unique id to class
       * the class must be parameterized
       */
      public Content(Document doc) {
          //staticList.add(staticVar);
          //staticVar++;
          //print("%d\n", staticList.size);
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
              char upper_hex = ((c >> 4) & 0xf);
              char lower_hex = (c & 0xf);
              if(upper_hex < 0xa)
                  upper_hex += '0';
              else
                  upper_hex += 'a' - 10;
              if(lower_hex < 0xa)
                  lower_hex += '0';
              else
                  lower_hex += 'a' - 10;
              res += upper_hex.to_string();
              res += lower_hex.to_string();
           }
           // print(res + "\n");
           return res;
      }

      /*
       * Concatenate all char as string
       */
      public string getUid(){
          char[] id = new char[12];
          memcpy((void *) &id[0], (void *) &_id[0], 4);
          memcpy((void *) &id[4], (void *) &_id[1], 4*sizeof(char));
          memcpy((void *) &id[8], (void *) &_id[2], 4*sizeof(char));
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
          if(keyMeta.type == AttributeType.REAL){
              Any<float?> any = this.getEntry(attributeName);
              return any.val;
          }
          throw new TypeError.NOT_FLOAT("The data wasn't a float");
      }

      public double getDoubleEntry(string attributeName) throws TypeError{
          Metadata meta = this.doc.metadata;
          KeyMetadata keyMeta = meta.heading.get(attributeName);
          if(keyMeta.type == AttributeType.NUMERIC){
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
}
