import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root

    width: 650
    height: 180

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    property int quoteIndex: 0

    readonly property int rotationInterval:
        Math.max(15, Plasmoid.configuration.intervalSeconds || 120) * 1000

    readonly property color quoteColor: {
        const value = Plasmoid.configuration.quoteColor || "#75ff91"
        return /^#[0-9a-fA-F]{6}$/.test(value) ? value : "#75ff91"
    }

    readonly property color accentColor: {
        const value = Plasmoid.configuration.accentColor || "#37d66b"
        return /^#[0-9a-fA-F]{6}$/.test(value) ? value : "#37d66b"
    }

    readonly property int quoteFontSize:
        Math.max(10, Math.min(36, Plasmoid.configuration.fontSize || 17))

    readonly property bool showAuthor:
        Plasmoid.configuration.showAuthor !== false

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

    function nextQuote() {
        triggerTransition(() => {
            quoteIndex = (quoteIndex + 1) % quotes.length
        })
    }

    function prevQuote() {
        triggerTransition(() => {
            quoteIndex = (quoteIndex - 1 + quotes.length) % quotes.length
        })
    }

    function triggerTransition(changeQuoteCallback) {
        contentContainer.opacity = 0
        fadeTimer.callback = changeQuoteCallback
        fadeTimer.start()
    }

    function copyQuote() {
        const quote = quotes[quoteIndex]
        const authorLine = showAuthor ? "\n— " + quote.author : ""
        copyHelper.text = quote.text + authorLine
        copyHelper.selectAll()
        copyHelper.copy()
        copyHelper.deselect()
    }

    Timer {
        id: fadeTimer
        interval: 150
        repeat: false
        property var callback: null
        onTriggered: {
            if (callback) callback()
            contentContainer.opacity = 1
        }
    }

    Timer {
        id: rotationTimer
        interval: root.rotationInterval
        running: true
        repeat: true
        onTriggered: root.nextQuote()
    }

    onRotationIntervalChanged: rotationTimer.restart()

    TextEdit {
        id: copyHelper
        visible: false
        text: ""
    }

    ColumnLayout {
        id: contentContainer
        anchors.fill: parent
        spacing: 12

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        Text {
            Layout.fillWidth: true
            text: "“"
            color: root.accentColor
            font.family: "monospace"
            font.pixelSize: 28
            font.bold: true
        }

        Text {
            id: quoteText
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: root.quotes[root.quoteIndex].text
            color: root.quoteColor
            font.family: "monospace"
            font.pixelSize: root.quoteFontSize
            font.bold: true
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                visible: root.showAuthor
                text: "— " + root.quotes[root.quoteIndex].author
                color: root.accentColor
                font.family: "monospace"
                font.pixelSize: 12
                font.letterSpacing: 1
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }

            Controls.ToolButton {
                text: "COPY"
                display: Controls.AbstractButton.TextOnly
                onClicked: root.copyQuote()
                Controls.ToolTip.visible: hovered
                Controls.ToolTip.text: "Copy quote"
            }

            Controls.ToolButton {
                text: "< PREV"
                display: Controls.AbstractButton.TextOnly
                onClicked: root.prevQuote()
                Controls.ToolTip.visible: hovered
                Controls.ToolTip.text: "Previous quote"
            }

            Controls.ToolButton {
                text: "NEXT >"
                display: Controls.AbstractButton.TextOnly
                onClicked: root.nextQuote()
                Controls.ToolTip.visible: hovered
                Controls.ToolTip.text: "Next quote"
            }
        }
    }
}