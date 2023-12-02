using GLib;
using Gee;

/**
* Example transcription
* abcd
* abdd
* key: a, children -> Node(key: b, children -> Node(key: c, children -> Node(key: d, children -> null))),  
*/
class Node<G, T>: GLib.Object{
    // Each node hold
    // 1. Current key
    // 2. Possible next nodes
    
    // in this version G must be a string, else won't work
    public G key{get;set;}

    public T val{get;set;}

    // this tree support multiple child nodes
    // if not initialized, children default to null
    public Gee.List<Node <G,T>>? children;

    /**
    * Our constructor assume our string is "abc"
    * then key is "a"
    * val is the remainder string "bc"
    */
    public Node(G key, T val){
        this.key = key;
        this.val = val;
        children = new Gee.LinkedList<Node>();
    }

    public void addChild(Node node){
        this.children.add(node);
    }
}
