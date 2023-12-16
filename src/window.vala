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
using DocStructure;

namespace LabGtk {
    [GtkTemplate (ui = "/unj/gtk/com/ui/window.ui")]
    public class Window : Gtk.ApplicationWindow {
      [GtkChild]
      private unowned Gtk.Button load_button;
      [GtkChild]
      private unowned Gtk.Grid database;
      [GtkChild]
      private unowned Gtk.Stack pages;

      Database db = new Database();
      Document doc;
      Gtk.Button detail_btn;

      public Window (Gtk.Application app) {
        var cssProvider = new Gtk.CssProvider ();
        cssProvider.load_from_resource ("/unj/gtk/com/style/style.css");
        Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), cssProvider, 1);

        
        Object (application: app);
        message("%s", pages.get_visible_child_name());


        message("%s", pages.get_visible_child_name());


        // pages.add_named(gridview, "content");
        // pages.set_visible_child_name("content");

        load_button.clicked.connect (load_button_handler);
      }

      // load button handler
      public void load_button_handler() {
        Gtk.FileChooserDialog load_file = new Gtk.FileChooserDialog("Choose File", this, Gtk.FileChooserAction.OPEN, "_Cancel", Gtk.ResponseType.CANCEL, "_Open", Gtk.ResponseType.ACCEPT);
        Gtk.Button test = load_file.get_widget_for_response(Gtk.ResponseType.CANCEL) as Gtk.Button;
        message(test.get_label());
        load_file.present();
        test.clicked.connect(() => {
          message("cancel button clicked\n");
        });
        load_file.response.connect(dialog_callback);
      }

      // dialog callback
      public void dialog_callback(Gtk.Dialog dialog, int response) {
          Gtk.FileChooserDialog chooser = dialog as Gtk.FileChooserDialog;
          if(response == Gtk.ResponseType.ACCEPT){
            message("File Berhasil Dipilih\n");
            message("%s\n", chooser.get_file().get_basename());

            // read file
            doc = IOUtil.read_file(chooser.get_file());

            // add doc to db
            db.add_document(doc);

            // build ui
            add_doc_ui();

            chooser.close();
          }

          if(response == Gtk.ResponseType.CANCEL){
             message("File Batal Dipilih");
             chooser.close();
          }
      }

      public void add_doc_ui() {
        Gtk.Label id = new Gtk.Label(doc.getUid().to_string());
        Gtk.Label name = new Gtk.Label(doc.name);


        detail_btn = new Gtk.Button.with_label("Detail");
        detail_btn.set_id(doc.getUid().to_string());

        int row = (int)db.get_size() + 1;

        database.attach(id, 0, row, 1, 1);
        database.attach(name, 1, row, 1, 1);
        database.attach(detail_btn, 2, row, 1, 1);

        Gtk.ScrolledWindow swin = new Gtk.ScrolledWindow();
        pages.add_named(swin, doc.getUid().to_string());
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 3);
        Gtk.Button back_btn = new Gtk.Button.with_label("Back");
        back_btn.clicked.connect(back_btn_handler);
        box.append(back_btn);
        box.append(build_grid());
        swin.set_child(box);

        detail_btn.clicked.connect(detail_btn_handler);
      }

      private void back_btn_handler() {
        pages.set_visible_child_name("dashboard");
      }

      private void detail_btn_handler(Gtk.Button btn) {
        message(pages.get_visible_child_name());
        pages.set_visible_child_name(btn.get_id());
      }

      Gtk.GridView build_grid() {
        GLib.ListStore model = new GLib.ListStore(GLib.Type.OBJECT);
        model.append(new Gtk.Label("id"));

        foreach (var heading in doc.metadata.heading) {
          model.append(new Gtk.Label(heading.key));
        }

        foreach (Content content in doc.list) {
          model.append(new Gtk.Label(content.getUid().to_string()));
          foreach (var item in content.map) {
            AttributeType type = doc.metadata.heading.get(item.key).type;
            switch (type) {
              case AttributeType.NUMERIC:
                try {
                  Gtk.Label label = new Gtk.Label(content.getDoubleEntry(item.key).to_string());
                  model.append(label);
                } catch (TypeError e) { message(e.message); }
                break;
              case AttributeType.REAL:
                try {
                  Gtk.Label label = new Gtk.Label(content.getFloatEntry(item.key).to_string());
                  model.append(label);
                } catch (TypeError e) { message(e.message); }
                break;
              case AttributeType.NOMINAL:
                try {
                  Gtk.Label label = new Gtk.Label(content.getStringEntry(item.key));
                  model.append(label);
                } catch (TypeError e) { message(e.message); }
                break;
            }
          }
        }

        Gtk.GridView gridview = new Gtk.GridView(new Gtk.NoSelection(model), new Gtk.BuilderListItemFactory.from_resource(null, "/unj/gtk/com/ui/grid.ui"));
        gridview.set_min_columns(doc.metadata.heading.size + 1);
        gridview.set_max_columns(doc.metadata.heading.size + 1);

        return gridview;
      }


    }
}
