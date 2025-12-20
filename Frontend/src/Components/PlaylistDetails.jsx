import React, { useEffect, useState } from "react"; 
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";
import MiniPlayer from "./MiniPlayer";
import { useAudio } from "../ContextProvider/AudioContext";  

const PlaylistDetails = () => {
  const { playlistId } = useParams();
  const [playlist, setPlaylist] = useState(null);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState("");
  const [currentSong, setCurrentSong] = useState(null);
  const navigate = useNavigate();

  const { playSong } = useAudio();   
 
  useEffect(() => {
    const fetchPlaylistDetails = async () => {
      try {
        const token = localStorage.getItem("Token");
        const res = await axios.get(`https://melodix-1.onrender.com/playlist/${playlistId}`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        setPlaylist(res.data.playlist);
      } catch (err) {
        setMessage(err.response?.data?.error || "Error fetching playlist");
      } finally {
        setLoading(false);
      }
    };
    fetchPlaylistDetails();
  }, [playlistId]);

  if (loading) return <p>Loading...</p>;
  if (!playlist) return <p>{message || "Playlist not found"}</p>;

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold">{playlist.playlist_name}</h2>
        <button
          onClick={() => navigate(`/playlist/${playlistId}/add`)}
          className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition"
        >
          + Add Songs
        </button>
      </div>

      <div className="space-y-5">
        {playlist.songs && playlist.songs.length > 0 ? (
          playlist.songs.map((song) => (
            <div
              key={song._id}
              className="flex items-center justify-between p-5 border rounded-lg shadow-lg hover:bg-gray-100 transition cursor-pointer"
              onClick={() => {
                setCurrentSong(song);
                playSong(song);    
              }}
            >
              <img
                src={song.Image || "https://via.placeholder.com/80"}
                alt={song.Title}
                className="w-16 h-16 object-cover rounded-lg"
              />

              <div className="flex-1 ml-6">
                <h3 className="font-bold text-2xl">{song.Title}</h3>
                <p className="text-gray-500 text-lg">{song.Singer}</p>
              </div>

              {song.Type && (
                <div className="mx-6 text-gray-400 text-lg italic">{song.Type}</div>
              )}
            </div>
          ))
        ) : (
          <p>No songs in this playlist yet</p>
        )}
      </div>

      <MiniPlayer song={currentSong} />
    </div>
  );
};

export default PlaylistDetails;
