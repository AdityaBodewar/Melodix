import HomePage from './Pages/HomePage';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

import LoginPage from './Pages/LoginPage';
import RegisterPage from './Pages/RegisterPage';
import CreatePlaylist from './Components/CreatePlaylist';
import AddSongOnPlaylistPage from './Components/AddSongOnPlaylist';
import PlaylistDetails from './Components/PlaylistDetails';
import MiniPlayer from './Components/MiniPlayer';
import { AudioProvider } from './ContextProvider/AudioContext';
import AboutArtist from './Components/AboutArtist';


const App = () => {
  return (
   <AudioProvider>
      <Router>
        <Routes>
          <Route path='/' element={<HomePage />} />
          <Route path='/login' element={<LoginPage />} />
           <Route path='/aboutartist' element={<AboutArtist/>} />
          <Route path='/register' element={<RegisterPage />} />
          <Route path='/playlists' element={<CreatePlaylist />} />
          <Route path='/playlist/:playlistId' element={<PlaylistDetails />} />
          <Route path='/playlist/:playlistId/add' element={<AddSongOnPlaylistPage />} />
        </Routes>

        
        <MiniPlayer />
      </Router>
    </AudioProvider>
  );
};

export default App;
