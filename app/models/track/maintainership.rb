class Track::Maintainership < ApplicationRecord
  belongs_to :maintainer,
    class_name: "User",
    foreign_key: :user_id,
    inverse_of: :maintainerships

  belongs_to :component, polymorphic: true

  enum maintainer_type: { track: 0, review: 1 }, _suffix: :maintainer
  enum maintainer_level: { apprentice: 0, regular: 1, senior: 2 }, _suffix: :maintainer
  enum component_type: { Track: 0 }, _prefix: true

  def maintainer_type
    super.to_sym
  end

  def maintainer_level
    super.to_sym
  end

  def component_type
    super.to_sym
  end

  def track
    return nil unless component_type == :Track

    component
  end
end
