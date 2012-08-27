# Resource require via qt4-qtruby-qtdesigner-fix 
require "Qt4"; require "forms/tools.qrc.rb" 
 
=begin
** Form generated from reading ui file 'tools.ui'
**
** Created: Mo 12. Dez 22:20:17 2011
**      by: Qt User Interface Compiler version 4.6.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

require 'Qt4'

		class Ui_ToolsWidget < Qt::Widget

    def self.attr_reader(*p_args)
      @children_widgets ||= []
      @children_widgets.concat(p_args)
      super
    end
    def self.children_widgets; @children_widgets - [:extension] end
    def children_widgets; self.class.children_widgets end

		attr_reader :extension
    attr_reader :horizontalLayout
    attr_reader :gridLayout

		def setupUi(toolsWidget)
		require "#{File.dirname(__FILE__)}/tools.ui.ext.rb";
		@extension = ToolsExtUi.new(self, toolsWidget)

    if toolsWidget.objectName.nil?
        toolsWidget.objectName = "toolsWidget"
    end
    toolsWidget.resize(745, 464)
    toolsWidget.minimumSize = Qt::Size.new(745, 464)
    toolsWidget.maximumSize = Qt::Size.new(16777215, 16777215)
    @horizontalLayout = Qt::HBoxLayout.new(toolsWidget)
    @horizontalLayout.objectName = "horizontalLayout"
    @gridLayout = Qt::GridLayout.new()
    @gridLayout.objectName = "gridLayout"

    @horizontalLayout.addLayout(@gridLayout)


    retranslateUi(toolsWidget)

    Qt::MetaObject.connectSlotsByName(toolsWidget)
    end # setupUi

    def setup_ui(toolsWidget)
        setupUi(toolsWidget)
    end

    def retranslateUi(toolsWidget)
    toolsWidget.windowTitle = Qt::Application.translate("ToolsWidget", "Form", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(toolsWidget)
        retranslateUi(toolsWidget)
    end

end

module Ui
    class ToolsWidget < Ui_ToolsWidget
    end
end  # module Ui

if $0 == __FILE__
    a = Qt::Application.new(ARGV)
    u = Ui_ToolsWidget.new
    w = Qt::Widget.new
    u.setupUi(w)
    w.show
    a.exec
end
