require 'rails_helper'

RSpec.describe TimeController, type: :controller do
  describe '#index' do
    it 'renders UTC time' do
      get :index
      expect(response.body).to include(Time.now.utc.strftime('%Y-%m-%d %H:%M:%S'))
    end
  end

  describe '#city_time' do
    it 'renders city times' do
      allow(controller).to receive(:get_city_time).with('London').and_return('London Time')
      allow(controller).to receive(:get_city_time).with('New York').and_return('New York Time')

      get :city_time, params: { cities: 'London,New York' }

      expect(response.body).to include('London Time')
      expect(response.body).to include('New York Time')
    end
  end
end