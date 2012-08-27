# Resource require via qt4-qtruby-qtdesigner-fix 
require "Qt4"; require "widgets/artist_widget.qrc.rb" 
 
=begin
** Form generated from reading ui file 'artist_widget.ui'
**
** Created: Mo 12. Dez 22:20:17 2011
**      by: Qt User Interface Compiler version 4.6.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

require 'Qt4'

		class Ui_ArtistWidget < Qt::Widget

    def self.attr_reader(*p_args)
      @children_widgets ||= []
      @children_widgets.concat(p_args)
      super
    end
    def self.children_widgets; @children_widgets - [:extension] end
    def children_widgets; self.class.children_widgets end

		attr_reader :extension
    attr_reader :separator
    attr_reader :allFrame
    attr_reader :picture
    attr_reader :artistName
    attr_reader :tagFrame
    attr_reader :tagIcon
    attr_reader :artistTags

		def setupUi(artistWidget)
		require "#{File.dirname(__FILE__)}/artist_widget.ui.ext.rb";
		@extension = ArtistWidgetExtUi.new(self, artistWidget)

    if artistWidget.objectName.nil?
        artistWidget.objectName = "artistWidget"
    end
    artistWidget.resize(180, 118)
    @sizePolicy = Qt::SizePolicy.new(Qt::SizePolicy::Maximum, Qt::SizePolicy::Maximum)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = artistWidget.sizePolicy.hasHeightForWidth
    artistWidget.sizePolicy = @sizePolicy
    artistWidget.minimumSize = Qt::Size.new(0, 0)
    artistWidget.maximumSize = Qt::Size.new(180, 153)
    @separator = Qt::Frame.new(artistWidget)
    @separator.objectName = "separator"
    @separator.geometry = Qt::Rect.new(-1, 88, 182, 16)
    @separator.setFrameShape(Qt::Frame::HLine)
    @separator.setFrameShadow(Qt::Frame::Sunken)
    @allFrame = Qt::Frame.new(artistWidget)
    @allFrame.objectName = "allFrame"
    @allFrame.geometry = Qt::Rect.new(0, 0, 180, 118)
    @sizePolicy1 = Qt::SizePolicy.new(Qt::SizePolicy::Fixed, Qt::SizePolicy::Fixed)
    @sizePolicy1.setHorizontalStretch(0)
    @sizePolicy1.setVerticalStretch(0)
    @sizePolicy1.heightForWidth = @allFrame.sizePolicy.hasHeightForWidth
    @allFrame.sizePolicy = @sizePolicy1
    @allFrame.minimumSize = Qt::Size.new(0, 0)
    @allFrame.maximumSize = Qt::Size.new(180, 148)
    @palette = Qt::Palette.new
    brush = Qt::Brush.new(Qt::Color.new(255, 255, 255, 0))
    brush.style = Qt::SolidPattern
    @palette.setBrush(Qt::Palette::Active, Qt::Palette::Window, brush)
    @palette.setBrush(Qt::Palette::Inactive, Qt::Palette::Window, brush)
    @palette.setBrush(Qt::Palette::Disabled, Qt::Palette::Window, brush)
    @allFrame.palette = @palette
    @allFrame.cursor = Qt::Cursor.new(Qt::ArrowCursor)
    @allFrame.autoFillBackground = true
    @allFrame.frameShape = Qt::Frame::StyledPanel
    @allFrame.frameShadow = Qt::Frame::Sunken
    @picture = Qt::Label.new(@allFrame)
    @picture.objectName = "picture"
    @picture.geometry = Qt::Rect.new(1, 1, 177, 94)
    @sizePolicy1.heightForWidth = @picture.sizePolicy.hasHeightForWidth
    @picture.sizePolicy = @sizePolicy1
    @picture.minimumSize = Qt::Size.new(0, 0)
    @picture.maximumSize = Qt::Size.new(16777215, 16777215)
    @palette1 = Qt::Palette.new
    brush1 = Qt::Brush.new(Qt::Color.new(255, 255, 255, 255))
    brush1.style = Qt::SolidPattern
    @palette1.setBrush(Qt::Palette::Active, Qt::Palette::Base, brush1)
    @palette1.setBrush(Qt::Palette::Active, Qt::Palette::Window, brush1)
    @palette1.setBrush(Qt::Palette::Inactive, Qt::Palette::Base, brush1)
    @palette1.setBrush(Qt::Palette::Inactive, Qt::Palette::Window, brush1)
    @palette1.setBrush(Qt::Palette::Disabled, Qt::Palette::Base, brush1)
    @palette1.setBrush(Qt::Palette::Disabled, Qt::Palette::Window, brush1)
    @picture.palette = @palette1
    @picture.autoFillBackground = true
    @picture.frameShadow = Qt::Frame::Raised
    @picture.textFormat = Qt::PlainText
    @picture.scaledContents = false
    @picture.alignment = Qt::AlignHCenter|Qt::AlignTop
    @artistName = Qt::Label.new(@allFrame)
    @artistName.objectName = "artistName"
    @artistName.geometry = Qt::Rect.new(4, 3, 172, 15)
    @sizePolicy1.heightForWidth = @artistName.sizePolicy.hasHeightForWidth
    @artistName.sizePolicy = @sizePolicy1
    @artistName.minimumSize = Qt::Size.new(172, 15)
    @artistName.maximumSize = Qt::Size.new(172, 15)
    @artistName.cursor = Qt::Cursor.new(Qt::PointingHandCursor)
    @artistName.mouseTracking = true
    @artistName.textFormat = Qt::PlainText
    @artistName.wordWrap = true
    @tagFrame = Qt::Frame.new(artistWidget)
    @tagFrame.objectName = "tagFrame"
    @tagFrame.geometry = Qt::Rect.new(1, 96, 178, 21)
    @tagFrame.maximumSize = Qt::Size.new(178, 21)
    @palette2 = Qt::Palette.new
    @palette2.setBrush(Qt::Palette::Active, Qt::Palette::Base, brush1)
    brush2 = Qt::Brush.new(Qt::Color.new(236, 241, 244, 255))
    brush2.style = Qt::SolidPattern
    @palette2.setBrush(Qt::Palette::Active, Qt::Palette::Window, brush2)
    @palette2.setBrush(Qt::Palette::Inactive, Qt::Palette::Base, brush1)
    @palette2.setBrush(Qt::Palette::Inactive, Qt::Palette::Window, brush2)
    @palette2.setBrush(Qt::Palette::Disabled, Qt::Palette::Base, brush2)
    @palette2.setBrush(Qt::Palette::Disabled, Qt::Palette::Window, brush2)
    @tagFrame.palette = @palette2
    @tagFrame.autoFillBackground = true
    @tagFrame.frameShape = Qt::Frame::NoFrame
    @tagFrame.frameShadow = Qt::Frame::Plain
    @tagFrame.lineWidth = 0
    @tagIcon = Qt::Label.new(@tagFrame)
    @tagIcon.objectName = "tagIcon"
    @tagIcon.geometry = Qt::Rect.new(4, 3, 16, 16)
    @tagIcon.minimumSize = Qt::Size.new(16, 16)
    @tagIcon.maximumSize = Qt::Size.new(16, 16)
    @tagIcon.pixmap = Qt::Pixmap.new(":/root/images/tag/tag-label.png")
    @artistTags = Qt::Label.new(@tagFrame)
    @artistTags.objectName = "artistTags"
    @artistTags.geometry = Qt::Rect.new(25, 5, 151, 13)
    @sizePolicy1.heightForWidth = @artistTags.sizePolicy.hasHeightForWidth
    @artistTags.sizePolicy = @sizePolicy1
    @artistTags.minimumSize = Qt::Size.new(151, 13)
    @artistTags.maximumSize = Qt::Size.new(151, 13)
    @artistTags.cursor = Qt::Cursor.new(Qt::PointingHandCursor)
    @artistTags.mouseTracking = true
    @artistTags.textFormat = Qt::PlainText
    @artistTags.wordWrap = true

    retranslateUi(artistWidget)

    Qt::MetaObject.connectSlotsByName(artistWidget)
    end # setupUi

    def setup_ui(artistWidget)
        setupUi(artistWidget)
    end

    def retranslateUi(artistWidget)
    artistWidget.windowTitle = Qt::Application.translate("ArtistWidget", "Form", nil, Qt::Application::UnicodeUTF8)
    @picture.text = ''
    @artistName.text = ''
    @tagIcon.text = ''
    @artistTags.text = ''
    end # retranslateUi

    def retranslate_ui(artistWidget)
        retranslateUi(artistWidget)
    end

end

module Ui
    class ArtistWidget < Ui_ArtistWidget
    end
end  # module Ui

if $0 == __FILE__
    a = Qt::Application.new(ARGV)
    u = Ui_ArtistWidget.new
    w = Qt::Widget.new
    u.setupUi(w)
    w.show
    a.exec
end
