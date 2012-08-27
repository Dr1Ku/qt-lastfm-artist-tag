# Resource require via qt4-qtruby-qtdesigner-fix 
require "Qt4"; require "forms/main_window.qrc.rb" 
 
=begin
** Form generated from reading ui file 'main_window.ui'
**
** Created: Mo 12. Dez 22:20:18 2011
**      by: Qt User Interface Compiler version 4.6.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

require 'Qt4'

		class Ui_MainWindow < Qt::Widget

    def self.attr_reader(*p_args)
      @children_widgets ||= []
      @children_widgets.concat(p_args)
      super
    end
    def self.children_widgets; @children_widgets - [:extension] end
    def children_widgets; self.class.children_widgets end

		attr_reader :extension
    attr_reader :centralWidget
    attr_reader :horizontalLayout
    attr_reader :leftMenuFrame
    attr_reader :verticalLayout_2
    attr_reader :pushButton
    attr_reader :pushButton_4
    attr_reader :verticalSpacer
    attr_reader :dropZoneFrame
    attr_reader :contentAndLineGrid
    attr_reader :gridLayout
    attr_reader :menuContentDivider
    attr_reader :contentGrid
    attr_reader :titleLabel_2
    attr_reader :featuresLabel
    attr_reader :spacerWest
    attr_reader :spacerSourh
    attr_reader :spacerNorth
    attr_reader :verticalSpacer_2
    attr_reader :spacerEast
    attr_reader :statusBar

    def setupUi(mainWindow)
    if mainWindow.objectName.nil?
        mainWindow.objectName = "mainWindow"
    end
    mainWindow.resize(900, 560)
    mainWindow.minimumSize = Qt::Size.new(900, 560)
    @font = Qt::Font.new
    @font.styleStrategy = Qt::Font::PreferAntialias
    mainWindow.font = @font
    mainWindow.unifiedTitleAndToolBarOnMac = false
		require "#{File.dirname(__FILE__)}/main_window.ui.ext.rb";@centralWidget = MainWindowExtUi.new(self, mainWindow)
    @centralWidget.objectName = "centralWidget"
    @horizontalLayout = Qt::HBoxLayout.new(@centralWidget)
    @horizontalLayout.spacing = 0
    @horizontalLayout.margin = 0
    @horizontalLayout.objectName = "horizontalLayout"
    @leftMenuFrame = Qt::Frame.new(@centralWidget)
    @leftMenuFrame.objectName = "leftMenuFrame"
    @sizePolicy = Qt::SizePolicy.new(Qt::SizePolicy::Fixed, Qt::SizePolicy::MinimumExpanding)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = @leftMenuFrame.sizePolicy.hasHeightForWidth
    @leftMenuFrame.sizePolicy = @sizePolicy
    @palette = Qt::Palette.new
    brush = Qt::Brush.new(Qt::Color.new(255, 255, 255, 255))
    brush.style = Qt::SolidPattern
    @palette.setBrush(Qt::Palette::Active, Qt::Palette::Base, brush)
    @palette.setBrush(Qt::Palette::Active, Qt::Palette::Window, brush)
    @palette.setBrush(Qt::Palette::Inactive, Qt::Palette::Base, brush)
    @palette.setBrush(Qt::Palette::Inactive, Qt::Palette::Window, brush)
    @palette.setBrush(Qt::Palette::Disabled, Qt::Palette::Base, brush)
    @palette.setBrush(Qt::Palette::Disabled, Qt::Palette::Window, brush)
    @leftMenuFrame.palette = @palette
    @leftMenuFrame.autoFillBackground = true
    @leftMenuFrame.frameShape = Qt::Frame::NoFrame
    @verticalLayout_2 = Qt::VBoxLayout.new(@leftMenuFrame)
    @verticalLayout_2.spacing = 0
    @verticalLayout_2.margin = 0
    @verticalLayout_2.objectName = "verticalLayout_2"
    @pushButton = Qt::PushButton.new(@leftMenuFrame)
    @pushButton.objectName = "pushButton"
    @sizePolicy1 = Qt::SizePolicy.new(Qt::SizePolicy::Fixed, Qt::SizePolicy::Fixed)
    @sizePolicy1.setHorizontalStretch(0)
    @sizePolicy1.setVerticalStretch(0)
    @sizePolicy1.heightForWidth = @pushButton.sizePolicy.hasHeightForWidth
    @pushButton.sizePolicy = @sizePolicy1
    @pushButton.minimumSize = Qt::Size.new(0, 26)
    @pushButton.maximumSize = Qt::Size.new(16777215, 26)
    @pushButton.font = @font
    @pushButton.cursor = Qt::Cursor.new(Qt::PointingHandCursor)
    @pushButton.styleSheet = "QPushButton {\n" \
