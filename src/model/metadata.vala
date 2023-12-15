using Gee;
using GLib;

namespace DocStructure {

  public class Metadata: GLib.Object{
      public Map<string, KeyMetadata> heading = new HashMap<string, KeyMetadata>();
      private ushort index;
      public string comment;

      public Metadata(){
          index = 0;
      }

      public int getAttributeSize(){
         return this.heading.size;
      }

      private Set<string>? getNominal(string input){
          try{
              Regex regex = new Regex ("{({*[^{}]*}*)}");
              if(regex.match(input)){
                  // print("%s\n", regex.get_pattern());
                  string[] words = regex.split(input)[1].split(",");
                  Gee.Set<string> nominals = new Gee.HashSet<string>();
                  foreach(var v in words){
                      nominals.add(v);
                  }
                  return nominals;
              }
              else{
                  print("nothing matched\n");
              }

          } catch (RegexError e){
              print ("Error %s\n", e.message);
          }
          return null;
      }

      public void insert(string attr_name, string attr_vals){
          KeyMetadata c_metadata = new KeyMetadata();
          c_metadata.index = this.index++;
          if(attr_vals == "REAL")
              c_metadata.type = AttributeType.REAL;
          else if(attr_vals == "numeric")
              c_metadata.type = AttributeType.NUMERIC;
          else{
              c_metadata.type = AttributeType.NOMINAL;
              c_metadata.nominal_values = getNominal(attr_vals);
          }
          heading.set(attr_name, c_metadata);
      }
  }

  public class KeyMetadata: GLib.Object{
      public AttributeType type;
      public int index;
      public Set<string> nominal_values;

      public KeyMetadata(){
          //nominal_values;
      }

      public int getNominalCount() throws TypeError{
          if(this.type != AttributeType.NOMINAL)
              throw new TypeError.NOT_NOMINAL("this isn't nominal");
          return this.nominal_values.size;
      }
  }
}




