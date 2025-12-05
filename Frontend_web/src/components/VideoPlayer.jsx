import React from 'react'
import { useLocation } from 'react-router-dom'

const VideoPlayer = () => {
  const location=useLocation();
    const {videourl}=location.state || {};
  return (
    <video className='w-480 h-163 px-10 mt-10' src={videourl} controls>
  Your browser does not support the video tag.
</video>
  )
}

export default VideoPlayer