"\n" \
"background-color: \n" \
" qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #fff, stop: 1 #e5e5e5);\n" \
"\n" \
"border-bottom: 1px solid #afafaf;\n" \
"border-top: 1px solid #e9e9e9;\n" \
"\n" \
"width: 151px;\n" \
"height: 30px;\n" \
"\n" \
"padding: 0;\n" \
"margin: 0;\n" \
"\n" \
"width: 151px;\n" \
"height: 30px;\n" \
"\n" \
"color: #000;\n" \
"\n" \
"padding: 0;\n" \
"margin: 0;\n" \
"\n" \
"}\n" \
"\n" \
"QPushButton:hover {\n" \
"\n" \
"background-color: #5097cc;\n" \
"\n" \
"border-bottom: 1px solid #3371a0;\n" \
"border-top: 1px solid #59a8e3;\n" \
"\n" \
"color: #fff;\n" \
"\n" \
"}\n" \
"\n" \
"QPushButton:pressed {\n" \
"\n" \
"background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,\n" \
"                                       stop: 0 #8ed0fa, stop: 1 #4991c7);\n" \
"\n" \
"border-bottom: 1px solid #3371a0;\n" \
"border-top: 1px solid #9ee8ff;\n" \
"\n" \
"color: #fff;\n" \
"\n" \
"}\n" \
"\n" \
"QPushButton:checked {\n" \
"\n" \
"background-color: \n" \
" qlinea"
        "rgradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #8ed0fa, stop: 1 #4991c7);\n" \
"\n" \
"border-bottom: 1px solid #3371a0;\n" \
"border-top: 1px solid #9ee8ff;\n" \
"\n" \
"color: #fff;\n" \
"\n" \
"}"
    @pushButton.checkable = true
    @pushButton.autoDefault = false
    @pushButton.default = false
    @pushButton.flat = false

    @verticalLayout_2.addWidget(@pushButton)

    @pushButton_4 = Qt::PushButton.new(@leftMenuFrame)
    @pushButton_4.objectName = "pushButton_4"
    @sizePolicy1.heightForWidth = @pushButton_4.sizePolicy.hasHeightForWidth
    @pushButton_4.sizePolicy = @sizePolicy1
    @pushButton_4.minimumSize = Qt::Size.new(0, 26)
    @pushButton_4.maximumSize = Qt::Size.new(16777215, 26)
    @pushButton_4.font = @font
    @pushButton_4.styleSheet = "QPushButton {\n" \
"\n" \
"background-color: \n" \
" qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #fff, stop: 1 #e5e5e5);\n" \
"\n" \
"border-bottom: 1px solid #afafaf;\n" \
"border-top: 1px solid #e9e9e9;\n" \
"\n" \
"width: 151px;\n" \
"height: 30px;\n" \
"\n" \
"padding: 0;\n" \
"margin: 0;\n" \
"\n" \
"}"
    @pushButton_4.autoDefault = false
    @pushButton_4.default = false
    @pushButton_4.flat = false

    @verticalLayout_2.addWidget(@pushButton_4)

    @verticalSpacer = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Expanding)

    @verticalLayout_2.addItem(@verticalSpacer)

    @dropZoneFrame = Qt::Frame.new(@leftMenuFrame)
    @dropZoneFrame.objectName = "dropZoneFrame"
    @dropZoneFrame.styleSheet = "QFrame {\n" \
