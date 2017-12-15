require "rails_helper"

RSpec.describe Account, :type => :model do

  before(:each) do
    Branch.delete_all
    Customer.delete_all
    @branch=Branch.create(branch_name: "first branch")
   @customer= Customer.create(name: "bkjbjk", email: "ad@k.com", phone: 14134, branch_id:@branch.id)
  end


    it "should create an account" do
      account = Account.add(customer_id: @customer.id, account_type: 1, branch_id: @branch.id)
      expect(account.customer_id).to eq @customer.id
      expect(account.account_type).to eq "1"
      expect(account.branch_id).to eq @branch.id
    end

    it "should not create account if baranch id is blank" do
      expect{Account.add(customer_id: @customer.id, account_type: 1)}.to raise_error ActiveRecord::RecordInvalid

    end

  
  end
