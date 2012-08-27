# Project dependencies
require "forms/dir_selection.ui"
require "forms/tools.ui"

require "util/gui_utils"

require "widgets/artist_widget.ui"
require "widgets/notification_widget.ui"
require "tools/tool_collection"

require "widgets/extended/custom_font_widget"
require "widgets/extended/resize_adaptable_grid"

require "controller/last_fm_api_controller"
require "controller/network_connection_controller"

class MainWindowExtUi < CustomFontWidget

	# Public declarations
	public

    # Include log4r
    include Logging

		# Slots declaration
		slots "dir_modify_clicked()", "tools_clicked()"
		
		def initialize(p_form, p_parent)
			@form = p_form
			@parent = p_parent
			super(p_parent)

      # Assign attributes
      @loading_icon = Qt::Movie.new(":/root/images/preloaders/24.gif", Qt::ByteArray.new, @form) do |gif|
        gif.setCacheMode(Qt::Movie::CacheAll)
			end

			# Initialize attributes
			@dir_selection_form = nil

      @tools_form = nil
      @tools = nil

      @current_notification = nil
      @adaptable_grid = nil
		end
		
		# Utility method, creates a notification with the given parameters.
		# Params: type -- The notification type (one of [:warn, :info, :ok, :error])
    #         text -- The text of the notification
    #
    #         vanish_in -- Nil by default (sticky notification), pass
    #                      a duration in seconds and the notification
    #                      will be destroyed after the supplied 'x' seconds.
		def issue_notification(p_args)

      # Remove other notifications, first child is the VBoxLayout
      @form.statusBar.removeWidget(@current_notification[:form]) unless @current_notification.nil?

      # Create new notification
			notification = GuiUtils.create_child_form({
				:class => Ui_NotificationWidget,
				:base_widget => CustomFontWidget.new(self),
				:show => false
			})

      # Set parameters for newly created notification -- type, text
			notification[:ui].extension.type = p_args[:type]
			notification[:ui].extension.text = p_args[:text]

      # Check if the notification is sticky or not
      unless p_args[:vanish_in].nil?

        # Set parameters for newly created notification -- type, text
        notification[:ui].extension.vanish_after(
          p_args[:vanish_in],
          lambda { @form.statusBar.removeWidget(notification[:form]) }
        )
      end

      # Update reference
      @current_notification = notification

      # Add notification, strech 1 (true)
			@form.statusBar.addWidget(notification[:form], 1)
    end

    def update_notification(p_args)
      @current_notification[:ui].extension.type = p_args[:type]
      @current_notification[:ui].extension.text = p_args[:text]
    end

    def show_loading_tab(p_title_idx)
      @form.iconPlaceholder.setMovie(@loading_icon)
      @loading_icon.start
      @form.mainTabs.setTabText(0, @form.mainTabs.tabText(p_title_idx))
      @form.mainTabs.setCurrentIndex(0)
    end

    def resizeEvent(p_event)
      super(p_event)
      @adaptable_grid.parent_resized unless @adaptable_grid.nil?
    end

		def showEvent(p_event)
      super(p_event)

     LastFmAPIController.new(self).go

      s = "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN' 'http://www.w3.org/TR/REC-html40/strict.dtd'><html><head><meta name='qrichtext' content='1' /><style type='text/css'>p, li { white-space: pre-wrap; }</style></head><body style=' font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;'><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>Welcome to &lt;BadaBing&gt;, glad to have you here!</span></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>This is a short list with what you can expect to </span></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>achieve by using this small application :</span></p><p style='-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-size:16pt;'></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>— Get a overview of your current music collection,</span></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>    including </span><span style=' font-size:16pt; font-weight:600;'>artists</span><span style=' font-size:16pt;'>, their multiple </span><span style=' font-size:16pt; font-weight:600;'>genres</span><span style=' font-size:16pt;'> and </span><span style=' font-size:16pt; font-weight:600;'>albums</span></p><p style='-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-size:16pt;'></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>— Better </span><span style=' font-size:16pt; font-weight:600;'>organize</span><span style=' font-size:16pt;'> the collection using simple tools</span></p><p style='-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-size:16pt;'></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>— Instantly </span><span style=' font-size:16pt; font-weight:600;'>share</span><span style=' font-size:16pt;'> music over your local network with</span></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>    friends, </span><span style=' font-size:16pt; font-weight:600;'>backup</span><span style=' font-size:16pt;'> your collection’s structure online </span></p></body></html>"
      @form.featuresLabel.text = s

