import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Scope {
    id: root

    // NotificationServer claims org.freedesktop.Notifications on DBus
    NotificationServer {
        id: server

        // Automatically accepts incoming notifications and assigns them an ID
        onNotification: notification => {
            // Silently dismiss/acknowledge the notification so it doesn't leak memory
            notification.dismiss();
        }
    }
}
