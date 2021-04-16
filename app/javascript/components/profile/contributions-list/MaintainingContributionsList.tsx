import React from 'react'
import { Contribution as ContributionProps } from '../../types'
import { TrackIcon, Reputation, GraphicalIcon } from '../../common'
import { fromNow } from '../../../utils/time'

export const MaintainingContributionsList = ({
  contributions,
  userHandle,
}: {
  contributions: readonly ContributionProps[]
  userHandle: string
}): JSX.Element => {
  return (
    <div className="maintaining">
      {contributions.map((contribution) => (
        <Contribution
          key={contribution.id}
          userHandle={userHandle}
          {...contribution}
        />
      ))}
    </div>
  )
}

const Contribution = ({
  value,
  text,
  iconUrl,
  internalUrl,
  externalUrl,
  awardedAt,
  track,
  userHandle,
}: ContributionProps & { userHandle: string }): JSX.Element => {
  const url = internalUrl || externalUrl
  const linkIcon = url === internalUrl ? 'chevron-right' : 'external-link'
  const parsedText = text
    .replace(/^You reviewed/, 'Reviewed')
    .replace(/^You merged/, 'Merged')

  return (
    <a href={url} className="reputation-token">
      <img
        alt=""
        role="presentation"
        src={iconUrl}
        className="c-icon primary-icon"
      />
      <div className="info">
        <div
          className="title"
          dangerouslySetInnerHTML={{
            __html: parsedText,
          }}
        />
        <div className="extra">
          {track ? (
            <div className="exercise">
              in
              <TrackIcon
                iconUrl={track.iconUrl}
                title={track.title}
                className="primary-icon"
              />
              <div className="name">{track.title}</div>
            </div>
          ) : (
            <div className="generic">Generic</div>
          )}
          <time dateTime={awardedAt}>{fromNow(awardedAt)}</time>
        </div>
      </div>
      <Reputation value={`+ ${value}`} type="primary" size="small" />
      <GraphicalIcon icon={linkIcon} className="action-button" />
    </a>
  )
}