class Customer < ApplicationRecord
  has_one :account
  belongs_to :branch

  validates_presence_of :name, :email, :phone
  validates_uniqueness_of :name,:email
  validates_format_of :email, :with => /^([a-zA-Z0-9_.'-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/i, :message => "Email is Invalid", :multiline => true

  def self.add(cust_attrs)
    customer = Customer.new(cust_attrs)
    customer.save!
    customer
  end

  def update_customer(cust_attrs)
    update_attributes(cust_attrs)
  end

  def deactivate()
   if self.status == false
     raise ActiveRecord::RecordInvalid
   end
    update_attribute(:status,false)
  end

  def activate()
    if self.status == true
      raise ActiveRecord::RecordInvalid
    end
    update_attribute(:status, true)
  end

  def list_accounts()
    if self.status == false
      raise ActiveRecord::RecordInvalid
    end
    account
  end
end
 