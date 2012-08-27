# Resource require via qt4-qtruby-qtdesigner-fix 
require "Qt4"; require "widgets/notification_widget.qrc.rb" 
 
=begin
** Form generated from reading ui file 'notification_widget.ui'
**
** Created: Mo 12. Dez 22:20:17 2011
**      by: Qt User Interface Compiler version 4.6.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

require 'Qt4'

		class Ui_NotificationWidget < Qt::Widget

    def self.attr_reader(*p_args)
      @children_widgets ||= []
      @children_widgets.concat(p_args)
      super
    end
    def self.children_widgets; @children_widgets - [:extension] end
    def children_widgets; self.class.children_widgets end

		attr_reader :extension
    attr_reader :gridLayout
    attr_reader :emphasisLine
    attr_reader :statusIcon
    attr_reader :statusLabel

		def setupUi(notificationWidget)
		require "#{File.dirname(__FILE__)}/notification_widget.ui.ext.rb";
		@extension = NotificationWidgetExtUi.new(self, notificationWidget)

    if notificationWidget.objectName.nil?
        notificationWidget.objectName = "notificationWidget"
    end
    notificationWidget.resize(582, 23)
    notificationWidget.maximumSize = Qt::Size.new(16777215, 23)
    @gridLayout = Qt::GridLayout.new(notificationWidget)
    @gridLayout.spacing = 0
    @gridLayout.margin = 0
    @gridLayout.objectName = "gridLayout"
    @emphasisLine = Qt::Frame.new(notificationWidget)
    @emphasisLine.objectName = "emphasisLine"
    @sizePolicy = Qt::SizePolicy.new(Qt::SizePolicy::MinimumExpanding, Qt::SizePolicy::Fixed)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = @emphasisLine.sizePolicy.hasHeightForWidth
    @emphasisLine.sizePolicy = @sizePolicy
    @emphasisLine.minimumSize = Qt::Size.new(0, 0)
    @emphasisLine.frameShadow = Qt::Frame::Plain
    @emphasisLine.lineWidth = 3
    @emphasisLine.midLineWidth = 22
    @emphasisLine.setFrameShape(Qt::Frame::HLine)

    @gridLayout.addWidget(@emphasisLine, 0, 0, 1, 2)

    @statusIcon = Qt::Label.new(notificationWidget)
    @statusIcon.objectName = "statusIcon"
    @sizePolicy1 = Qt::SizePolicy.new(Qt::SizePolicy::Maximum, Qt::SizePolicy::Maximum)
    @sizePolicy1.setHorizontalStretch(0)
    @sizePolicy1.setVerticalStretch(0)
    @sizePolicy1.heightForWidth = @statusIcon.sizePolicy.hasHeightForWidth
    @statusIcon.sizePolicy = @sizePolicy1
    @statusIcon.minimumSize = Qt::Size.new(21, 20)
    @statusIcon.autoFillBackground = true
    @statusIcon.textFormat = Qt::PlainText
    @statusIcon.margin = 2

    @gridLayout.addWidget(@statusIcon, 1, 0, 1, 1)

    @statusLabel = Qt::Label.new(notificationWidget)
    @statusLabel.objectName = "statusLabel"
    @sizePolicy.heightForWidth = @statusLabel.sizePolicy.hasHeightForWidth
    @statusLabel.sizePolicy = @sizePolicy
    @statusLabel.minimumSize = Qt::Size.new(0, 20)
    @statusLabel.autoFillBackground = true
    @statusLabel.textFormat = Qt::PlainText

    @gridLayout.addWidget(@statusLabel, 1, 1, 1, 1)


    retranslateUi(notificationWidget)

    Qt::MetaObject.connectSlotsByName(notificationWidget)
    end # setupUi

    def setup_ui(notificationWidget)
        setupUi(notificationWidget)
    end

    def retranslateUi(notificationWidget)
    notificationWidget.windowTitle = Qt::Application.translate("NotificationWidget", "Form", nil, Qt::Application::UnicodeUTF8)
    @statusIcon.text = ''
    @statusLabel.accessibleDescription = Qt::Application.translate("NotificationWidget", ":no_net_retry=No internet connection found, retrying.|:offline=You are not connected to the Internet, use the 'Retry' button when online again.", nil, Qt::Application::UnicodeUTF8)
    @statusLabel.text = ''
    end # retranslateUi

    def retranslate_ui(notificationWidget)
        retranslateUi(notificationWidget)
    end

end

module Ui
    class NotificationWidget < Ui_NotificationWidget
    end
end  # module Ui

if $0 == __FILE__
    a = Qt::Application.new(ARGV)
    u = Ui_NotificationWidget.new
    w = Qt::Widget.new
    u.setupUi(w)
    w.show
    a.exec
end
