require "rails_helper"

describe Orderbook do
  before(:each) { Orderbook.send(:remove_const, "BTCUSD") if defined?(Orderbook::BTCUSD) }

  describe ".ask_unit" do
    it "returns ask unit" do
      expect(Orderbook[:btc, :usd].ask_unit).to eq "btc"
    end
  end

  describe ".bid_unit" do
    it "returns bid unit" do
      expect(Orderbook[:btc, :usd].bid_unit).to eq "usd"
    end
  end

  it "creates table and returns constant" do
    expect(Orderbook[:btc, :usd].to_s).to eq "Orderbook::BTCUSD"
    expect(ActiveRecord::Base.connection.tables).to include "orderbook_btc_usd"
  end

  it "doesn't try to create table multiple times" do
    Orderbook.expects(:create_table).with(:btc, :usd).once.returns(true)
    10.times { Orderbook[:btc, :usd] }
  end

  it "doesn't try to create table is constant is defined" do
    Orderbook.const_set("BTCUSD", Class.new)
    Orderbook.expects(:create_table).never
    10.times { Orderbook[:btc, :usd] }
  end
end
