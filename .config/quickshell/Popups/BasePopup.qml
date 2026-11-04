import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../"

PopupWindow {
    id: root

    anchor.item: parent

    default property alias contentData: mainLayout.data

    property real margins: 16

    grabFocus: true
    color: "transparent" // Let WrapperRectangle handle background & radius

    implicitWidth: wrapper.implicitWidth
    implicitHeight: wrapper.implicitHeight

    // anchor.margins.top: parent.implicitHeight
    anchor.margins.top: root.QsWindow.window ? root.QsWindow.window.height : 0

    WrapperRectangle {
        id: wrapper

        color: Colors.popupBackground
        border.color: Colors.popupBorder
        border.width: 1
        radius: 12

        // WrapperRectangle automatically applies padding to its children
        margin: root.margins

        ColumnLayout {
            id: mainLayout

            spacing: 10
        }
    }
}
