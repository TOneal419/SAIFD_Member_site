# frozen_string_literal: true

class Role < ApplicationRecord
	validates :role_id, presence: true
	validates :is_officer, presence: true, allow_blank: true
	validates :is_admin, presence: true, allow_blank: true
	validates :title, presence: true, allow_blank: true
end
