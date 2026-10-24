import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

import "quotes.js" as QuotesData

PlasmoidItem {
    id: root

    width: 650
    height: 200

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    property int quoteIndex: 0
    property var quotes: QuotesData.data

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

    property string copyBtnLabel: "COPY"

    function nextQuote() {
        if (quotes.length === 0) return
        triggerTransition(() => {
            quoteIndex = (quoteIndex + 1) % quotes.length
        })
    }

    function prevQuote() {
        if (quotes.length === 0) return
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
        if (quotes.length === 0) return
        const quote = quotes[quoteIndex]
        const authorLine = showAuthor ? "\n— " + quote.author : ""
        copyHelper.text = quote.text + authorLine
        copyHelper.selectAll()
        copyHelper.copy()
        copyHelper.deselect()

        copyBtnLabel = "COPIED!"
        osdResetTimer.start()
    }

    Timer {
        id: fadeTimer
        interval: 140
        repeat: false
        property var callback: null
        onTriggered: {
            if (callback) callback()
            contentContainer.opacity = 1
        }
    }

    Timer {
        id: osdResetTimer
        interval: 1500
        repeat: false
        onTriggered: copyBtnLabel = "COPY"
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

    Rectangle {
        anchors.fill: parent
        anchors.margins: -8
        color: Qt.rgba(0, 0, 0, 0.25)
        radius: 8
        border.color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.15)
        border.width: 1
    }

    ColumnLayout {
        id: contentContainer
        anchors.fill: parent
        spacing: 10

        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
        }

        Text {
            Layout.fillWidth: true
            text: "“"
            color: root.accentColor
            font.family: "monospace"
            font.pixelSize: 32
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
            font.letterSpacing: 0.5
            lineHeight: 1.25
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter

            style: Text.Outline
            styleColor: Qt.rgba(0, 0, 0, 0.6)
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                visible: root.showAuthor
                text: "— " + root.quotes[root.quoteIndex].author
                color: root.accentColor
                font.family: "monospace"
                font.pixelSize: 12
                font.letterSpacing: 1.5
                font.bold: true
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }

            Controls.ToolButton {
                id: copyButton
                onClicked: root.copyQuote()
                contentItem: Text {
                    text: root.copyBtnLabel
                    font.family: "monospace"
                    font.pixelSize: 11
                    font.bold: true
                    color: copyButton.hovered ? root.quoteColor : root.accentColor
                }
                Controls.ToolTip.visible: hovered
                Controls.ToolTip.text: "Copy quote to clipboard"
            }

            Controls.ToolButton {
                id: prevButton
                onClicked: root.prevQuote()
                contentItem: Text {
                    text: "< PREV"
                    font.family: "monospace"
                    font.pixelSize: 11
                    font.bold: true
                    color: prevButton.hovered ? root.quoteColor : root.accentColor
                }
                Controls.ToolTip.visible: hovered
                Controls.ToolTip.text: "Previous quote"
            }

            Controls.ToolButton {
                id: nextButton
                onClicked: root.nextQuote()
                contentItem: Text {
                    text: "NEXT >"
                    font.family: "monospace"
                    font.pixelSize: 11
                    font.bold: true
                    color: nextButton.hovered ? root.quoteColor : root.accentColor
                }
                Controls.ToolTip.visible: hovered
                Controls.ToolTip.text: "Next quote"
            }
        }
    }
}