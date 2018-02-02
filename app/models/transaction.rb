class Transaction < ApplicationRecord

  def self.list
    Transaction.all
  end
end
