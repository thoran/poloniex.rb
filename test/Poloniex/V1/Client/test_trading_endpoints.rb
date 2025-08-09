require_relative '../../../helper'

describe "Poloniex::V1::Client Trading Endpoints" do
  let(:api_key){ENV.fetch('POLONIEX_API_KEY', '<API_KEY>')}
  let(:api_secret){ENV.fetch('POLONIEX_API_SECRET', '<API_SECRET>')}

  subject do
    Poloniex::V1::Client.new(
      api_key: api_key,
      api_secret: api_secret
    )
  end

  describe "#create_order" do
    it "creates a new order" do
      VCR.use_cassette('v1/create_order') do
        response = subject.create_order(
          symbol: 'BTC_USDT',
          side: 'BUY',
          type: 'LIMIT',
          quantity: 0.001,
          price: 20_000
        )
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "create_multiple_orders" do
    let(:order0) do
      {
        symbol: 'BTC_USDT',
        side: 'BUY',
        type: 'LIMIT',
        quantity: 0.01,
        price: 15_000
      }
    end

    let(:order1) do
      {
        symbol: 'BTC_USDT',
        side: 'BUY',
        type: 'LIMIT',
        quantity: 0.1,
        price: 8_000
      }
    end

    it "gets an order by ID" do
      VCR.use_cassette('v1/create_multiple_orders') do
        response = subject.create_multiple_orders([order0, order1])
        _(response).must_be_kind_of(Array)
      end
    end
  end

  describe "#cancel_replace_order" do
    it "" do
      VCR.use_cassette('v1/cancel_replace_order') do
        response = subject.cancel_replace_order(order_id: 'blue')
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "#open_orders" do
    it "retrieves the open orders" do
      VCR.use_cassette('v1/open_orders') do
        response = subject.open_orders
        _(response).must_be_kind_of(Array)
      end
    end

    it "retrieves the open orders for a specific symbol" do
      VCR.use_cassette('v1/open_orders_btc_usdt') do
        response = subject.open_orders(symbol: 'BTC_USDT')
        _(response).must_be_kind_of(Array)
      end
    end
  end

  describe "#order_details" do
    it "" do
      VCR.use_cassette('v1/orders_details') do
        response = subject.order_details(order_id: '21934611974062080')
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "#cancel_order" do
    it "" do
      VCR.use_cassette('v1/cancel_order') do
        response = subject.cancel_order(order_id: '32487004629499904')
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "#cancel_multiple_orders" do
    it "" do
      VCR.use_cassette('v1/cancel_multiple_orders') do
        response = subject.cancel_multiple_orders(order_ids: ['12345', '67890'])
        _(response).must_be_kind_of(Array)
      end
    end
  end

  describe "#cancel_all_orders" do
    it "" do
      VCR.use_cassette('v1/cancel_all_orders') do
        response = subject.cancel_all_orders
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "#kill_switch" do
    it "" do
      VCR.use_cassette('v1/kill_switch') do
        response = subject.kill_switch(timeout: 10)
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "#kill_switch_status" do
    it "" do
      VCR.use_cassette('v1/kill_switch_status') do
        response = subject.kill_switch_status
        _(response).must_be_kind_of(Hash)
      end
    end
  end
end
