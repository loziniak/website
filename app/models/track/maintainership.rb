class Track::Maintainership < ApplicationRecord
  belongs_to :maintainer,
    class_name: "User",
    foreign_key: :user_id,
    inverse_of: :maintainerships

  enum maintainer_type: { reviewer: 0, track: 1, other: 2 }, _suffix: :maintainer
  enum maintainer_level: { apprentice: 0, regular: 1, senior: 2 }, _suffix: :maintainer
  enum component_type: { track: 0, configlet: 1, senior: 2 }, _suffix: :maintainer

  def maintainer_type
    super.to_sym
  end

  def maintainer_level
    super.to_sym
  end
end