#      begin
#        require "util/file_system_utils"
#        log.debug FileSystemUtils::same_parent_folder(
#          "M:/!!!##Y'ALL SORT THIS HERE MUZ/g/2006 - Stop the clocks/CD1",
#          "M:/!!!##Y'ALL SORT THIS HERE MUZ/g/2006 - Stop the clocks/CD2"
#        )
#
#        log.debug FileSystemUtils::same_parent_folder(
#          "D:/!!!##Y'ALL SORT THIS HERE MUZ/g/The Clash/CD2",
#          "M:/!!!##Y'ALL SORT THIS HERE MUZ/g/2006 - Stop the clocks/CD1"
#        )
#
#        log.debug FileSystemUtils::same_parent_folder(
#          "D:/!!!##Y'ALL SORT THIS HERE MUZ/g/The Clash/CD1",
#          "D:/!!!##Y'ALL SORT THIS HERE MUZ/g/2006 - Stop the clocks/CD1"
#        )
#
#        log.debug FileSystemUtils::same_parent_folder(
#          "M:/!!!##Y'ALL SORT THIS HERE MUZ/g/The Clash/CD1",
#          "M:/!!!##Y'ALL SORT THIS HERE MUZ/g/2006 - Stop the clocks/CD2"
#        )
#
#        log.debug FileSystemUtils::same_parent_folder(
#          "M:/!!!##Y'ALL SORT THIS HERE MUZ/g/The Clash/CD1",
#          "M:/!!!##Y'ALL SORT THIS HERE MUZ/g/The Clash/CD2"
#        )
#
#        log.debug FileSystemUtils::same_parent_folder(
#          "M:/muzicaOana/Iris",
#          "M:/repos/niche/conf"
#        )
#
#      rescue Exception => e
#        log.error e
#      end

      #show_loading_tab(1)
      #issue_notification({
      #  :type => :info,
      #        :text => "Just a little something to show you who I am"
      #})

#      @adaptable_grid = ResizeAdaptableGrid.new({
#        :parent => @form.artistTagTab,
#        :item_width  => 180,
#        :item_height => 153
#      })
#
#      60.times do |i|
#        a = GuiUtils.create_child_form({
#          :class => Ui_ArtistWidget,
#          :flags => Qt::Popup,
#          :base_widget => CustomFontWidget.new(self),
#        })
#
#        a[:ui].extension.name = "bmakl-#{i} !"
#        a[:ui].extension.tags = ("Mahuto gijaro, speka now ! #{i}")
#
#        @adaptable_grid.add_widget(a[:form])
#      end

      require "id3"
      require "iconv"

      f = "M:/!!!##Y'ALL SORT THIS HERE MUZ/Breakage - Astro cat.mp3"
      f_ = "M:/!!!##Y'ALL SORT THIS HERE MUZ/311 - 02 - Prisoner.mp3"

#<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN' 'http://www.w3.org/TR/REC-html40/strict.dtd'><html><head><meta name='qrichtext' content='1' /><style type='text/css'>p, li { white-space: pre-wrap; }</style></head><body style=' font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;'><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>Welcome to &lt;BadaBing&gt;, glad to have you here!</span></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>This is a short list with what you can expect to </span></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>achieve by using this small application :</span></p><p style='-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-size:16pt;'></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>— Get a overview of your current music collection,</span></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>    including </span><span style=' font-size:16pt; font-weight:600;'>artists</span><span style=' font-size:16pt;'>, their multiple </span><span style=' font-size:16pt; font-weight:600;'>genres</span><span style=' font-size:16pt;'> and </span><span style=' font-size:16pt; font-weight:600;'>albums</span></p><p style='-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-size:16pt;'></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>— Better </span><span style=' font-size:16pt; font-weight:600;'>organize</span><span style=' font-size:16pt;'> the collection using simple tools</span></p><p style='-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-size:16pt;'></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>— Instantly </span><span style=' font-size:16pt; font-weight:600;'>share</span><span style=' font-size:16pt;'> music over your local network with</span></p><p style=' margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;'><span style=' font-size:16pt;'>    friends, </span><span style=' font-size:16pt; font-weight:600;'>backup</span><span style=' font-size:16pt;'> your collection’s structure online </span></p></body></html>


      x = ID3.hasID3tag?(f)
     pp x
#
#      t = ID3::Tag2.new()
#      t.read(f_)
#      pp t
#      pp t.keys
#      pp t.flags
#      ttt = t['CONTENTTYPE'].raw
#      w = Iconv.iconv("UTF-8//IGNORE", "UTF-16BE", ttt)

    end

	# Private declarations
	private
			
		def dir_modify_clicked

      @dir_selection_form = GuiUtils.activate_or_create_child_form(
        @dir_selection_form,

        {
          :class => Ui_DirSelectionForm,
          :flags => Qt::ToolType,
          :base_widget => CustomFontWidget.new(self),
          :position => [@parent.frame_size.width + @parent.x, @parent.y]
        }
      )
    end

    def tools_clicked

#      @tools_form = GuiUtils.activate_or_create_child_form(
#        @tools_form,
#
#        {
#          :class => Ui_ToolsWidget,
#          :base_widget => CustomFontWidget.new(self)
#        }
#      )
#
#      @tools = ToolCollection.new(@tools_form) if @tools.nil?
#
#      aggregate = @tools.get_tool(:aggregate)
#      @tools_form.children.first.initialize_and_add_tool(aggregate)
    end
	
end