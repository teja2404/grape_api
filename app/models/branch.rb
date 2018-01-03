class Branch < ApplicationRecord
  has_many :customers
  has_many :accounts
end
 