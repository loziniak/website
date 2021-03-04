module ReactComponents
  module Student
    class IterationPage < ReactComponent
      initialize_with :solution

      def to_s
        super(
          "student-iteration-report",
          {
            solution_id: solution.uuid,
            request: request,
            exercise: {
              title: exercise.title
            },
            track: {
              title: track.title,
              icon_url: track.icon_url,
              highlightjs_language: track.highlightjs_language
            },
            links: {
              get_mentoring: Exercism::Routes.track_exercise_mentoring_index_url(track, exercise),
              automated_feedback_info: "TODO"
            }
          }
        )
      end

      private
      delegate :exercise, :track, to: :solution

      def request
        {
          endpoint: Exercism::Routes.temp_solution_url(solution.uuid),
          options: {
            initialData: {
              iterations: solution.
                iterations.
                order(id: :desc).
                map { |iteration| SerializeIteration.(iteration) }
            }
          }
        }
      end
    end
  end
end
