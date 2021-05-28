class Track::Maintainership < ApplicationRecord
  belongs_to :maintainer,
    class_name: "User",
    foreign_key: :user_id,
    inverse_of: :maintainerships

  belongs_to :component, polymorphic: true

  enum maintainer_type: { track: 0, reviewer: 1 }, _suffix: :maintainer
  enum maintainer_level: { apprentice: 0, regular: 1, senior: 2 }, _suffix: :maintainer
  enum component_type: { Track: 0 }, _prefix: true

  %i[maintainer_type maintainer_level component_type].each do |meth|
    define_method(meth) { super().to_sym }
  end

  def track
    return nil unless component_type == :Track

    component
  end
end
