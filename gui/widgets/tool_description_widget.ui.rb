# Resource require via qt4-qtruby-qtdesigner-fix 
require "Qt4"; require "widgets/tool_description_widget.qrc.rb" 
 
=begin
** Form generated from reading ui file 'tool_description_widget.ui'
**
** Created: Mo 12. Dez 22:20:16 2011
**      by: Qt User Interface Compiler version 4.6.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

require 'Qt4'

		class Ui_ToolDescriptionWidget < Qt::Widget

    def self.attr_reader(*p_args)
      @children_widgets ||= []
      @children_widgets.concat(p_args)
      super
    end
    def self.children_widgets; @children_widgets - [:extension] end
    def children_widgets; self.class.children_widgets end

		attr_reader :extension
    attr_reader :layoutWidget
    attr_reader :toolDescriptionLayout
    attr_reader :toolFrameMainContainer
    attr_reader :toolShadowFrame
    attr_reader :toolImage
    attr_reader :toolDescription
    attr_reader :toolTitle
    attr_reader :imageDescriptionSeparator

		def setupUi(toolDescriptionWidget)
		require "#{File.dirname(__FILE__)}/tool_description_widget.ui.ext.rb";
		@extension = ToolDescriptionWidgetExtUi.new(self, toolDescriptionWidget)

    if toolDescriptionWidget.objectName.nil?
        toolDescriptionWidget.objectName = "toolDescriptionWidget"
    end
    toolDescriptionWidget.resize(541, 131)
    @layoutWidget = Qt::Widget.new(toolDescriptionWidget)
    @layoutWidget.objectName = "layoutWidget"
    @layoutWidget.geometry = Qt::Rect.new(0, 0, 541, 131)
    @toolDescriptionLayout = Qt::GridLayout.new(@layoutWidget)
    @toolDescriptionLayout.spacing = 6
    @toolDescriptionLayout.objectName = "toolDescriptionLayout"
    @toolDescriptionLayout.setContentsMargins(0, 0, 0, 0)
    @toolFrameMainContainer = Qt::Frame.new(@layoutWidget)
    @toolFrameMainContainer.objectName = "toolFrameMainContainer"
    @toolFrameMainContainer.maximumSize = Qt::Size.new(183, 122)
    @toolShadowFrame = Qt::Label.new(@toolFrameMainContainer)
    @toolShadowFrame.objectName = "toolShadowFrame"
    @toolShadowFrame.geometry = Qt::Rect.new(0, 0, 182, 122)
    @toolShadowFrame.minimumSize = Qt::Size.new(182, 122)
    @toolShadowFrame.maximumSize = Qt::Size.new(182, 122)
    @toolShadowFrame.textFormat = Qt::PlainText
    @toolShadowFrame.alignment = Qt::AlignLeading|Qt::AlignLeft|Qt::AlignTop
    @toolImage = Qt::Label.new(@toolFrameMainContainer)
    @toolImage.objectName = "toolImage"
    @toolImage.geometry = Qt::Rect.new(1, 1, 179, 118)
    @toolImage.minimumSize = Qt::Size.new(179, 118)
    @toolImage.maximumSize = Qt::Size.new(179, 118)
    @toolImage.cursor = Qt::Cursor.new(Qt::PointingHandCursor)
    @toolImage.mouseTracking = true
    @toolImage.focusPolicy = Qt::ClickFocus
    @toolImage.styleSheet = "border-radius: 4px;\n" \
"margin: 1px;"
    @toolImage.textFormat = Qt::PlainText
    @toolImage.alignment = Qt::AlignCenter

    @toolDescriptionLayout.addWidget(@toolFrameMainContainer, 1, 0, 2, 1)

    @toolDescription = Qt::Label.new(@layoutWidget)
    @toolDescription.objectName = "toolDescription"
    @toolDescription.maximumSize = Qt::Size.new(350, 16777215)
    @font = Qt::Font.new
    @font.pointSize = 9
    @toolDescription.font = @font
    @toolDescription.textFormat = Qt::PlainText
    @toolDescription.alignment = Qt::AlignLeading|Qt::AlignLeft|Qt::AlignTop
    @toolDescription.wordWrap = true

    @toolDescriptionLayout.addWidget(@toolDescription, 2, 1, 1, 1)

    @toolTitle = Qt::Label.new(@layoutWidget)
    @toolTitle.objectName = "toolTitle"
    @toolTitle.maximumSize = Qt::Size.new(16777215, 20)
    @font1 = Qt::Font.new
    @font1.pointSize = 11
    @font1.bold = true
    @font1.weight = 75
    @toolTitle.font = @font1

    @toolDescriptionLayout.addWidget(@toolTitle, 1, 1, 1, 1)

    @imageDescriptionSeparator = Qt::SpacerItem.new(2, 2, Qt::SizePolicy::Minimum, Qt::SizePolicy::Fixed)

    @toolDescriptionLayout.addItem(@imageDescriptionSeparator, 0, 1, 1, 1)


    retranslateUi(toolDescriptionWidget)

    Qt::MetaObject.connectSlotsByName(toolDescriptionWidget)
    end # setupUi

    def setup_ui(toolDescriptionWidget)
        setupUi(toolDescriptionWidget)
    end

    def retranslateUi(toolDescriptionWidget)
    toolDescriptionWidget.windowTitle = Qt::Application.translate("ToolDescriptionWidget", "Form", nil, Qt::Application::UnicodeUTF8)
    @toolShadowFrame.text = ''
    @toolImage.toolTip = Qt::Application.translate("ToolDescriptionWidget", "Click to start this tool", nil, Qt::Application::UnicodeUTF8)
    @toolImage.text = ''
    @toolDescription.text = ''
    @toolTitle.text = ''
    end # retranslateUi

    def retranslate_ui(toolDescriptionWidget)
        retranslateUi(toolDescriptionWidget)
    end

end

module Ui
    class ToolDescriptionWidget < Ui_ToolDescriptionWidget
    end
end  # module Ui

if $0 == __FILE__
    a = Qt::Application.new(ARGV)
    u = Ui_ToolDescriptionWidget.new
    w = Qt::Widget.new
    u.setupUi(w)
    w.show
    a.exec
end
