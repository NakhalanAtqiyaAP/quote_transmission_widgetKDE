
import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root

    width: 650
    height: 180

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    property int quoteIndex: 0

    property var quotes: [
        {
            author: "ALBERT CAMUS",
            text: "In the midst of winter, I found there was, within me, an invincible summer."
        },
        {
            author: "PLATO",
            text: "The beginning is the most important part of the work."
        },
        {
            author: "MARCUS AURELIUS",
            text: "You have power over your mind, not outside events."
        },
        {
            author: "FRIEDRICH NIETZSCHE",
            text: "He who has a why to live can bear almost any how."
        },
        {
            author: "SOCRATES",
            text: "The unexamined life is not worth living."
        },
        {
            author: "EPICTETUS",
            text: "It is not things that disturb us, but our judgments about them."
        },
        {
            author: "SENECA",
            text: "Difficulties strengthen the mind, as labor does the body."
        }
    ]

    Timer {
        interval: 120000
        running: true
        repeat: true

        onTriggered: {
            root.quoteIndex =
            (root.quoteIndex + 1) % root.quotes.length
        }
    }

    Column {
        anchors.fill: parent
        spacing: 14

        Text {
            text: "// PHILOSOPHICAL_TRANSMISSION"
            color: "#37d66b"
            font.family: "monospace"
            font.pixelSize: 11
            font.letterSpacing: 3
        }

        Text {
            width: parent.width
            text: root.quotes[root.quoteIndex].text
            color: "#75ff91"
            font.family: "monospace"
            font.pixelSize: 17
            font.bold: true
            wrapMode: Text.WordWrap
        }

        Text {
            text: root.quotes[root.quoteIndex].author
            color: "#6a9b73"
            font.family: "monospace"
            font.pixelSize: 13
            font.letterSpacing: 2
        }

        Text {
            text: "> reflect_on_this_"
            color: "#38c96c"
            font.family: "monospace"
            font.pixelSize: 12
        }
    }
}
