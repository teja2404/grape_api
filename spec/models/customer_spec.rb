require "rails_helper"

RSpec.describe Customer, :type => :model do

  before(:each) do
    Branch.delete_all
    Customer.delete_all
    @branch=Branch.create(branch_name: "first branch")
  end

  context "Validation of customer Creation" do
    it "should not create customer if name is blank" do
      expect{Customer.add(name: "", email: "ad@k.com", phone: 14134, branch_id:@branch.id)}.to raise_error ActiveRecord::RecordInvalid
    end

    it "should not create customer if phone is blank" do
      expect{Customer.add(name: "fcv", email: "ad@k.com",  branch_id:@branch.id)}.to raise_error ActiveRecord::RecordInvalid
    end

    it "should not create customer if email is blank" do
      expect{Customer.add(name: "fbvb", email: "", phone: 14134, branch_id:@branch.id)}.to raise_error ActiveRecord::RecordInvalid
    end

    it "should not create customer if branch is blank" do
      expect{Customer.add(name: "fbfb", email: "ad@k.com", phone: 14134, branch_id: nil)}.to raise_error ActiveRecord::RecordInvalid
    end

    it "should create customer" do
      customer = Customer.add(name: "fbfb", email: "ad@k.com", phone: 123456, branch_id: @branch.id)
      expect(customer.name).to eq("fbfb")
      expect(customer.email).to eq("ad@k.com")
      expect(customer.phone).to eq(123456)
      expect(customer.status).to eq(true)
    end

    it "should update customer" do
      customer = Customer.add(name: "fbfb", email: "ad@k.com", phone: 123456, branch_id: @branch.id)
      customer.update_customer(name: "fv")
      expect(customer.name).to eq "fv"
    end

  end
  context "customer deactivate test cases" do
    it "should not deactivate customer if customer is already deactivated" do
      customer = Customer.add(name: "fbfb", email: "ad@k.com", phone: 123456, branch_id: @branch.id)
      customer.deactivate()
      customer.reload
      expect{customer.deactivate()}.to raise_error ActiveRecord::RecordInvalid

    end

    it "should deativate the customer" do
      customer = Customer.add(name: "fbfb", email: "ad@k.com", phone: 123456, branch_id: @branch.id)
      customer.deactivate()
      expect(customer.status).to eq false
    end
  end

  context "customer activate test cases" do

    it "should not activate customer if customer is already activated" do
      customer = Customer.add(name: "fbfb", email: "ad@k.com", phone: 123456, branch_id: @branch.id)
      customer.activate()
      customer.reload
      expect{customer.activate()}.to raise_error ActiveRecord::RecordInvalid
    end

    it "should activate customer" do
      customer = Customer.add(name: "fbfb", email: "ad@k.com", phone: 123456, branch_id: @branch.id)
      customer.activate()
      expect(customer.status).to eq true
    end

  end

  context "list of customer accounts" do
     it "it should not list accounts if customer is deactivated" do
       customer = Customer.add(name: "fbfb", email: "ad@k.com", phone: 123456, branch_id: @branch.id, status: false)
      expect {customer.list_accounts()}.to raise_error ActiveRecord::RecordInvalid

     end

    it "should list accounts if customer is active" do
      customer = Customer.add(name: "fbfb", email: "ad@k.com", phone: 123456, branch_id: @branch.id)
      accounts = customer.list_accounts()
      expect(accounts).to eq(nil)
    end
  end




end 