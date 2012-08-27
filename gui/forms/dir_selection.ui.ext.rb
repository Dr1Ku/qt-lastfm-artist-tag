# Project dependencies
require "forms/dir_browse.ui"

require "util/gui_utils"

require "widgets/extended/confirmation_seeking_push_button"
require "widgets/extended/custom_font_widget"

# UI Extension for dir_selection.ui, implements
# a list of folders with the relevant operations
# (add, edit, remove). Uses dir_browse.ui.
class DirSelectionExtUi < CustomFontWidget

	# Public declarations
	public
	
		# Readable attributes
		attr_reader :form

		# Slots declaration
		slots "add_button_clicked()", "remove_button_clicked()", "edit_button_clicked()"
		slots "main_form_closed()"
		slots "folder_list_item_changed(QListWidgetItem*, QListWidgetItem*)"
		
		# Parametrised constructor, initializes the form
		def initialize(p_form, p_parent)
		
			# Assign usual instance vars, reference to form and parent
			@form = p_form
			@parent = p_parent
			super(p_parent)
			
			# Initialize attributes
			@dir_browse_form = nil
					
			# Flag, used once for proper form initialization
			@initialized = false
		end
		
		# Event Handler, fired when the form is closed.
		# Also closes the 'dummy' form used as a parent.
		def closeEvent(p_event)
			parentWidget.close
		end
				
		# Event Handler, fired when the form is shown
		def showEvent(p_event)
      super(p_event)
			
			# Initialize once, reuse state afterwards
			unless @initialized
				@initialized = true
				create_remove_button
			end
			
			# Notify state changed
			state_changed
		end
			
	# Private declarations
	private

		# 'Has Items in Directory List' State
		def state_has_items
			@form.listStack.setCurrentIndex(0)
		end	
		
		# 'Has no Items in Directory List' State
		def state_no_items
			refresh_buttons
			@form.listStack.setCurrentIndex(1)
		end			
		
		# Event Handler, fired when the state of the folder list has changed.
		def state_changed
			@form.folderList.count == 0 ? state_no_items : state_has_items
		end
		
		# Initializer for a custom PushButton-based remove button,
		# which needs to be pushed/acessed via shortcut twice in
		# order to have an effect (e.g. requires a confirmation)
		def create_remove_button
		
			# Get dummy-stored button texts
			normal_text = @form.removeButtonPlaceholder.toolTip
			warn_text = @form.removeButtonPlaceholder.statusTip
			
			# Retrieve normal icon
			normal_icon = Qt::Icon.new do |new_icon|
				new_icon.addPixmap(Qt::Pixmap.new(":/root/images/folder/folder--minus.png"), Qt::Icon::Normal, Qt::Icon::Off)
			end
			
			# Retrieve warn icon
			warn_icon = Qt::Icon.new do |new_icon|
				new_icon.addPixmap(Qt::Pixmap.new(":/root/images/notify/exclamation--frame.png"), Qt::Icon::Normal, Qt::Icon::Off)
			end			
		
			# Create actual button and customize
			@remove_button = ConfirmationSeekingPushButton.new(warn_icon, warn_text, @form, lambda { check_to_remove_row } ) do |button|
				button.enabled = false
				button.setMinimumSize(@form.removeButtonPlaceholder.minimumSize)
				button.text = normal_text
				button.icon = normal_icon
				
				GuiUtils.replace_grid_widget({
					:grid => @form.gridLayout, 
					:old_widget => @form.removeButtonPlaceholder,
					:new_widget => button,
					:row => 3, :col => 2
				})
			end
			
			# Connect clicked signal for the remove button
			Qt::Object.connect(@remove_button, SIGNAL('clicked()'), self, SLOT('remove_button_clicked()'))
		end
		
		# Event Handler, fired when the delete action was confirmed
		# by a renewed click on the delete button.
		def check_to_remove_row
		
			# Check if the currently selected row hasn't changed
			# after the delete action was confirmed. Delete if unchanged
			if @form.folderList.currentRow == @to_delete_row
			
				# Remove from list
				@form.folderList.takeItem(@to_delete_row).dispose
				
				# Reset delete button
				@remove_button.was_confirmed
				
				# Post state changed event
				state_changed
			end
			
		end
		
		# Event Handler, fired when a Folder is marked as to be deleted.
		# Store reference to the item, as the selection might change.
		def remove_button_clicked()
			@to_delete_row = @form.folderList.currentRow
		end		
				
		# Event Handler, fired when the add Folder Button is clicked
		def add_button_clicked
		
			# Eventually create browse form
			create_browse_form
		
			# Show and activate the child window
			show_browse_form
		end
		
		# Event Handler, fired when the Edit Folder Button is clicked
		def edit_button_clicked

			# Set flag for edit mode, store 
			@edited_item = @form.folderList.currentItem
		
			# Show and activate the child window
			show_browse_form(@edited_item.text)
		end
				
		# Event Handler, fired when the folder selection dialog is closed
		def dir_browse_closed
		
			# Get selected path
			selected_path = @dir_browse_ui.path
		
			# Only add folder if its path is valid 
			unless selected_path.nil?
			
				# Store folder list temporarily
				folder_list = @form.folderList
				
				# Check if the path is to be edited and not added
				if @edited_item.nil?
				
					# Add new item, get index
					folder_list.addItem(selected_path)
					new_item = folder_list.item(folder_list.count - 1)			
					
				else

					# If editing, replace text and discard reference
					@edited_item.setText(selected_path)
					new_item = @edited_item
					@edited_item = nil
				end
				
				# Set focus on newly inserted/edited item, post event
				folder_list.setFocus(Qt::MouseFocusReason)
				folder_list.setCurrentItem(new_item)
				state_changed
			end
			
		end	
		
		# Utility methods, refreshes the enabled state
		# of the action buttons (remove, edit), based
		# upon the current state (list has items or not)
		def refresh_buttons
			has_items = (@form.folderList.count != 0)
			
			@remove_button.setEnabled(has_items)
			@form.editButton.setEnabled(has_items)
		end
		
		# Event Handler, fired when an item in the folder list is selected
		def folder_list_item_changed(p_current_item, p_previous_item)
			#@form.folderList.setCurrentItem(p_current_item)
			refresh_buttons
		end		
		
		# Utility method, creates the folder browse dialog, if not present
		def create_browse_form
	
			# Create child form if not present
			if @dir_browse_form.nil?
			
				# Call GUI Utility Method to handle child form creation
				result = GuiUtils.create_child_form({
					:class => Ui_DirBrowseForm,
					:flags => Qt::Tool | Qt::MSWindowsFixedSizeDialogHint, #| Qt::WindowTitleHint | Qt::CustomizeWindowHint, # << no close button
					:base_widget => CustomFontWidget.new(self),
					:show => false
				})

				# Center the newly created form relative to the parent form
				@dir_browse_form = result[:form]
				GuiUtils.center_relative_to({
          :widget => @dir_browse_form,
          :parent => @parent
        })

				# Set closed callbacks for the actual form and its dummy form
				ui = result[:ui]
				handler = lambda { dir_browse_closed }
				ui.closed_callback = handler
				@dir_browse_ui = ui.extension
				@dir_browse_ui.closed_callback = handler
			end	
	
		end
		
		# Utility method, shows the folder browse form
		def show_browse_form(p_starting_path = nil)
		
			# If available as argument, select the path within the Tree View
			@dir_browse_ui.select_path(p_starting_path) unless p_starting_path.nil?
		
			# Show Browse form
			@dir_browse_form.show
			@dir_browse_form.activateWindow		
		end
end