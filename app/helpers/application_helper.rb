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
end
