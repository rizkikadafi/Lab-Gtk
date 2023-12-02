/**
* this function is created as an entry point to transform string to node map 
*/
using GLib;
using Gee;
class Nodes: GLib.Object{
    //the entry to nodes must have initial list
    private Gee.List<Node> list;

    //the class must be instantiated with list, better be sorted
    public Nodes(Gee.List<Content> list){
        this.list = new Gee.ArrayList<Node> ();
        //loop all list get the first character
        foreach(var row in list){
            Node<string, Content> node;
            string uid = row.getUid ();
            //split the string to first character and subsequent characters
            string uid0 = uid[0].to_string ();
            string uidN = uid[1:uid.length];
        }
    }
}