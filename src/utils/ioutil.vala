using GLib;
using Gee;

class IOUtil{

    public IOUtil(string path){
        //fill your constructor
    }


    public static Document? read_file_from_path(string path) {
        File file = File.new_for_path (path);
        Document doc = new Document();
        try{
            DataInputStream dis = new DataInputStream(file.read());
            string line;
            Metadata metadata = new Metadata();
            while((line=dis.read_line())!=null){
                if(line.length == 0)
                    continue;
                if(line[0]=='%'){
                    metadata.comment += line[1:];
                    continue;
                }
                int 1st_space = line.index_of (" ", 0);
                string command = line.substring   (0, 1st_space);
                Regex pattern = new Regex("\\s+");
                //string[] words = line.split (" ");
                string[] words = pattern.split(line[1:]);

                switch(command){
                    case "@RELATION":
                        //break line to words, since line may contain space or tab
                        // need to use regex
                        //set the relation name
                        // print("%s\n", words[0]);
                        doc.name = words[1];
                        break;
                    case "@ATTRIBUTE":
                        // print ("%s\n", words[0]);
                        string attribute = words[1];
                        string vals = words[2];
                        //print("%s - %s\n", attribute, vals);
                        metadata.insert (attribute, vals);
                        break;
                    case "@DATA":
                        //once we encounter data, put metadata to collection
                        doc.metadata = metadata;
                        break;
                    default:
                        // our core processing is here, its guaranteed the
                        // successive lines are information
                        doc.insertData(line);
                        // print("%s\n", line);

                        break;
                }
                //stdout.printf ("%s\n", line);

            }
            return doc;
        } catch (Error e){
            error("%s", e.message);
        }
    }

    public static Document? read_file(File file) {
      Document doc = new Document();
      try{
          DataInputStream dis = new DataInputStream(file.read());
          string line;
          Metadata metadata = new Metadata();
          while((line=dis.read_line())!=null){
              if(line.length == 0)
                  continue;
              if(line[0]=='%'){
                  metadata.comment += line[1:];
                  continue;
              }
              int 1st_space = line.index_of (" ", 0);
              string command = line.substring   (0, 1st_space);
              Regex pattern = new Regex("\\s+");
              //string[] words = line.split (" ");
              string[] words = pattern.split(line[1:]);

              switch(command){
                  case "@RELATION":
                      //break line to words, since line may contain space or tab
                      // need to use regex
                      //set the relation name
                      // print("%s\n", words[0]);
                      doc.name = words[1];
                      break;
                  case "@ATTRIBUTE":
                      // print ("%s\n", words[0]);
                      string attribute = words[1];
                      string vals = words[2];
                      //print("%s - %s\n", attribute, vals);
                      metadata.insert (attribute, vals);
                      break;
                  case "@DATA":
                      //once we encounter data, put metadata to collection
                      doc.metadata = metadata;
                      break;
                  default:
                      // our core processing is here, its guaranteed the
                      // successive lines are information
                      doc.insertData(line);
                      // print("%s\n", line);

                      break;
              }
              //stdout.printf ("%s\n", line);
          }
          return doc;
        } catch (Error e){
            error("%s", e.message);
        }
      }
}
