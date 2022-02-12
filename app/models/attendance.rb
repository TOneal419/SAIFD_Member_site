# frozen_string_literal: true

class Attendance < ApplicationRecord
	validates :event_id, presence: true
	validates :user_id, presence: true
	validates :attend_time_start, presence: true
	validates :attend_time_end, presence: true
end
