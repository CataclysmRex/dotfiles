import QtQuick
import QtQuick.Layouts
import "../"
import "../Popups"

RowLayout {
    id: root

    Text {
        anchors.centerIn: parent
        text: "power_settings_new"
        color: Colors.foreground
        font.family: "Material Symbols Rounded"
        font.pixelSize: 16
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            popup.visible = !popup.visible;
        }
    }

    PowerMenu {
        id: popup
    }
}
