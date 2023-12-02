/* window.vala
 *
 * Copyright 2023 Rizki Kadafi
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace LabGtk {
    [GtkTemplate (ui = "/unj/gtk/com/ui/window.ui")]
    public class Window : Gtk.ApplicationWindow {
      [GtkChild]
      private unowned Gtk.Button load_button;
      [GtkChild]
      private unowned Gtk.Grid database;

      Database db = new Database();
      Document doc;

      public Window (Gtk.Application app) {
        var cssProvider = new Gtk.CssProvider ();
        cssProvider.load_from_resource ("/unj/gtk/com/style/style.css");
        Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), cssProvider, 1);
        
        Object (application: app);


        load_button.clicked.connect (load_button_handler);
      }

      public void load_button_handler() {
        Gtk.FileChooserDialog load_file = new Gtk.FileChooserDialog("Choose File", this, Gtk.FileChooserAction.OPEN, "_Cancel", Gtk.ResponseType.CANCEL, "_Open", Gtk.ResponseType.ACCEPT);
        load_file.present();
        load_file.response.connect((dialog, response) => {
          if(response == Gtk.ResponseType.ACCEPT){
            message("File Berhasil Dipilih\n");
            message("%s\n", load_file.get_file().get_basename());

            doc = IOUtil.read_file(load_file.get_file());
            db.add_document(doc);
            add_doc();

            load_file.close();
          }

          if(response == Gtk.ResponseType.CANCEL){
             message("File Batal Dipilih");
             load_file.close();
          }
        });
      }

      public void add_doc() {
        Gtk.Label id = new Gtk.Label(doc.getUid().to_string());
        Gtk.Label name = new Gtk.Label(doc.name);
        Gtk.Button delete_btn = new Gtk.Button.with_label("Delete");
        delete_btn.set_id(doc.getUid().to_string());

        int row = (int)db.get_size() + 1;

        database.attach(id, 0, row, 1, 1);
        database.attach(name, 1, row, 1, 1);
        database.attach(delete_btn, 2, row, 1, 1);

        delete_btn.clicked.connect(() => {
          db.delete_doc((int)delete_btn.get_id());
          database.remove_row(row);
        });

      }

      public void del_doc() {

      }
    }
}
