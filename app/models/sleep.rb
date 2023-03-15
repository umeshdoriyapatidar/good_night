class Sleep < ApplicationRecord
  belongs_to :user
  validates :asleep_at, :woke_up_at, presence: true
  before_save :set_duration
  validate :validate_duration_not_in_future, :asleep_at_is_before_woke_up_at, on: :create

  private
  def validate_duration_not_in_future
    if self.woke_up_at.present? && self.woke_up_at > Time.zone.now
      errors.add(:woke_up_at, "can't be in the future")
    end
  end

  def asleep_at_is_before_woke_up_at
    if self.woke_up_at <= self.asleep_at
      errors.add(:woke_up_at, "can't be before asleep")
    end
  end

  def set_duration
    duration_seconds = Time.parse(self.woke_up_at.to_s) - Time.parse(self.asleep_at.to_s)
    formated_hash = Time.at(duration_seconds).utc.strftime("%H:%M:%S")
    self.duration = formated_hash
  end
end
