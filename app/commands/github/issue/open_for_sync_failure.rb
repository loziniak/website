module Github
  class Issue
    class OpenForSyncFailure
      include Mandate

      initialize_with :track, :error, :git_sha

      def call
        if missing?
          create_issue
        elsif closed?
          reopen_issue
        end
      end

      private
      def create_issue
        title = "🤖 Sync error for commit #{git_sha[0..5]}"
        body = <<~BODY.strip
          We hit an error trying to sync the latest commit (#{git_sha}) to the website.

          The error was:
          ```
          #{error.message}

          #{error.backtrace}
          ```

          Please tag @iHiD if you require more information.
        BODY

        Exercism.octokit_client.create_issue(repo, title, body)
      end

      def reopen_issue
        Exercism.octokit_client.reopen_issue(repo, issue.number)
      end

      def missing?
        issue.nil?
      end

      def closed?
        issue.state == "closed"
      end

      memoize
      def repo
        "exercism/#{track.slug}"
      end

      memoize
      def issue
        # TODO: Elevate this into exercism-config gem
        author = "exercism-bot"
        Exercism.octokit_client.search_issues("#{git_sha} is:issue in:body repo:#{repo} author:#{author}")[:items]&.first
      end
    end
  end
end