"\n" \
"border: 5px dashed  #9a9b9d;\n" \
"border-radius: 20px;\n" \
"\n" \
"}"
    @dropZoneFrame.frameShape = Qt::Frame::StyledPanel
    @dropZoneFrame.frameShadow = Qt::Frame::Raised

    @verticalLayout_2.addWidget(@dropZoneFrame)


    @horizontalLayout.addWidget(@leftMenuFrame)

    @contentAndLineGrid = Qt::Widget.new(@centralWidget)
    @contentAndLineGrid.objectName = "contentAndLineGrid"
    @contentAndLineGrid.styleSheet = "background-image: url(:/root/images/background/linen.jpg);"
    @gridLayout = Qt::GridLayout.new(@contentAndLineGrid)
    @gridLayout.spacing = 0
    @gridLayout.margin = 0
    @gridLayout.objectName = "gridLayout"
    @menuContentDivider = Qt::Frame.new(@contentAndLineGrid)
    @menuContentDivider.objectName = "menuContentDivider"
    @sizePolicy2 = Qt::SizePolicy.new(Qt::SizePolicy::Fixed, Qt::SizePolicy::Expanding)
    @sizePolicy2.setHorizontalStretch(0)
    @sizePolicy2.setVerticalStretch(1)
    @sizePolicy2.heightForWidth = @menuContentDivider.sizePolicy.hasHeightForWidth
    @menuContentDivider.sizePolicy = @sizePolicy2
    @menuContentDivider.minimumSize = Qt::Size.new(1, 0)
    @menuContentDivider.maximumSize = Qt::Size.new(1, 16777215)
    @menuContentDivider.sizeIncrement = Qt::Size.new(0, 0)
    @menuContentDivider.frameShadow = Qt::Frame::Raised
    @menuContentDivider.setFrameShape(Qt::Frame::VLine)

    @gridLayout.addWidget(@menuContentDivider, 0, 0, 3, 1)

    @contentGrid = Qt::GridLayout.new()
    @contentGrid.spacing = 0
    @contentGrid.objectName = "contentGrid"
    @titleLabel_2 = Qt::Label.new(@contentAndLineGrid)
    @titleLabel_2.objectName = "titleLabel_2"
    @font1 = Qt::Font.new
    @font1.pointSize = 32
    @font1.bold = true
    @font1.weight = 75
    @titleLabel_2.font = @font1
    @titleLabel_2.styleSheet = "color: #00a7fb;\n" \
"font-weight: bold;\n" \
"font-size: 32pt;"
    @titleLabel_2.textFormat = Qt::PlainText
    @titleLabel_2.alignment = Qt::AlignLeading|Qt::AlignLeft|Qt::AlignTop

    @contentGrid.addWidget(@titleLabel_2, 1, 1, 1, 1)

    @featuresLabel = Qt::Label.new(@contentAndLineGrid)
    @featuresLabel.objectName = "featuresLabel"
    @font2 = Qt::Font.new
    @font2.pointSize = 16
    @font2.styleStrategy = Qt::Font::PreferAntialias
    @featuresLabel.font = @font2
    @featuresLabel.styleSheet = "color: rgb(154, 155, 157);\n" \
"font-size: 16pt;"
    @featuresLabel.textFormat = Qt::AutoText
    @featuresLabel.alignment = Qt::AlignLeading|Qt::AlignLeft|Qt::AlignTop
    @featuresLabel.wordWrap = true

    @contentGrid.addWidget(@featuresLabel, 3, 1, 1, 1)

    @spacerWest = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @contentGrid.addItem(@spacerWest, 1, 0, 1, 1)

    @spacerSourh = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Expanding)

    @contentGrid.addItem(@spacerSourh, 4, 1, 1, 1)

    @spacerNorth = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Expanding)

    @contentGrid.addItem(@spacerNorth, 0, 1, 1, 1)

    @verticalSpacer_2 = Qt::SpacerItem.new(20, 30, Qt::SizePolicy::Minimum, Qt::SizePolicy::Fixed)

    @contentGrid.addItem(@verticalSpacer_2, 2, 1, 1, 1)

    @spacerEast = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @contentGrid.addItem(@spacerEast, 1, 2, 1, 1)


    @gridLayout.addLayout(@contentGrid, 0, 1, 3, 1)


    @horizontalLayout.addWidget(@contentAndLineGrid)

    mainWindow.centralWidget = @centralWidget
    @statusBar = Qt::StatusBar.new(mainWindow)
    @statusBar.objectName = "statusBar"
    @statusBar.styleSheet = "border-top: 1px solid #c5c5c5;"
    mainWindow.statusBar = @statusBar

    retranslateUi(mainWindow)

    Qt::MetaObject.connectSlotsByName(mainWindow)
    end # setupUi

    def setup_ui(mainWindow)
        setupUi(mainWindow)
    end

    def retranslateUi(mainWindow)
    mainWindow.windowTitle = Qt::Application.translate("MainWindow", "MainWindow", nil, Qt::Application::UnicodeUTF8)
    @pushButton.text = Qt::Application.translate("MainWindow", "PushButton", nil, Qt::Application::UnicodeUTF8)
    @pushButton_4.text = Qt::Application.translate("MainWindow", "PushButton", nil, Qt::Application::UnicodeUTF8)
    @titleLabel_2.text = Qt::Application.translate("MainWindow", "Hello there!", nil, Qt::Application::UnicodeUTF8)
    @featuresLabel.text = Qt::Application.translate("MainWindow", "bla", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(mainWindow)
        retranslateUi(mainWindow)
    end

end

module Ui
    class MainWindow < Ui_MainWindow
    end
end  # module Ui

if $0 == __FILE__
    a = Qt::Application.new(ARGV)
    u = Ui_MainWindow.new
    w = Qt::MainWindow.new
    u.setupUi(w)
    w.show
    a.exec
end
