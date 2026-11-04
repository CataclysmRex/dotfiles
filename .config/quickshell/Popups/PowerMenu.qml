import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "../"
import "../Components"

BasePopup {
    id: root

    ColumnLayout {
        Layout.preferredWidth: 130

        MenuButton {
            icon: "lock"
            label: "Lock Screen"
            onClicked: {
                Quickshell.execDetached(["hyprlock"]);
                root.visible = false;
            }
        }

        MenuButton {
            icon: "logout"
            label: "Log Out"
            onClicked: {
                Hyprland.dispatch("exit");
                root.visible = false;
            }
        }

        MenuButton {
            icon: "restart_alt"
            label: "Restart"
            onClicked: {
                Quickshell.execDetached(["systemctl", "reboot"]);
                root.visible = false;
            }
        }

        MenuButton {
            icon: "power_settings_new"
            label: "Shut Down"
            // textColor: Colors.accent // Highlight dangerous action
            onClicked: {
                Quickshell.execDetached(["systemctl", "poweroff"]);
                root.visible = false;
            }
        }
    }
}
