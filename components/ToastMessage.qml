import "../singletons"
import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root

    property string message: ""
    property alias isOpen: opacityAnimationWrapper.isOpen

    signal dismissed()

    function show(msg) {
        root.message = msg;
        root.isOpen = true;
        dismissTimer.restart();
    }

    function dismiss() {
        root.isOpen = false;
    }

    implicitWidth: toastContent.implicitWidth + 48
    implicitHeight: toastContent.implicitHeight + 24
    color: Theme.withAlpha(Theme.mError, 0.95)
    radius: Theme.buttonRadius
    visible: isOpen

    Item {
        id: opacityAnimationWrapper

        property bool isOpen: false

        anchors.fill: parent
        opacity: isOpen ? 1 : 0
        scale: isOpen ? 1 : 0.8

        RowLayout {
            id: toastContent

            anchors.centerIn: parent
            spacing: 12

            Text {
                renderType: Text.NativeRendering
                font.family: "Material Symbols Outlined"
                font.pixelSize: Math.round(Theme.baseFontSize * 1.33)
                text: "\ue000"
                color: Theme.mOnError
            }

            Text {
                renderType: Text.NativeRendering
                font.family: Theme.fontFamily
                font.pixelSize: Math.round(Theme.baseFontSize * 1.17)
                text: root.message
                color: Theme.mOnError
            }

        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.animDurationNormal
                easing.type: Easing.OutCubic
            }

        }

        Behavior on scale {
            NumberAnimation {
                duration: Theme.animDurationNormal
                easing.type: Easing.OutBack
            }

        }

    }

    Timer {
        id: dismissTimer

        interval: 3000
        onTriggered: {
            root.dismiss();
        }
    }

    Connections {
        function onIsOpenChanged() {
            if (!root.isOpen)
                root.dismissed();

        }

        target: root
    }

}
