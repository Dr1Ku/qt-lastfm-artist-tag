# Resource require via qt4-qtruby-qtdesigner-fix 
require "Qt4"; require "forms/dir_browse.qrc.rb" 
 
=begin
** Form generated from reading ui file 'dir_browse.ui'
**
** Created: Mo 12. Dez 22:20:17 2011
**      by: Qt User Interface Compiler version 4.6.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

require 'Qt4'

		class Ui_DirBrowseForm < Qt::Widget

    def self.attr_reader(*p_args)
      @children_widgets ||= []
      @children_widgets.concat(p_args)
      super
    end
    def self.children_widgets; @children_widgets - [:extension] end
    def children_widgets; self.class.children_widgets end

		attr_reader :extension
    attr_reader :gridLayout
    attr_reader :okButton
    attr_reader :cancelButton
    attr_reader :iconPlaceholderDir
    attr_reader :directoryEditPlaceholder
    attr_reader :folderListPlaceholder

		def setupUi(dirBrowseForm)
		require "#{File.dirname(__FILE__)}/dir_browse.ui.ext.rb";
		@extension = DirBrowseExtUi.new(self, dirBrowseForm)

    if dirBrowseForm.objectName.nil?
        dirBrowseForm.objectName = "dirBrowseForm"
    end
    dirBrowseForm.windowModality = Qt::ApplicationModal
    dirBrowseForm.resize(380, 355)
    @sizePolicy = Qt::SizePolicy.new(Qt::SizePolicy::Maximum, Qt::SizePolicy::Maximum)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = dirBrowseForm.sizePolicy.hasHeightForWidth
    dirBrowseForm.sizePolicy = @sizePolicy
    dirBrowseForm.minimumSize = Qt::Size.new(380, 355)
    @gridLayout = Qt::GridLayout.new(dirBrowseForm)
    @gridLayout.objectName = "gridLayout"
    @okButton = Qt::PushButton.new(dirBrowseForm)
    @okButton.objectName = "okButton"
    @okButton.enabled = false
    @okButton.minimumSize = Qt::Size.new(170, 26)
    @okButton.maximumSize = Qt::Size.new(16777215, 16777215)
    icon = Qt::Icon.new
    icon.addPixmap(Qt::Pixmap.new(":/root/images/folder/folder-horizontal-open.png"), Qt::Icon::Normal, Qt::Icon::Off)
    @okButton.icon = icon

    @gridLayout.addWidget(@okButton, 2, 0, 1, 2)

    @cancelButton = Qt::PushButton.new(dirBrowseForm)
    @cancelButton.objectName = "cancelButton"
    @cancelButton.minimumSize = Qt::Size.new(170, 26)
    @cancelButton.maximumSize = Qt::Size.new(16777215, 16777215)
    icon1 = Qt::Icon.new
    icon1.addPixmap(Qt::Pixmap.new(":/root/images/button_glyphs/cross-button.png"), Qt::Icon::Normal, Qt::Icon::Off)
    @cancelButton.icon = icon1

    @gridLayout.addWidget(@cancelButton, 2, 2, 1, 1)

    @iconPlaceholderDir = Qt::Label.new(dirBrowseForm)
    @iconPlaceholderDir.objectName = "iconPlaceholderDir"
    @iconPlaceholderDir.maximumSize = Qt::Size.new(16, 16)
    @iconPlaceholderDir.scaledContents = false

    @gridLayout.addWidget(@iconPlaceholderDir, 0, 0, 1, 1)

    @directoryEditPlaceholder = Qt::Widget.new(dirBrowseForm)
    @directoryEditPlaceholder.objectName = "directoryEditPlaceholder"
    @directoryEditPlaceholder.minimumSize = Qt::Size.new(0, 24)

    @gridLayout.addWidget(@directoryEditPlaceholder, 0, 1, 1, 2)

    @folderListPlaceholder = Qt::Widget.new(dirBrowseForm)
    @folderListPlaceholder.objectName = "folderListPlaceholder"

    @gridLayout.addWidget(@folderListPlaceholder, 1, 0, 1, 3)

		Qt::Widget.setTabOrder(@okButton, @cancelButton)

    retranslateUi(dirBrowseForm)
		Qt::Object.connect(@cancelButton, SIGNAL('clicked()'), @extension, SLOT('cancel_button_clicked()'))
    Qt::Object.connect(@okButton, SIGNAL('clicked()'), dirBrowseForm, SLOT('close()'))

    Qt::MetaObject.connectSlotsByName(dirBrowseForm)
    end # setupUi

    def setup_ui(dirBrowseForm)
        setupUi(dirBrowseForm)
    end

    def retranslateUi(dirBrowseForm)
    dirBrowseForm.windowTitle = Qt::Application.translate("DirBrowseForm", "  Select Folder", nil, Qt::Application::UnicodeUTF8)
    @okButton.text = Qt::Application.translate("DirBrowseForm", "&Select Folder", nil, Qt::Application::UnicodeUTF8)
    @cancelButton.text = Qt::Application.translate("DirBrowseForm", "&Cancel", nil, Qt::Application::UnicodeUTF8)
    @iconPlaceholderDir.text = ''
    @directoryEditPlaceholder.toolTip = Qt::Application.translate("DirBrowseForm", "Choose a folder from below or paste a Path in this edit box", nil, Qt::Application::UnicodeUTF8)
    @directoryEditPlaceholder.statusTip = Qt::Application.translate("DirBrowseForm", "Path is invalid, try again!", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(dirBrowseForm)
        retranslateUi(dirBrowseForm)
    end

end

module Ui
    class DirBrowseForm < Ui_DirBrowseForm
    end
end  # module Ui

if $0 == __FILE__
    a = Qt::Application.new(ARGV)
    u = Ui_DirBrowseForm.new
    w = Qt::Widget.new
    u.setupUi(w)
    w.show
    a.exec
end
