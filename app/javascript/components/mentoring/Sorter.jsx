import React from 'react'

export function Sorter({ setSort, sort, sortOptions, id }) {
  function handleChange(e) {
    setSort(e.target.value)
  }

  return (
    <div className="c-mentor-sorter">
      <select id={id} onChange={handleChange} value={sort}>
        {sortOptions.map((sortOption) => {
          return (
            <option key={sortOption.value} value={sortOption.value}>
              {sortOption.label}
            </option>
          )
        })}
      </select>
    </div>
  )
}
