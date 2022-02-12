class Announcement < ApplicationRecord
	validates :title, presence: true
	validates :description, allow_blank: true
	validates :posted_on, presence: true
	validates :user_id, presence:true
	validates :announcement_id, presence:true
end
