# This class represents the home model
# It belongs to an user and is composed of devices, scenarios and tasks
class Home < ApplicationRecord
  validates :name, :location, :ip_address, :tunnel, presence: true

  belongs_to :user
  belongs_to :delayed_job, class_name: "::Delayed::Job", dependent: :destroy

  has_many :timed_tasks, class_name: "Tasks::TimedTask", dependent: :destroy
  has_many :triggered_tasks, class_name: "Tasks::TriggeredTask", dependent: :destroy
  has_many :scenarios, dependent: :destroy
  has_many :things, dependent: :destroy

  has_many :lights, class_name: "Things::Light"
  has_many :locks, class_name: "Things::Lock"
  has_many :thermostats, class_name: "Things::Thermostat"
  has_many :weathers, class_name: "Things::Weather"
  has_many :motion_sensors, class_name: "Things::MotionSensor"

  def fetch_token
    token = Curl.get(token_uri) do |http|
      http.headers["Content-Type"] = "application/json"
      http.headers["Authorization"] = token
    end.body_str

    update_attribute(:token, token)
  end

  private

  def token_uri
    tunnel + "/token"
  end
end
