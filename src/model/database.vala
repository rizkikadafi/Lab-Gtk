namespace DocStructure {
  public class Database: GLib.Object {
    public Gee.ArrayList<Document> documents;

    public Database() {
      documents = new Gee.ArrayList<Document>();
    }

    public Document? get_document_by_id(int uid) {
      foreach (Document document in documents) {
        if(document.getUid() == uid) {
          return document;
        }
      }
      return null;
    }

    public void add_document(Document document) {
      documents.add(document);
    }

    public uint get_size() {
      return documents.size;
    }

    public void delete_doc(int uid) {
      for (int i = 0; i < documents.size; i++) {
        if(documents.get(i).getUid() == uid) {
          documents.remove_at(i);
        }
      }
    }
  }
}
