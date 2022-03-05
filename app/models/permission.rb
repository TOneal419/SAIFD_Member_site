# frozen_string_literal: true

# Permission Entity
class Permission < ApplicationRecord
  belongs_to :user
end
