
using Gtk;

namespace Forgetpass {
	public class MainWindow : He.ApplicationWindow {
        private PasswordEntry generated_pass;
        private PasswordEntry entry_key;
        private Entry entry_site;
        private Overlay overlay;
        private He.Toast name_toast;
        private He.Toast keyword_toast;

		public MainWindow (He.Application app) {
			Object (application: app, title: "Forgetpass", default_height: 250, default_width: 350);
		}

		construct {
            entry_site = new Entry();
            entry_site.placeholder_text = _("Site");
            entry_site.tooltip_text = _("Use only the domain name without prefixes, such as http or www, and endings, such as .com, etc.");
            entry_site.secondary_icon_name = "edit-clear-symbolic";
            entry_site.icon_press.connect((pos, event)=>{
                entry_site.set_text("");
                entry_site.grab_focus();
            });

            entry_key = new PasswordEntry();
            entry_key.show_peek_icon = true;
            entry_key.placeholder_text = _("Keyword");
            entry_key.tooltip_text = _("Be sure to remember the keyword! If you forget it, you won't be able to recover your password!");

            var generate_button = new He.PillButton(_("GENERATE"));

            generated_pass = new PasswordEntry() {
                hexpand = true,
                show_peek_icon = true,
                editable = false
            };     

            var copy_button = new He.IconicButton("edit-copy-symbolic");
            copy_button.tooltip_text = _("Copy to clipboard");

            generate_button.clicked.connect(on_generate);
            copy_button.clicked.connect(on_copy);

            var hbox_pass = new Box (Orientation.HORIZONTAL, 5);
            hbox_pass.append (generated_pass);
            hbox_pass.append (copy_button);

            var box = new Box (Orientation.VERTICAL, 10);
            box.vexpand = true;
            box.margin_start = 10;
            box.margin_end = 10;
            box.append(entry_site);
            box.append(entry_key);
            box.append(generate_button);
            box.append(hbox_pass);

            var appbar = new He.AppBar();

            overlay = new Overlay();
            overlay.set_child(box);

            var main_box = new Box (Orientation.VERTICAL, 0);
            main_box.append(appbar);
            main_box.append(overlay);

            set_child(main_box);

            name_toast = new He.Toast(_("Enter the name of the site"));
            overlay.add_overlay(name_toast);
            keyword_toast = new He.Toast(_("Enter a keyword"));
            overlay.add_overlay(keyword_toast);
	}

		private void on_generate(){
            if(is_empty(entry_site.text)){
                name_toast.send_notification();
                entry_site.grab_focus();
                return;
            }
            if(is_empty(entry_key.text)){
                keyword_toast.send_notification();
                entry_key.grab_focus();
                return;
            }
		    try {
                  generated_pass.text = Crypto.derive_password(entry_key.text.strip(), entry_site.text.down().strip());
                } catch (CryptoError error) {
                    alert();
                }
		}
        private void on_copy(){
              var clipboard = Gdk.Display.get_default().get_clipboard();
              clipboard.set_text(generated_pass.get_text());
            }
        private bool is_empty(string str){
            return str.strip().length == 0;
        }

	private void alert (){
            var dialog = new He.Dialog (
                                true,
                                this,
                                _("ERROR!"),
                                "",
                                _("Failed to generate password!"),
                                "dialog-error-symbolic",
                                null,
                                null
                            );
            dialog.show ();
        }
    }
}


