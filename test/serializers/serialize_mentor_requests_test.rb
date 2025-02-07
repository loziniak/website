require 'test_helper'

class SerializeMentorRequestsTest < ActiveSupport::TestCase
  test "basic request" do
    student = create :user
    mentor = create :user
    track = create :track
    exercise = create :concept_exercise, track: track
    solution = create :concept_solution, exercise: exercise, user: student
    request = create :mentor_request, solution: solution

    expected = [
      {
        id: request.uuid,

        track_title: track.title,
        exercise_title: exercise.title,
        exercise_icon_url: exercise.icon_url,

        student_handle: student.handle,
        student_avatar_url: student.avatar_url,
        updated_at: request.created_at.iso8601,

        have_mentored_previously: false,
        is_favorited: false,
        status: "First timer",
        tooltip_url: Exercism::Routes.api_mentoring_student_path(student),

        url: Exercism::Routes.mentoring_request_url(request)
      }
    ]

    assert_equal expected, SerializeMentorRequests.(Mentor::Request.all, mentor)
  end

  test "mentored before" do
    student = create :user
    create :mentor_request, solution: create(:concept_solution, user: student)

    mentor = create :user
    relationship = create :mentor_student_relationship, student: student, mentor: mentor

    result = SerializeMentorRequests.(Mentor::Request.all, mentor)
    assert result[0][:have_mentored_previously]
    refute result[0][:is_favorited]

    relationship.update(favorited: true)
    result = SerializeMentorRequests.(Mentor::Request.all, mentor)
    assert result[0][:is_favorited]
  end

  test "status" do
    student = create :user
    mentor = create :user
    create :mentor_request, solution: create(:concept_solution, user: student)

    result = SerializeMentorRequests.(Mentor::Request.all, mentor)
    assert_equal "First timer", result[0][:status]

    create :mentor_discussion, solution: create(:practice_solution, user: student)

    result = SerializeMentorRequests.(Mentor::Request.all, mentor)
    assert_nil result[0][:status]
  end
end
