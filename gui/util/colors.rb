# Static class, containing Qt::Color constants
class Colors

	# Public declarations
	public
	
		# Public 'getter', retrieves the list of notification colors available,
		# use notify_<type> (see below) to get a particular color
		def self.notification_types
			[:ok, :info, :warn, :error]
		end
			
	# Private declarations
	private
	
		# A sort-of static initializer
		self.notification_types.each do |type|
		
			# Color initializer, paste custom colors here
			color = { 
				:ok   =>  { :back => "C5FFC0", :dark => "ADE8AA" },
				:info =>  { :back => "E7F7FF", :dark => "C8EAFB" },
				:warn =>  { :back => "FFF7B3", :dark => "FFCD0B" },
				:error => { :back => "F9E5E6", :dark => "E8AAAD" }
			}

			# Define notify_ok, notify_warn [...] methods
			# Meta to the rescue !
			(class << self; self; end).instance_eval do
				define_method "notify_#{type.to_s}" do |p_sym|
					p_sym ||= :back
					Qt::Color.new("\##{color[type][p_sym]}")
				end
			end
			
		end	# 'initializer'
		
end # class Colors