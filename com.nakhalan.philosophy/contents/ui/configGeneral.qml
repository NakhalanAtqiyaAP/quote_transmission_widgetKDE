
import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property alias cfg_intervalSeconds: interval.value
    property alias cfg_quoteColor: quoteColor.text
    property alias cfg_accentColor: accentColor.text
    property alias cfg_fontSize: fontSize.value
    property alias cfg_showAuthor: showAuthor.checked

    Controls.SpinBox {
        id: interval
        Kirigami.FormData.label: "Rotation interval (seconds)"
        from: 15
        to: 3600
        stepSize: 15
    }

    Controls.TextField {
        id: quoteColor
        Kirigami.FormData.label: "Quote color (hex)"
        placeholderText: "#75ff91"
    }

    Controls.TextField {
        id: accentColor
        Kirigami.FormData.label: "Accent color (hex)"
        placeholderText: "#37d66b"
    }

    Controls.SpinBox {
        id: fontSize
        Kirigami.FormData.label: "Quote font size"
        from: 10
        to: 36
    }

    Controls.CheckBox {
        id: showAuthor
        text: "Show philosopher name"
        Kirigami.FormData.label: "Author"
    }
}
