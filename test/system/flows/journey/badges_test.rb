require "application_system_test_case"
require_relative "../../../support/capybara_helpers"

module Flows
  module Journey
    class BadgesTest < ApplicationSystemTestCase
      include CapybaraHelpers

      test "user reveals a badge" do
        user = create :user
        create :user_acquired_badge, revealed: false, user: user

        use_capybara_host do
          sign_in!(user)
          visit badges_journey_url
          click_on "Unrevealed"

          within(".m-badge") do
            assert_text "Member"
            assert_text "New Badge Earned"
          end

          page.find(".ReactModal__Overlay").click(x: 0, y: 0)

          assert_text "Member"
        end
      end

      test "user views a badge" do
        user = create :user
        create :user_acquired_badge, revealed: true, user: user

        use_capybara_host do
          sign_in!(user)
          visit badges_journey_url
          click_on "Member"

          within(".m-badge") do
            assert_text "Member"
            assert_no_text "New Badge Earned"
          end
        end
      end
    end
  end
end
