import HomePage from './Pages/HomePage';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

import LoginPage from './Pages/LoginPage';
import RegisterPage from './Pages/RegisterPage';
import CreatePlaylist from './Components/CreatePlaylist';
import AddSongOnPlaylistPage from './Components/AddSongOnPlaylist';
import PlaylistDetails from './Components/PlaylistDetails';
import MiniPlayer from './Components/MiniPlayer';
import { AudioProvider, useAudio } from './ContextProvider/AudioContext';
import AboutArtist from './Components/AboutArtist';
import ProfilePage from './Pages/ProfilePage';
import FullScreenPlayer from './Components/FullScreenPlayer';

const AppContent = () => {
  const { isFullScreen } = useAudio(); // ✅ now INSIDE provider

  return (
    <Router>
      <Routes>
        <Route path='/' element={<HomePage />} />
        <Route path='/login' element={<LoginPage />} />
        <Route path='/profile' element={<ProfilePage />} />
        <Route path='/aboutartist' element={<AboutArtist />} />
        <Route path='/register' element={<RegisterPage />} />
        <Route path='/playlists' element={<CreatePlaylist />} />
        <Route path='/playlist/:playlistId' element={<PlaylistDetails />} />
        <Route path='/playlist/:playlistId/add' element={<AddSongOnPlaylistPage />} />
      </Routes>

      {isFullScreen && <FullScreenPlayer />}
      <MiniPlayer />
    </Router>
  );
};

const App = () => {
  return (
    <AudioProvider>
      <AppContent />
    </AudioProvider>
  );
};

export default App;
