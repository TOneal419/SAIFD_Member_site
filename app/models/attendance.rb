# frozen_string_literal: true

class Attendance < ApplicationRecord
	validates :event_id, presence: true
	validates :user_id, presence: true
	validates :attend_time_start, presence: true, allow_blank: true
	validates :attend_time_end, presence: true, allow_blank: true
	validates :plans_to_attend, presence: true, allow_blank: true
end
