FactoryBot.define do
  factory :track_maintainership, class: 'Track::Maintainership' do
    maintainer { create :user }
    component do
      Track.find_by(slug: :ruby) || build(:track, slug: 'ruby')
    end
    visible { true }
    maintainer_type { :track }
    maintainer_level { :apprentice }
  end
end
