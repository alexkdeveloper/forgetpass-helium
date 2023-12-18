
public class ForgetPass : He.Application {
    public ForgetPass () {
        Object (
            application_id: "com.github.alexkdeveloper.forgetpass",
            flags : GLib.ApplicationFlags.FLAGS_NONE
        );
    }

    public override void activate () {
        var win = this.active_window;
        if (win == null) {
            win = new Forgetpass.MainWindow (this);
        }
        win.present ();
    }

    public override void startup () {
        Gdk.RGBA accent_color = { 0 };
        accent_color.parse ("#91ed91");
        default_accent_color = He.Color.from_gdk_rgba (accent_color);

        base.startup();
    }
}

int main (string[] args) {
    Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
    Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");
    Intl.textdomain (Config.GETTEXT_PACKAGE);
    var app = new ForgetPass ();
    return app.run (args);
}
