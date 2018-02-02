require "rails_helper"

RSpec.describe Account, :type => :model do

  before(:each) do
    Branch.delete_all
    Customer.delete_all
    @branch=Branch.create(branch_name: "first branch")
    @customer = Customer.create(name: "john", email: "ad@k.com", phone: 14134, branch_id:@branch.id)
    @customer1 = Customer.create(name: "sample", email: "ad1@k.com", phone: 14134, branch_id:@branch.id)
  end

  context "account creation test cases" do
    it "should create an account" do
      account = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id)
      expect(account.customer_id).to eq @customer.id
      expect(account.account_type).to eq "saving"
      expect(account.branch_id).to eq @branch.id
    end

    it "should not create account if baranch id is blank" do
      expect{Account.add(customer_id: @customer.id, account_type: "saving")}.to raise_error ActiveRecord::RecordInvalid
    end

    it "should not create account if customer id is blank" do
      expect{Account.add(customer_id: @customer.id, account_type: "saving")}.to raise_error ActiveRecord::RecordInvalid
    end

    it "should not create account if customer as already a account" do
      account = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id)
      expect{Account.add(customer_id: @customer.id, account_type: "saving")}.to raise_error ActiveRecord::RecordNotSaved
    end
  end

  context "Account deactivation test cases" do
    it "should deactivate the account" do
      account = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id)
      account.deactivate()
      expect(account.status).to eq false
    end

    it "should through error if account is already deactivated" do
      account = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id)
      account.deactivate()
      expect{account.deactivate()}.to raise_error ActiveRecord::RecordInvalid
    end
  end

  context "Account activation test cases" do
    it "should activate the account" do
      account = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id,status:false)
      account.activate()
      expect(account.status).to eq true
    end

    it "should through error if account is already activated" do
      account = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id)
      expect{account.activate()}.to raise_error ActiveRecord::RecordInvalid
    end
  end

  context "Account withdrawal test cases" do
    it "should withdraw amount from account" do
      account = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id,balance:4000.0)
      account.withdraw(amount:1000)
      expect(account.balance).to eq(3000)
    end

    it "should through error if account balance is nil" do
      account = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id)
      expect{account.withdraw(amount:1000)}.to raise_error ActiveRecord::RecordInvalid
    end

    it "should through error if account is inactive" do
      account = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id,status:false)
      expect{account.withdraw(amount:1000)}.to raise_error ActiveRecord::RecordInvalid
    end
  end

  context "Account deposit test cases" do
    it "should credit amount from account" do
      account = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id,balance:4000.0)
      account.deposit(amount:1000)
      expect(account.balance).to eq(5000)
    end

    it "should through error if account is inactive" do
      account = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id,status:false)
      expect{account.deposit(amount:1000)}.to raise_error ActiveRecord::RecordInvalid
    end
  end

  context "test cases for account to account transfer" do
    it "should succesfully transfer amount between" do
      account1 = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id,balance:4000.0)
      account2 = Account.add(customer_id: @customer1.id, account_type: "saving", branch_id: @branch.id,balance:4000.0)
      Account.transfer(frm_account:account1.id,to_account:account2.id,amount:1000.0)
      account1.reload()
      account2.reload()
      expect(account2.balance).to eq(5000.0)
      expect(account1.balance).to eq(3000.0)
    end

    it "should through error if either of account is inactive" do
      account1 = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id,balance:4000.0, status:false)
      account2 = Account.add(customer_id: @customer1.id, account_type: "saving", branch_id: @branch.id,balance:4000.0)
      expect{ Account.transfer(frm_account:account1.id,to_account:account2.id,amount:1000.0)}.to raise_error ActiveRecord::RecordInvalid
    end

    it "should through error if account  balance is nil" do
      account1 = Account.add(customer_id: @customer.id, account_type: "saving", branch_id: @branch.id, balance:0.0, status:false)
      account2 = Account.add(customer_id: @customer1.id, account_type: "saving", branch_id: @branch.id,balance:4000.0)
      expect{ Account.transfer(frm_account:account1.id,to_account:account2.id,amount:1000.0)}.to raise_error ActiveRecord::RecordInvalid
    end
  end
end