import React, { useCallback, useState, useEffect } from 'react'
import { Request, usePaginatedRequestQuery } from '../../hooks/request-query'
import { TagsFilter } from './tracks-list/TagsFilter'
import { List } from './tracks-list/List'
import { useIsMounted } from 'use-is-mounted'
import { ResultsZone } from '../ResultsZone'
import { useList } from '../../hooks/use-list'
import { StudentTrack } from '../types'
import { useHistory, removeEmpty } from '../../hooks/use-history'

type APIResponse = {
  tracks: StudentTrack[]
}

export type TagOption = {
  category: string
  options: {
    value: string
    label: string
  }[]
}

export const TracksList = ({
  tagOptions,
  request: initialRequest,
}: {
  tagOptions: readonly TagOption[]
  request: Request
}): JSX.Element => {
  const isMountedRef = useIsMounted()
  const { request, setCriteria: setRequestCriteria, setQuery } = useList(
    initialRequest
  )
  const [criteria, setCriteria] = useState(request.query?.criteria || '')
  const CACHE_KEY = ['track-list', request.endpoint, request.query]
  const { resolvedData, isError, isFetching } = usePaginatedRequestQuery<
    APIResponse
  >(CACHE_KEY, request, isMountedRef)

  const setTags = useCallback(
    (tags) => {
      setQuery({ ...request.query, tags: tags })
    },
    [request.query, setQuery]
  )

  const sortedTracks = resolvedData?.tracks.sort((a, b) => {
    if (a.lastTouchedAt === null || b.lastTouchedAt === null) {
      return 0
    }

    return a.lastTouchedAt > b.lastTouchedAt ? -1 : 1
  })

  useHistory({ pushOn: removeEmpty(request.query) })

  useEffect(() => {
    const handler = setTimeout(() => {
      setRequestCriteria(criteria)
    }, 200)

    return () => {
      clearTimeout(handler)
    }
  }, [setRequestCriteria, criteria])

  return (
    <div className="c-tracks-list">
      <section className="c-search-bar">
        <div className="lg-container container">
          <input
            type="text"
            placeholder="Search language tracks"
            className="--search"
            onChange={(e) => setCriteria(e.target.value)}
            value={criteria}
          />
          <TagsFilter
            setTags={setTags}
            options={tagOptions}
            value={request.query.tags}
            numTracks={resolvedData ? resolvedData.tracks.length : 0}
          />
          <div className="c-select">
            <select>
              <option>Sort by last touched</option>
            </select>
          </div>
        </div>
      </section>
      <section className="lg-container container">
        {isError && <p>Something went wrong</p>}
        {resolvedData && (
          <ResultsZone isFetching={isFetching}>
            {sortedTracks ? <List data={sortedTracks} /> : null}
          </ResultsZone>
        )}
      </section>
    </div>
  )
}
