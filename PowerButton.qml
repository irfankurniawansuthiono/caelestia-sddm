import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root

    property string iconText: ""
    property color normalColor: mOnSurface
    property color hoverColor: mPrimary
    property var onClickedAction: null

    hoverEnabled: true
    focusPolicy: Qt.ClickFocus
    onClicked: {
        if (onClickedAction)
            onClickedAction();

        restoreFocus();
    }

    background: Rectangle {
        radius: buttonRadius
        color: "transparent"
    }

    contentItem: Text {
        text: root.iconText
        font.family: "Material Symbols Outlined"
        font.pixelSize: Math.round(baseFontSize * 3.5)
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: (root.hovered || root.down) ? root.hoverColor : root.normalColor
    }

}
