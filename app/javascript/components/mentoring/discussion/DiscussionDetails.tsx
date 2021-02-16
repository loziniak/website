import React, { useRef } from 'react'
import {
  Discussion,
  Iteration,
  Partner,
  StudentMentorRelationship,
} from '../Session'
import { FinishedWizard } from './FinishedWizard'
import { DiscussionPostList } from './DiscussionPostList'

export const DiscussionDetails = ({
  discussion,
  iterations,
  student,
  relationship,
  userId,
}: {
  discussion: Discussion
  iterations: readonly Iteration[]
  student: Partner
  relationship: StudentMentorRelationship
  userId: number
}): JSX.Element => {
  const previouslyNotFinishedRef = useRef(!discussion.isFinished)
  const step = previouslyNotFinishedRef.current ? 'mentorAgain' : 'finish'

  return (
    <React.Fragment>
      <DiscussionPostList
        endpoint={discussion.links.posts}
        iterations={iterations}
        student={student}
        discussionId={discussion.id}
        userId={userId}
      />
      {discussion.isFinished ? (
        <FinishedWizard
          student={student}
          relationship={relationship}
          defaultStep={step}
        />
      ) : null}
    </React.Fragment>
  )
}