class Account < ApplicationRecord
  belongs_to :customer
  belongs_to :branch
  has_many :transactions

  def self.add(acc_attrs)
    customer = Customer.find(acc_attrs[:customer_id])
    if customer.account
      ActiveRecord::RecordNotSaved
    end
    customer.create_account!(acc_attrs)
  end

  def withdraw(acc_attr)
    if self.status == false || self.balance == 0.0
      raise ActiveRecord::RecordInvalid

    end
    update_attribute(:balance,BigDecimal.new(self.balance.to_s) - BigDecimal.new(acc_attr[:amount].to_s))
    Transaction.create(details: "#{acc_attr[:amount]} rupees debited from your account",account_id: id)
  end

  def deposit(acc_attr)
    if self.status == false
      raise ActiveRecord::RecordInvalid

    end
    update_attribute(:balance,BigDecimal.new(self.balance.to_s) + BigDecimal.new(acc_attr[:amount].to_s))
    Transaction.create(details: "#{acc_attr[:amount]} rupees credited to your account",account_id: id)
  end

  def deactivate()
    if self.status == false
      raise ActiveRecord::RecordInvalid
    end
    update_attribute(:status, false)
  end


  def self.transfer(acc_attr)
    frm_account = Account.find(acc_attr[:frm_account].to_i)
    to_account  = Account.find(acc_attr[:to_account].to_i)
    if frm_account.status == false || to_account.status == false || frm_account.balance == 0.0
      raise ActiveRecord::RecordInvalid
    end
    frm_account.withdraw(acc_attr)
    to_account.deposit(acc_attr)
    Transaction.create(details: "#{acc_attr[:amount]} rupees credited to your account",account_id: to_account.id)
    Transaction.create(details: "#{acc_attr[:amount]} rupees debited from your account",account_id: frm_account.id)

  end

  def activate()
    if self.status == true
      raise ActiveRecord::RecordInvalid
    end
    update_attribute(:status, true)
  end
end
