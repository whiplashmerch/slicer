class Slicer
  class << self

	  def export(model)

	  	# TODO: Move to config
			# unless ENV['OUTPUT_DIR']
				output_dir = "#{Rails.root.to_s}/test/data/slicer"
			# else
			# 	output_dir = ENV['OUTPUT_DIR'].sub(/\/$/, '')
			# end


			name = "#{model.class.name.underscore}_#{model.id}"
			path = "#{output_dir}/#{name}.yml"

			unless File.exists?(path) 
				require 'fileutils'
				# TODO: Move to config
				FileUtils.mkdir_p 'test/data/slicer'
			end

			File.open(path, 'w') do |file|
				file.write( model.to_yaml )
			end
			recursive_yaml(model, has_many_relations(model), path)
			recursive_yaml(model, belongs_to_relations(model), path)
			recursive_yaml(model, manual_relations(model), path)

			puts "Export saved to #{path}"
		end

		# belongs_to, based on existence of an _id suffix in columns
		def belongs_to_relations(model)
			columns = model.class.column_names
			parents = columns.map{ |c| c if c =~ /_id/ }.reject{ |c| c.nil? }
			parents.map!{ |parents| parents.gsub('_id', '') }
		end

		# has_many, based on existence of a xxx_id column in other tables
		def has_many_relations(model)
			column_name = "#{model.class.name.underscore}_id"
			descendents = ActiveRecord::Base.connection.tables
			descendents.reject!{ |table| false unless table.classify.constantize rescue true }
			descendents.reject!{ |table| true unless table.classify.constantize.column_names.include?(column_name) }
		end

		# TODO: Move to config
		def manual_relations(model)
			case model.class.name
			when 'Order'
				[:account_transactions, :billed_rates, :originator, {:customer => :rules},{:items => :originators}, {:order_status_transactions => :user}, {:order_items => :originator}]
			else
				[]
			end
		end

		def recursive_yaml(model, n, path)
			n.each do |k, v|
				if k.is_a? Hash
					# loop nested hashes until we have some a symbol
					recursive_yaml(model,k, path)
				elsif ( k.is_a?(String) || k.is_a?(Symbol) )
					File.open(path, 'a') do |file|
						if v.nil?
							# elements that get called directly, like @order.order_items
							file.write( model.send(k).to_yaml) rescue nil 
						else

							# if its singular, iterate over itself instead of the children
							if k.to_s.singularize == k.to_s
								file.write( model.send(k).send(v).to_yaml ) rescue nil
							end

							# elements that are distant relatives, like @order.order_items.each do |order_item| order_item.originator end
							model.send(k).map { |child| file.write( child.send(v).to_yaml ) } rescue nil
						end
					end
				end
			end
		end

		def import(handle)
	    path="#{Rails.root.to_s}/test/data/slicer/#{handle}.yml"
	    return false unless File.exists?(path)

	    # YAML chokes trying to read classes if they haven't been used yet, so we just touch the classes in the file
	    lines = File.readlines(path).map{ |line| line.gsub(/!ruby\/object:/x, '').gsub("-",'').strip.constantize if line.include?("!ruby/object:")}

	    File.open(path, 'r') do |file|
	      YAML::load_documents(file).flatten.each do |record|
	        # TODO: optionally replace or abort if record already exists. Currently records are silently *not* updated or overwritten
	        record.class.new(record.attributes, :without_protection => true).sneaky_save if record
	      end
	    end 
	    true
		end

end

end