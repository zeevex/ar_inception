# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.

describe '#escape_transaction' do
  before do
    @conn = ActiveRecord::Base.connection
  end

  it "should use same connection if not in a transaction" do
    ActiveRecord::Base.escape_transaction do
      ActiveRecord::Base.connection.should == @conn
    end
  end

  it "should use a different connection if in a transaction" do
    Things.transaction do
      ActiveRecord::Base.escape_transaction do
        ActiveRecord::Base.connection.should_not == @conn
      end
    end
  end

  it "should start with open_transactions == 0" do
    Things.transaction do
      ActiveRecord::Base.escape_transaction do
        ActiveRecord::Base.connection.open_transactions.should == 0
      end
    end
  end
end

describe '#escape_transaction_via_thread' do
  before do
    @conn = ActiveRecord::Base.connection
  end

  it "should use a different connection if not in a transaction" do
    ActiveRecord::Base.escape_transaction_via_thread do
      ActiveRecord::Base.connection.should_not == @conn
    end
  end

  it "should use a different connection if in a transaction" do
    Things.transaction do
      ActiveRecord::Base.escape_transaction_via_thread do
        ActiveRecord::Base.connection.should_not == @conn
      end
    end
  end

  it "should start with open_transactions == 0" do
    Things.transaction do
      ActiveRecord::Base.escape_transaction_via_thread do
        ActiveRecord::Base.connection.open_transactions.should == 0
      end
    end
  end
end
