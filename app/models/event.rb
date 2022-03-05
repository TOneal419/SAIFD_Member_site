# frozen_string_literal: true

class Event < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true, allow_blank: true
  validates :date, presence: true
  validates :event_time_start, presence: true
  validates :event_time_end, presence: true
  has_many :announcement
end
