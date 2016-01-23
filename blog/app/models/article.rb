class Article < ActiveRecord::Base
	belongs_to :user
	has_many :comments
	validates :title,presence: true, uniqueness: true
	validates :body,presence: true, length: { minimum: 20}
	before_save :set_visits_count

	 has_attached_file :cover, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
 	 validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/
	
	def update_visits_count
		self.update(visits_count: self.visits_count + 1)
	end
	private
	def set_visits_count
		self.visits_count ||= 0
	end
end
