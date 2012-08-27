# Resource require via qt4-qtruby-qtdesigner-fix 
require "Qt4"; require "forms/dir_selection.qrc.rb" 
 
=begin
** Form generated from reading ui file 'dir_selection.ui'
**
** Created: Mo 12. Dez 22:20:17 2011
**      by: Qt User Interface Compiler version 4.6.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

require 'Qt4'

		class Ui_DirSelectionForm < Qt::Widget

    def self.attr_reader(*p_args)
      @children_widgets ||= []
      @children_widgets.concat(p_args)
      super
    end
    def self.children_widgets; @children_widgets - [:extension] end
    def children_widgets; self.class.children_widgets end

		attr_reader :extension
    attr_reader :gridLayout
    attr_reader :iconPlaceholderFolders
    attr_reader :foldersLabel
    attr_reader :addButton
    attr_reader :closeButton
    attr_reader :listStack
    attr_reader :listPage
    attr_reader :gridLayout_4
    attr_reader :folderList
    attr_reader :infoPage
    attr_reader :infoPageGridLayout
    attr_reader :emptyFrame
    attr_reader :gridLayout_5
    attr_reader :centerGridLayout
    attr_reader :verticalSpacer
    attr_reader :horizontalSpacer
    attr_reader :labelWithGlyphLayout
    attr_reader :iconPlaceholderInfo
    attr_reader :listStatusLabel
    attr_reader :horizontalSpacer_2
    attr_reader :verticalSpacer_2
    attr_reader :removeButtonPlaceholder
    attr_reader :editButton
    attr_reader :horizontalSpacer_3

		def setupUi(dirSelectionForm)
		require "#{File.dirname(__FILE__)}/dir_selection.ui.ext.rb";
		@extension = DirSelectionExtUi.new(self, dirSelectionForm)

    if dirSelectionForm.objectName.nil?
        dirSelectionForm.objectName = "dirSelectionForm"
    end
    dirSelectionForm.resize(430, 325)
    dirSelectionForm.minimumSize = Qt::Size.new(410, 310)
    @gridLayout = Qt::GridLayout.new(dirSelectionForm)
    @gridLayout.objectName = "gridLayout"
    @iconPlaceholderFolders = Qt::PushButton.new(dirSelectionForm)
    @iconPlaceholderFolders.objectName = "iconPlaceholderFolders"
    @iconPlaceholderFolders.enabled = true
    @iconPlaceholderFolders.maximumSize = Qt::Size.new(16, 16)
    @iconPlaceholderFolders.focusPolicy = Qt::NoFocus
    @iconPlaceholderFolders.contextMenuPolicy = Qt::NoContextMenu
    icon = Qt::Icon.new
    icon.addPixmap(Qt::Pixmap.new(":/root/images/folder/folder-open-document-music.png"), Qt::Icon::Normal, Qt::Icon::Off)
    @iconPlaceholderFolders.icon = icon
    @iconPlaceholderFolders.flat = true

    @gridLayout.addWidget(@iconPlaceholderFolders, 0, 0, 1, 1)

    @foldersLabel = Qt::Label.new(dirSelectionForm)
    @foldersLabel.objectName = "foldersLabel"
    @foldersLabel.frameShadow = Qt::Frame::Plain
    @foldersLabel.textFormat = Qt::LogText

    @gridLayout.addWidget(@foldersLabel, 0, 1, 1, 6)

    @addButton = Qt::PushButton.new(dirSelectionForm)
    @addButton.objectName = "addButton"
    @addButton.minimumSize = Qt::Size.new(80, 26)
    @addButton.maximumSize = Qt::Size.new(16777215, 16777215)
    icon1 = Qt::Icon.new
    icon1.addPixmap(Qt::Pixmap.new(":/root/images/folder/folder--plus.png"), Qt::Icon::Normal, Qt::Icon::Off)
    @addButton.icon = icon1

    @gridLayout.addWidget(@addButton, 3, 0, 1, 2)

    @closeButton = Qt::PushButton.new(dirSelectionForm)
    @closeButton.objectName = "closeButton"
    @closeButton.minimumSize = Qt::Size.new(60, 26)
    @closeButton.maximumSize = Qt::Size.new(65, 16777215)
    icon2 = Qt::Icon.new
    icon2.addPixmap(Qt::Pixmap.new(":/root/images/button_glyphs/cross-button.png"), Qt::Icon::Normal, Qt::Icon::Off)
    @closeButton.icon = icon2

    @gridLayout.addWidget(@closeButton, 3, 6, 1, 1)

    @listStack = Qt::StackedWidget.new(dirSelectionForm)
    @listStack.objectName = "listStack"
    @listStack.frameShape = Qt::Frame::NoFrame
    @listStack.lineWidth = 1
    @listPage = Qt::Widget.new()
    @listPage.objectName = "listPage"
    @gridLayout_4 = Qt::GridLayout.new(@listPage)
    @gridLayout_4.margin = 0
    @gridLayout_4.objectName = "gridLayout_4"
    @folderList = Qt::ListWidget.new(@listPage)
    @folderList.objectName = "folderList"
    @folderList.enabled = true

    @gridLayout_4.addWidget(@folderList, 0, 0, 1, 1)

    @listStack.addWidget(@listPage)
    @infoPage = Qt::Widget.new()
    @infoPage.objectName = "infoPage"
    @infoPageGridLayout = Qt::GridLayout.new(@infoPage)
    @infoPageGridLayout.margin = 0
    @infoPageGridLayout.objectName = "infoPageGridLayout"
    @emptyFrame = Qt::Frame.new(@infoPage)
    @emptyFrame.objectName = "emptyFrame"
    @emptyFrame.frameShape = Qt::Frame::StyledPanel
    @emptyFrame.frameShadow = Qt::Frame::Sunken
    @gridLayout_5 = Qt::GridLayout.new(@emptyFrame)
    @gridLayout_5.margin = 0
    @gridLayout_5.objectName = "gridLayout_5"
    @gridLayout_5.horizontalSpacing = 6
    @centerGridLayout = Qt::GridLayout.new()
    @centerGridLayout.spacing = 0
    @centerGridLayout.objectName = "centerGridLayout"
    @verticalSpacer = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Expanding)

    @centerGridLayout.addItem(@verticalSpacer, 0, 0, 1, 4)

    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @centerGridLayout.addItem(@horizontalSpacer, 1, 0, 1, 1)

    @labelWithGlyphLayout = Qt::HBoxLayout.new()
    @labelWithGlyphLayout.spacing = 4
    @labelWithGlyphLayout.objectName = "labelWithGlyphLayout"
    @iconPlaceholderInfo = Qt::Label.new(@emptyFrame)
    @iconPlaceholderInfo.objectName = "iconPlaceholderInfo"
    @iconPlaceholderInfo.minimumSize = Qt::Size.new(16, 16)
    @iconPlaceholderInfo.maximumSize = Qt::Size.new(16, 16)
    @iconPlaceholderInfo.textFormat = Qt::PlainText
    @iconPlaceholderInfo.pixmap = Qt::Pixmap.new(":/root/images/notify/information-frame.png")
    @iconPlaceholderInfo.alignment = Qt::AlignCenter

    @labelWithGlyphLayout.addWidget(@iconPlaceholderInfo)

    @listStatusLabel = Qt::Label.new(@emptyFrame)
    @listStatusLabel.objectName = "listStatusLabel"
    @sizePolicy = Qt::SizePolicy.new(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)
    @sizePolicy.setHorizontalStretch(1)
    @sizePolicy.setVerticalStretch(1)
    @sizePolicy.heightForWidth = @listStatusLabel.sizePolicy.hasHeightForWidth
    @listStatusLabel.sizePolicy = @sizePolicy
    @listStatusLabel.minimumSize = Qt::Size.new(0, 14)
    @listStatusLabel.maximumSize = Qt::Size.new(16777215, 14)

    @labelWithGlyphLayout.addWidget(@listStatusLabel)


    @centerGridLayout.addLayout(@labelWithGlyphLayout, 1, 1, 1, 2)

    @horizontalSpacer_2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @centerGridLayout.addItem(@horizontalSpacer_2, 1, 3, 1, 1)

    @verticalSpacer_2 = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Expanding)

    @centerGridLayout.addItem(@verticalSpacer_2, 2, 0, 1, 4)


    @gridLayout_5.addLayout(@centerGridLayout, 0, 0, 1, 1)


    @infoPageGridLayout.addWidget(@emptyFrame, 0, 0, 1, 1)

    @listStack.addWidget(@infoPage)

    @gridLayout.addWidget(@listStack, 1, 0, 1, 7)

    @removeButtonPlaceholder = Qt::Widget.new(dirSelectionForm)
    @removeButtonPlaceholder.objectName = "removeButtonPlaceholder"
    @removeButtonPlaceholder.enabled = true
    @sizePolicy1 = Qt::SizePolicy.new(Qt::SizePolicy::Minimum, Qt::SizePolicy::Fixed)
    @sizePolicy1.setHorizontalStretch(0)
    @sizePolicy1.setVerticalStretch(0)
    @sizePolicy1.heightForWidth = @removeButtonPlaceholder.sizePolicy.hasHeightForWidth
    @removeButtonPlaceholder.sizePolicy = @sizePolicy1
    @removeButtonPlaceholder.minimumSize = Qt::Size.new(80, 26)
    @removeButtonPlaceholder.maximumSize = Qt::Size.new(16777215, 16777215)
    @removeButtonPlaceholder.cursor = Qt::Cursor.new(Qt::ArrowCursor)

    @gridLayout.addWidget(@removeButtonPlaceholder, 3, 2, 1, 1)

    @editButton = Qt::PushButton.new(dirSelectionForm)
    @editButton.objectName = "editButton"
    @editButton.enabled = false
    @editButton.minimumSize = Qt::Size.new(80, 26)
    @editButton.maximumSize = Qt::Size.new(16777215, 16777215)
    icon3 = Qt::Icon.new
    icon3.addPixmap(Qt::Pixmap.new(":/root/images/folder/folder--pencil.png"), Qt::Icon::Normal, Qt::Icon::Off)
    @editButton.icon = icon3

    @gridLayout.addWidget(@editButton, 3, 3, 1, 1)

    @horizontalSpacer_3 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @gridLayout.addItem(@horizontalSpacer_3, 3, 4, 1, 2)


    retranslateUi(dirSelectionForm)
    Qt::Object.connect(@closeButton, SIGNAL('clicked()'), dirSelectionForm, SLOT('close()'))
		Qt::Object.connect(@addButton, SIGNAL('clicked()'), @extension, SLOT('add_button_clicked()'))
		Qt::Object.connect(@folderList, SIGNAL('currentItemChanged(QListWidgetItem*,QListWidgetItem*)'), @extension, SLOT('folder_list_item_changed(QListWidgetItem*,QListWidgetItem*)'))
		Qt::Object.connect(@editButton, SIGNAL('clicked()'), @extension, SLOT('edit_button_clicked()'))

    @listStack.setCurrentIndex(1)


    Qt::MetaObject.connectSlotsByName(dirSelectionForm)
    end # setupUi

    def setup_ui(dirSelectionForm)
        setupUi(dirSelectionForm)
    end

    def retranslateUi(dirSelectionForm)
    dirSelectionForm.windowTitle = Qt::Application.translate("DirSelectionForm", "Folders", nil, Qt::Application::UnicodeUTF8)
    @iconPlaceholderFolders.text = ''
    @foldersLabel.text = Qt::Application.translate("DirSelectionForm", "The following folders will be scanned to find mp3 Albums :", nil, Qt::Application::UnicodeUTF8)
    @addButton.text = Qt::Application.translate("DirSelectionForm", "&Add", nil, Qt::Application::UnicodeUTF8)
    @closeButton.text = Qt::Application.translate("DirSelectionForm", "&Close", nil, Qt::Application::UnicodeUTF8)
    @iconPlaceholderInfo.text = ''
    @listStatusLabel.text = Qt::Application.translate("DirSelectionForm", "The Folder list is empty, use the buttons below to add folders.", nil, Qt::Application::UnicodeUTF8)
    @removeButtonPlaceholder.toolTip = Qt::Application.translate("DirSelectionForm", "&Remove", nil, Qt::Application::UnicodeUTF8)
    @removeButtonPlaceholder.statusTip = Qt::Application.translate("DirSelectionForm", "Su&re ?", nil, Qt::Application::UnicodeUTF8)
    @editButton.text = Qt::Application.translate("DirSelectionForm", "&Edit", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(dirSelectionForm)
        retranslateUi(dirSelectionForm)
    end

end

module Ui
    class DirSelectionForm < Ui_DirSelectionForm
    end
end  # module Ui

if $0 == __FILE__
    a = Qt::Application.new(ARGV)
    u = Ui_DirSelectionForm.new
    w = Qt::Widget.new
    u.setupUi(w)
    w.show
    a.exec
end
