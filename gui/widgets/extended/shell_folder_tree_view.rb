# Load dependencies
require "widgets/extended/fetch_notifying_file_system_model"

# An extended TreeView which displays a tree tied to
# a file system model, allowing only folder selection
class ShellFolderTreeView < Qt::TreeView 

	# Public declarations
	public

		# Parametrized constructor
		# Params: model -- A FileSystemModel or an extended class thereof
		#         change_callback -- Callback, posted when a folder is selected [Optional]
		#					keypress_callback -- Callback, posted when a key is pressed within the tree view [Optional]
		def initialize(p_parent, p_args)
			super(p_parent)
			
			# Initialize fields
			@change_callback = p_args[:change_callback]
			@keypress_callback = p_args[:keypress_callback]
			@model = p_args[:model]
			
			# Check model, needs to be a file system model
			if !@model.is_a?(Qt::FileSystemModel)
				puts "ShellFolderTreeView::initialize -- WARNING: A ShellFolderTreeView requires a Qt::FileSystemModel,"
				puts "                                            reverting to a default file system model."
				
				@model = Qt.FileSystemModel.new(self)
			end
			
			# Initialize properties
			self.wordWrap = true
			self.headerHidden = true
			
			# Set model attributes, hide other columns
			finalize_model
			hide_other_columns
		end
		
		# Event Handler, Keyboard-hungry focus in
		def focusInEvent(p_event)
			super(p_event)
			self.grabKeyboard
		end
		
		# Event Handler, Keyboard-hungry focus out
		def focusOutEvent(p_event)
			super(p_event)
			self.releaseKeyboard
		end
		
		# Event Handler, 
		def keyPressEvent(p_key_event)
			super(p_key_event)

			# Post callback, if assigned
			@keypress_callback.call(p_key_event) unless @keypress_callback.nil?
		end
		
		# Event Handler, fired when the current item changes
		def currentChanged(p_current, p_previous)
			super(p_current, p_previous)
			
			# Post changed callback
			@change_callback.call(p_current) unless @change_callback.nil?
		end
		
	# Private declarations
	private
	
		# Updates the FileSystemModel, so that it only displays folders
		def finalize_model
			@model.setReadOnly(true)
			@model.setFilter(Qt::Dir::NoDotAndDotDot | Qt::Dir::AllDirs)
			@model.setRootPath(Qt::Dir.rootPath)
			
			self.setModel(@model)
		end
	
		# Initializer, hides other columns
		def hide_other_columns
		
			# Hide all other columns
			(@model.columnCount - 1).times do |i|
				self.setColumnHidden(i + 1, true)
			end
			 
			# Resize first column to fit whole width
			self.resizeColumnToContents(0)
			self.setUniformRowHeights(true)					
		end
	
end