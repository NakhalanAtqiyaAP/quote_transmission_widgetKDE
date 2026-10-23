import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    // Property alias cfg_* dihubungkan langsung ke nilai kontrol
    property alias cfg_intervalSeconds: interval.value
    property alias cfg_quoteColor: quoteColorValue.text
    property alias cfg_accentColor: accentColorValue.text
    property alias cfg_fontSize: fontSize.value
    property alias cfg_showAuthor: showAuthor.checked

    // Hidden textfield untuk menyimpan string hex warna yang dihubungkan ke KConfig
    Controls.TextField {
        id: quoteColorValue
        visible: false
    }

    Controls.TextField {
        id: accentColorValue
        visible: false
    }

    Controls.SpinBox {
        id: interval
        Kirigami.FormData.label: "Rotation interval (seconds):"
        from: 15
        to: 3600
    }

    RowLayout {
        Kirigami.FormData.label: "Quote color:"

        Rectangle {
            implicitWidth: 32
            implicitHeight: 24
            radius: 4
            color: quoteColorValue.text !== "" ? quoteColorValue.text : "#75ff91"
            border.color: "gray"
        }

        Controls.Button {
            text: "Choose color..."
            onClicked: quoteColorDialog.open()
        }
    }

    RowLayout {
        Kirigami.FormData.label: "Accent color:"

        Rectangle {
            implicitWidth: 32
            implicitHeight: 24
            radius: 4
            color: accentColorValue.text !== "" ? accentColorValue.text : "#37d66b"
            border.color: "gray"
        }

        Controls.Button {
            text: "Choose color..."
            onClicked: accentColorDialog.open()
        }
    }

    Controls.SpinBox {
        id: fontSize
        Kirigami.FormData.label: "Quote font size:"
        from: 10
        to: 36
    }

    Controls.CheckBox {
        id: showAuthor
        Kirigami.FormData.label: "Author:"
        text: "Show philosopher name"
    }

    ColorDialog {
        id: quoteColorDialog
        title: "Choose quote color"
        selectedColor: quoteColorValue.text !== "" ? quoteColorValue.text : "#75ff91"
        onAccepted: quoteColorValue.text = selectedColor.toString()
    }

    ColorDialog {
        id: accentColorDialog
        title: "Choose accent color"
        selectedColor: accentColorValue.text !== "" ? accentColorValue.text : "#37d66b"
        onAccepted: accentColorValue.text = selectedColor.toString()
    }
}