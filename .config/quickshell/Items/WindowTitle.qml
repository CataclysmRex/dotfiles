import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

import "../"

RowLayout {
    id: root

    spacing: 10

    property string appId: Hyprland.activeToplevel ? Hyprland.activeToplevel.wayland.appId : ""
    property string activeWindowTitle: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
    property var desktopEntry: appId ? DesktopEntries.byId(appId) : null

    // Give the RowLayout an implicit size so parent containers know how big it is
    implicitHeight: Math.max(icon.implicitHeight, titleText.implicitHeight)

    IconImage {
        id: icon
        implicitSize: 16
        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
        visible: desktopEntry && desktopEntry.icon !== ""
        source: Quickshell.iconPath(desktopEntry ? desktopEntry.icon : "", true)
    }

    Text {
        id: titleText

        text: desktopEntry ? desktopEntry.name : "Desktop"

        color: Colors.foreground
    }

    // // Hover area & Tooltip
    // MouseArea {
    //     id: hoverArea
    //
    //     anchors.fill: parent
    //     hoverEnabled: true
    //     acceptedButtons: Qt.NoButton
    //
    //     // ToolTip.visible: hoverArea.containsMouse && root.activeWindowTitle.length > 0
    //     ToolTip.text: root.activeWindowTitle
    //     ToolTip.delay: 600
    // }
}
