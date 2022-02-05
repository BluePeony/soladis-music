module ApplicationHelper

	def full_title (page_title = "")
		base_title = "Soladis-Music"
		if page_title == ""
			return base_title
		else
			return "#{page_title} | #{base_title}"
		end
	end

	def current_year
		return Time.now.year
	end

	def nested_dropdown(items)
    result = []
    items.map do |item, sub_items|
        result << [(" - " * item.depth) + item.title, item.id]
        result += nested_dropdown(sub_items) unless sub_items.blank?        
    end
    result
	end

end
