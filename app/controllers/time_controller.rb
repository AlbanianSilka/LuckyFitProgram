class TimeController < ApplicationController
  def index
    render plain: "UTC: #{Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')}"
  end

  def city_time
    cities = params[:cities].split(',')
    response = "UTC: #{Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')}\n"

    cities.each do |city|
      response += "#{city}: #{get_city_time(city)}\n"
    end

    render plain: response
  end

  private

  def get_city_time(city)
    Timezone::Lookup.config(:google) do |c|
      c.api_key = ENV['GOOGLE_MAPS_API_KEY']
    end

    location = Geocoder.search(city).first
    return render json: { message: 'City not found', success: false },
                  status: :unprocessable_entity unless location
    lat, lon = location.coordinates
    timezone = Timezone.lookup(lat, lon)
    return render json: { message: 'Wrong timezone', success: false },
                  status: :unprocessable_entity unless timezone
    current_time = timezone.time(Time.now)
    current_time.strftime('%Y-%m-%d %H:%M:%S')
  end
end