# FileSystemModel extension which shows a 'busy' animation
# in a given Qt::Label
class FetchNotifyingFileSystemModel < Qt::FileSystemModel

	# Slot declarations
	slots "handle_ready(QModelIndex, int, int)", "handle_busy(QModelIndex, int, int)"

	# Parametrised constructor, initializes fields
	# Params: label -- A QLabel which is to display the loading / loaded (animated) icons
	#         ready_icon -- An (animated) QIcon which is to be displayed when a file system can be issued (ready)
  #         busy_icon -- An (animated) QIcon which is to be displayed when a file system query is ongoing
	def initialize(p_parent, p_args)
	
		# Call superclass constructor
		super(p_parent)
		
		#p_label, p_busy_icon, p_ready_icon
		
		# Set instance vars
		@label = p_args[:label]
		@busy_icon = p_args[:busy_icon]
		@ready_icon = p_args[:ready_icon]
		
		# Connect 'finished loaded' and 'loading' events
		Qt::Object.connect(self, SIGNAL('rowsAboutToBeInserted(QModelIndex, int, int)'), self, SLOT('handle_busy(QModelIndex, int, int)'))
		Qt::Object.connect(self, SIGNAL('rowsInserted(QModelIndex, int, int)'), self, SLOT('handle_ready(QModelIndex, int, int)'))
	end
			
	# Utility method, switches icons, depending on a given state
	def set_icon(p_busy) 
		movie = (p_busy ? @busy_icon : @ready_icon)
		@label.setMovie(movie)
		movie.start
	end		
		
	# Loading finished event, changes icon state to ready
	def handle_ready(p_index, p_start, p_end)
		set_icon(false)	
		
		#puts "    done - loaded #{rowCount(p_index)} folders"
	end
	
	# Loading started event, changes icon state to busy
	def handle_busy(p_index, p_start, p_end)
		set_icon(true)
	
		path = fileInfo(p_index).canonicalFilePath
		#puts "Loading . . . path = '#{path}'"
	end
	
	# Overriden start loading event
	def fetchMore(p_index)
		handle_busy(p_index, nil, nil)
		super(p_index)
	end
		
end # class FetchNotifyingFileSystemModel