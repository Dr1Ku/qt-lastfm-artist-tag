# Project dependencies
require "gui/util/gui_utils"
require "forms/dir_selection.ui"

require "widgets/extended/shell_folder_tree_view"
require "widgets/extended/line_edit_with_hint"

# UI Extension for dir_browse.ui, implements
# an extended folder selection dialog.
class DirBrowseExtUi < CustomFontWidget

	# Public declarations
	public

		# Slots declaration
		slots "cancel_button_clicked()"
		slots "tree_expanded(QModelIndex)"
		
		# Readable attributes
		attr_reader :path
		
		# Accessible attributes
		attr_accessor :closed_callback
							
		# Parametrized constructor, initializes fields based
		# on the given parameters (associated form and its parent)
		def initialize(p_form, p_parent)
		
			# Call base class constructor
			super(p_parent)
			
			# Initialize form and parent (MainWindow)
			@form = p_form
			@parent = p_parent
			
			# Initialize attributes
			@closed_callback = nil
			@intialized = false
			
			# Retrieve Icons from resource file, stored as 'movies' since an animated GIF is also loaded
			@warn_icon = Qt::Movie.new(":/root/images/notify/exclamation--frame.png", Qt::ByteArray.new, @form)
			@folder_icon  = Qt::Movie.new(":/root/images/folder/folder-horizontal-open.png", Qt::ByteArray.new, @form)

      # TODO: extract to utils

			@loading_icon = Qt::Movie.new(":/root/images/preloaders/16.gif", Qt::ByteArray.new, @form) do |gif|
				gif.setCacheMode(Qt::Movie::CacheAll)
			end				
													
			# Initialize environment var
			@is_win32 = !Qt::SysInfo.windowsVersion.nil? # TODO: Eventually path mechanics, combine
		end
		
		# Event Override, fired when the form is shown
		def showEvent(p_event)
		
			# Only initialize form once, reuse state afterwards
			unless @initialized
				@initialized = true
				
				create_path_edit
				create_shell_tree_view
			end
			
		end
		
		# Public Helper Method, helps to edit a given
		# Path by selecting it within the Tree View.
		# Forwards the event to a proper handler.
		def select_path(p_path)
			check_path(p_path)
		end
				
		# Event Handler, fired when the form closes.
		# Forwards the event to an eventual listener
		def closeEvent(p_event)
		
			# Poorman's mutex
			@form.closed_callback_handled = true
			@closed_callback.call if @closed_callback.is_a? Proc
		end
						
	# Private declarations
	private
	
		# Utility method, ensures that this form 
		# as well as the eventual dummy form get closed
		def close_and_cleanup
			self.close
			@parent.close
		end		
					
		# Initializer, creates a shell tree view which browses for folders
		def create_shell_tree_view
		
			# Create file system model for Shell Tree View
			file_system_model = FetchNotifyingFileSystemModel.new(
				@form, 
				{ 
				  :label => @form.iconPlaceholderDir, 
				  :ready_icon => @folder_icon,
					:busy_icon => @loading_icon
				}
			)
		
			# Create Shell Tree View
			@shell_tree_view = ShellFolderTreeView.new(
				@parent, 
				{ 
					:model => file_system_model,
				  :change_callback => lambda { |path| path_changed(path) },
					:keypress_callback => lambda { |key| key_clicked(key) }
				}
			)
		
			# Replace placeholder with actual Shell Tree View
			GuiUtils.replace_grid_widget({
				:grid => @form.gridLayout, 
				:old_widget => @form.folderListPlaceholder,
				:new_widget => @shell_tree_view,
				:row => 1, :col => 0,
				:col_span => 3
			})
		end
			
		# Initializer, creates a LineEditWithHint to show the current path
		def create_path_edit
		
			# Create actual Path edit -- LineEditWithHint
			@path_edit = Qt::LineEditWithHint.new(
				@form.directoryEditPlaceholder.toolTip, @parent,
				{ 
					:validate_callback => lambda { |path| check_path(path) },
					:done_callback => lambda { set_folder_icon(false) },
				  :warn_text => @form.directoryEditPlaceholder.statusTip 
				}
			)
				
			# 'Inherit' minimum size
			@path_edit.minimumSize = @form.directoryEditPlaceholder.minimumSize
			@path_edit.prepare_for_immediate_keypress
			
			# Remove placeholder and add actual (extended) widget
			GuiUtils.replace_grid_widget({
				:grid => @form.gridLayout, 
				:old_widget => @form.directoryEditPlaceholder,
				:new_widget => @path_edit,
				:row => 0, :col => 1,
				:col_span => 2
			})
		end
		
		# Event Handler, fired when the user presses a key within the Shell Tree View
		def key_clicked(p_key_event)
		
			# Forward event to specialized handlers, if the key matches
			close_and_cleanup if p_key_event.key == Qt::Key_Return 
			emit(cancel_button_clicked) if p_key_event.key == Qt::Key_Escape
		end
		
		# Event Handler, fired when the user clicks the Cancel Button
		def cancel_button_clicked
			@path = nil
			close_and_cleanup
		end		
		
		# Utility Method, checks if a given path inputed in the LineEdit
		# exists. If so, navigates to it. Else, displays a notification
		def check_path(p_path)
		
			# Try to create a path out of the given text, store result
			dir = Qt::Dir.new(p_path)
			result = dir.exists
			
			# Check if it's an existing path
			if result
				
				# Get canonical path, index of path within the FileSystem TreeView
				@path = dir.canonicalPath
				idx = @shell_tree_view.model.index(@path)
				
				# Select the parsed path, scroll to it
				scroll_to_index(idx)
				
				# Update combo box
				path_changed(idx)
			else
				set_folder_icon(true)
			end
			
			# Return result
			result
		end
		
		# Helper Method, scrolls the Shell Tree View to the given idx, selecting it as well
		def scroll_to_index(p_idx)
			@shell_tree_view.selectionModel.select(p_idx, Qt::ItemSelectionModel::ClearAndSelect)
			@shell_tree_view.selectionModel.setCurrentIndex(p_idx, Qt::ItemSelectionModel::ClearAndSelect)
			@shell_tree_view.scrollTo(p_idx, Qt::AbstractItemView::PositionAtCenter)
			@shell_tree_view.setFocus(Qt::TabFocusReason)				
		end
		
		# Helper Method, sets the folder icon either to a warn or
		# a normal state, depending on the passed argument
		def set_folder_icon(p_is_warn_state)
			movie = (p_is_warn_state ? @warn_icon : @folder_icon)
			@form.iconPlaceholderDir.setMovie(movie)
			movie.start
		end
						
		# Event Handler, reacts to a click on the TreeView
		# containing the available drives and their directories
		def path_changed(p_index)
		
			# Enable Ok Button, release Keyboard from Line Edit
			@form.okButton.setEnabled(true)
		
			# Get Path for the clicked File
			@path = @shell_tree_view.model.fileInfo(p_index).canonicalFilePath
			
			# Reverse slashes if on Windows, looks more "native"
			@path.gsub!("/", "\\") unless @path.nil? || !@is_win32 
			
			# Set text, if valid
			@path_edit.setText(@path) if @path.is_a?(String)
		end
		
end # class DirBrowseExtUi

# Inject new methods into Ui_DirBrowseForm
class Ui_DirBrowseForm

	# Accessible attributes, callback *must* be the same as
	# DirBrowseExtUi.closed_callback, to ensure uniform 
	# behaviour. The flag is used as a poorman's mutex,
	# the closed events for the DirBrowseExtUi's Widget
	# and this widget would be called successively if not
	# for the flag.
	attr_accessor :closed_callback, :closed_callback_handled
	
	# Custom Event Handler, tailored for a WindowStateChangeEvent, namely a WindowUnblocked event,
	# e.g. a monkeypatch on the widget's 'X' button (since the window is ApplicationModel), couldn't
	# think of another way of connecting the event since closeEvent doesn't get called.
	def event(p_event)
	
		# Handle event only if it hasn't been handled and if it's an event we're after. Else, reset flag 
		if !@closed_callback_handled && @closed_callback.is_a?(Proc) &&
		   p_event.is_a?(Qt::WindowStateChangeEvent) && p_event.type.value == Qt::Event::WindowUnblocked	  
			 
			@closed_callback.call
		else
			@closed_callback_handled = false
		end
		
	end

end # class Ui_DirBrowse