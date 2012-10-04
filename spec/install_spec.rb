# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.

describe 'installation' do
  it "should define escape_transaction method" do
    ActiveRecord::Base.respond_to?(:escape_transaction).should be_true
  end

  it "should define escape_transaction_via_thread method" do
    ActiveRecord::Base.respond_to?(:escape_transaction_via_thread).should be_true
  end
end
