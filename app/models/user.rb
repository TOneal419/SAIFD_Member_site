class User < ApplicationRecord  
    validates :email, presence: true
    validates :first_name, presence: true, format: { with: /\A[A-Za-z][A-Za-z\'\-]+([\ A-Za-z][A-Za-z\'\-]+)*\z/, message: "make sure you only entered letters and appropriate special characters" }
    validates :last_name, presence: true, format: { with: /\A[A-Za-z][A-Za-z\'\-]+([\ A-Za-z][A-Za-z\'\-]+)*\z/, message: "make sure you only entered letters and appropriate special characters" }
    validates :class_year, presence: true, numericality: { greater_than_or_equal_to: 1876 }
    # note: we don't validate roleID or userID b/c end-user shouldn't have to worry about them
end
