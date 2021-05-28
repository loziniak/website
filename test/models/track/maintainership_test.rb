require "test_helper"

class Track::MaintainershipTest < ActiveSupport::TestCase
  test "track" do
    track = create :track
    maintainership = create :track_maintainership, component: track

    assert_equal track, maintainership.track
  end

  test "maintainer" do
    maintainer = create :user
    maintainership = create :track_maintainership, maintainer: maintainer

    assert_equal maintainer, maintainership.maintainer
  end

  test "maintainer_type" do
    maintainership = create :track_maintainership, maintainer_type: :track

    assert_equal :track, maintainership.maintainer_type
    assert maintainership.track_maintainer?
    refute maintainership.reviewer_maintainer?
  end

  test "maintainer_level" do
    maintainership = create :track_maintainership, maintainer_level: :apprentice

    assert_equal :apprentice, maintainership.maintainer_level
    assert maintainership.apprentice_maintainer?
    refute maintainership.regular_maintainer?
    refute maintainership.senior_maintainer?
  end
end
