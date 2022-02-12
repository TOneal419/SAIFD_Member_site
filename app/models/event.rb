# frozen_string_literal: true

class Event < ApplicationRecord
	validates :event_id, presence: true
	validates :title, presence: true
	validates :description, presence: true, allow_blank: true
	validates :date, presence: true
end
