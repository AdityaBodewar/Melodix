import React from 'react'
import AddSongForm from './components/AddSongForm'
import GetAllSongs from './components/GetAllSongs'
import { BrowserRouter as Router ,Routes,Route } from 'react-router-dom'
import VideoPlayer from './components/VideoPlayer'

const App = () => {
  return (
    <div>
      <Router>
        <Routes>
          <Route path='/' element={<GetAllSongs/>}/>
          <Route path="/video-player" element={<VideoPlayer />}/>
        </Routes>
      </Router>
     
    </div>
  )
}

export default App
