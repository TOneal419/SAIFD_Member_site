# frozen_string_literal: true

class Role < ApplicationRecord
	validates :role_id, presence: true
	validates :is_officer, allow_blank: true
	validates :is_admin, allow_blank: true
	validates :title, allow_blank: true
end
