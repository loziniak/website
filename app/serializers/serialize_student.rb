class SerializeStudent
  include Mandate

  def initialize(student, relationship:, anonymous_mode:)
    @student = student
    @relationship = relationship
    @anonymous_mode = anonymous_mode
  end

  def call
    return anonymous_details if anonymous_mode

    {
      id: student.id,
      handle: student.handle,
      name: student.name.presence, # TODO: We need a flag to protect this maybe?
      bio: student.bio.presence,
      location: student.location.presence,
      languages_spoken: student.languages_spoken,
      avatar_url: student.avatar_url,
      reputation: student.formatted_reputation,
      is_favorited: !!relationship&.favorited?,
      is_blocked: !!relationship&.blocked_by_mentor?,
      track_objectives: "Come from an OO background, looking to get into functional.", # TODO
      num_total_discussions: num_total_discussions,
      num_discussions_with_mentor: relationship&.num_discussions.to_i,
      links: {
        block: Exercism::Routes.block_api_mentoring_student_path(student.handle),
        favorite: Exercism::Routes.favorite_api_mentoring_student_path(student.handle),
        previous_sessions: Exercism::Routes.api_mentoring_discussions_path(student: student.handle, status: :all)
      }
    }
  end

  private
  attr_reader :student, :relationship, :anonymous_mode

  def anonymous_details
    {
      id: "anon-#{SecureRandom.uuid}",
      name: "User in Anonymous mode",
      handle: "anonymous",
      reputation: 0,
      num_discussions_with_mentor: 0
    }
  end

  def num_total_discussions
    Mentor::Discussion.joins(:solution).where('solutions.user_id': student.id).count
  end
end
