class Article < ActiveRecord::Base

	include AASM

	belongs_to :user
	has_many :comments
	validates :title,presence: true, uniqueness: true
	validates :body,presence: true, length: { minimum: 20}
	before_save :set_visits_count
	after_create :save_categories
	after_create :send_mail

	 has_attached_file :cover, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
 	 validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/
	def categories=(value)
		@categories=value
	end
	def update_visits_count
		self.update(visits_count: self.visits_count + 1)
	end

	private
	def send_mail
		ArticleMailer.new_article(self).deliver_later
	end

	def save_categories
		unless @categories.nil?
		@categories.each do |category_id|
			HasCategory.create(category_id: category_id,article_id: self.id)
		end
		end
		
	end
	def set_visits_count
		self.visits_count ||= 0
	end
end
