# frozen_string_literal: true

class Announcement < ApplicationRecord
	validates :title, presence: true
	validates :description, presence: true, allow_blank: true
	validates :user_id, presence:true, allow_blank: true
	validates :event_id, presence:true, allow_blank: true
	has_many :event
	belongs_to :user
end
