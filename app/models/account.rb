class Account < ApplicationRecord
  belongs_to :customer
  belongs_to :branch
  has_many :transactions

 def self.add(acc_attrs)
   account = Account.new(acc_attrs)
   account.save!
   account
 end

  def withdraw(acc_attr)
    if self.status == false
      raise ActiveRecord::RecordInvalid

    end
    update_attribute(:balance,self.balance - acc_attr)
  end

  def deactivate()
  if self.status == false
    raise ActiveRecord::RecordInvalid
  end
    update_attribute(:status, true)
  end

  def activate()
    if self.status == true
      raise ActiveRecord::RecordInvalid
    end
    update_attribute(:status, false)
  end
  end
